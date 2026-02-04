import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:todo/core/failure.dart';
import 'package:todo/data/data_sources/remote/api.dart';
import 'package:todo/data/data_sources/remote/interceptors/auth_token_interceptors.dart';
import 'package:todo/data/data_sources/remote/interceptors/my_log_interceptors.dart';
import 'package:todo/domain/models/response_model.dart';

enum MethodType { get, post, put, delete, patch, postMedia }

class ApiService {
  static Dio? _dio;

  static void _init({
    String? authToken,
    Duration connectTimeout = const Duration(seconds: 15),
    Duration receiveTimeout = const Duration(seconds: 20),
    bool enableLogging = kDebugMode,
  }) {
    if (_dio != null) {
      return;
    }
    final baseOptions = BaseOptions(
      baseUrl: API.apiUrl,
      connectTimeout: connectTimeout,
      receiveTimeout: receiveTimeout,
      headers: {
        'Accept': 'application/json',
        'Content-Type': 'application/json',
      },
    );
    _dio = Dio(baseOptions);
    _dio!.interceptors.addAll([
      AuthTokenInterceptor(authToken: authToken),
      if (enableLogging) MyLogInterceptor(),
    ]);
  }

  static void setToken(String authToken) {
    ApiService._init();
    _dio!.interceptors.removeWhere((i) => i is AuthTokenInterceptor);
    _dio!.interceptors.add(AuthTokenInterceptor(authToken: authToken));
  }

  static void removeToken() {
    ApiService._init();
    _dio!.interceptors.removeWhere((i) => i is AuthTokenInterceptor);
    _dio!.interceptors.add(AuthTokenInterceptor());
  }

  static Future<ResponseModel> request<T>({
    required String api,
    required MethodType method,
    Map<String, dynamic>? payload,
    Map<String, dynamic>? queryParameters,
    Map<String, List<String>> filePaths = const {},
  }) async {
    ApiService._init();
    late Response response;
    try {
      switch (method) {
        case MethodType.get:
          {
            response = await _dio!.get(
              api,
              data: payload,
              queryParameters: queryParameters,
            );
            break;
          }
        case MethodType.post:
          {
            response = await _dio!.post(
              api,
              data: payload,
              queryParameters: queryParameters,
            );
            break;
          }
        case MethodType.put:
          {
            response = await _dio!.put(
              api,
              data: payload,
              queryParameters: queryParameters,
            );
            break;
          }
        case MethodType.delete:
          {
            response = await _dio!.delete(
              api,
              data: payload,
              queryParameters: queryParameters,
            );
            break;
          }
        case MethodType.patch:
          {
            response = await _dio!.patch(
              api,
              data: payload,
              queryParameters: queryParameters,
            );
            break;
          }
        case MethodType.postMedia:
          {
            filePaths.removeWhere((k, v) {
              v.removeWhere((e) => e.isEmpty);
              return v.isEmpty;
            });
            if (filePaths.isEmpty) {
              response = await _dio!.post(
                api,
                data: payload,
                queryParameters: queryParameters,
              );
            } else {
              final Map<String, dynamic> formDataMap = {...(payload ?? {})};
              for (final entry in filePaths.entries) {
                if (entry.value.length == 1) {
                  formDataMap[entry.key] = await MultipartFile.fromFile(
                    entry.value.first,
                    filename: entry.value.first.split('/').last,
                  );
                } else {
                  formDataMap[entry.key] = await Future.wait(
                    entry.value.map(
                      (filePath) async => MultipartFile.fromFile(
                        filePath,
                        filename: filePath.split('/').last,
                      ),
                    ),
                  );
                }
                response = await _dio!.post(
                  api,
                  data: FormData.fromMap(formDataMap),
                  options: Options(
                    headers: {"Content-Type": "multipart/form-data"},
                  ),
                  queryParameters: queryParameters,
                );
              }
            }
            break;
          }
      }
      return await _validateResponse(response, api);
    } on DioException catch (e, s) {
      final failure = _handleError(e, s);
      throw failure;
    } catch (e, s) {
      throw UnknownFailure(error: e.toString(), stackTrace: s);
    }
  }

  static Future<ResponseModel> _validateResponse(
    Response response,
    String api,
  ) async {
    if (response.statusCode == 200 || response.statusCode == 201) {
      return ResponseModel(status: true, data: response.data, message: '');
    }
    throw ServerFailure(
      statusCode: response.statusCode ?? 0,
      error: 'StatusCode : ${response.statusCode} Response ${response.data}',
    );
  }

  static Failure _handleError(DioException e, StackTrace? s) {
    String message;
    switch (e.type) {
      case DioExceptionType.connectionTimeout:
        {
          message = "Connection timed out. Please try again.";
          return NetworkFailure(message: message, error: e, stackTrace: s);
        }
      case DioExceptionType.receiveTimeout:
        {
          message = "Server took too long to respond.";
          return ServerFailure(
            statusCode: e.response?.statusCode ?? 0,
            message: message,
            error: e,
            stackTrace: s,
          );
        }
      case DioExceptionType.unknown:
        {
          message = "Unknown error";
          return ServerFailure(
            statusCode: e.response?.statusCode ?? 0,
            message: e.error?.toString() ?? message,
            error: e,
            stackTrace: s,
          );
        }
      case DioExceptionType.badResponse:
        {
          message = "Server error: ${e.response?.statusCode}";
          final statusCode = e.response?.statusCode;
          switch (statusCode) {
            case 400:
              {
                message = 'Invalid request';
                break;
              }
            case 401:
              {
                message = 'Unauthorized';
                break;
              }
            case 403:
              {
                message = 'Unauthorized';
                break;
              }
            case 404:
              {
                message = 'No data found';
                break;
              }
            default:
              {
                message = 'Something Went Wrong';
                break;
              }
          }
          return ServerFailure(
            statusCode: e.response?.statusCode ?? 0,
            message: message,
            error: e,
            stackTrace: s,
          );
        }
      default:
        {
          // DioExceptionType.cancel
          // DioExceptionType.sendTimeout
          // DioExceptionType.badCertificate
          // DioExceptionType.connectionError
          return ServerFailure(
            statusCode: e.response?.statusCode ?? 0,
            error: e,
            stackTrace: s,
          );
        }
    }
  }
}
