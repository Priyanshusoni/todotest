
// import 'package:dio/dio.dart';

// class RetryInterceptor extends InterceptorsWrapper {
//   final Dio dio;
//   final int maxRetries;

//   RetryInterceptor(this.dio, {this.maxRetries = 3});

//   @override
//   void onError(DioException err, ErrorInterceptorHandler handler) async {
//     var retryCount = err.requestOptions.extra["retryCount"] ?? 0;

//     if (retryCount < maxRetries &&
//         (err.type == DioExceptionType.connectionTimeout ||
//          err.type == DioExceptionType.receiveTimeout)) {
//       retryCount++;
//       err.requestOptions.extra["retryCount"] = retryCount;
//       try {
//         final response = await dio.request(
//           err.requestOptions.path,
//           options: Options(method: err.requestOptions.method),
//           data: err.requestOptions.data,
//           queryParameters: err.requestOptions.queryParameters,
//         );
//         return handler.resolve(response);
//       } catch (e) {
//         return handler.next(err);
//       }
//     }
//     return handler.next(err);
//   }
// }
