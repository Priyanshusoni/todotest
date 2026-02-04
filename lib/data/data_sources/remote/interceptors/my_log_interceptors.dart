import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:todo/core/utils/debug_print.dart';

class MyLogInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    options.extra['startTime'] = DateTime.now();
    final data = {
      'Meta': options.method,
      'Api': options.path.split('/').last,
      'Data': options.data.toString(),
      'Query Parameters': options.queryParameters,
    };
    printLog(data, name: '🚀 Request');
    super.onRequest(options, handler);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    final startTime = response.requestOptions.extra['startTime'] as DateTime?;
    final duration = startTime != null
        ? DateTime.now().difference(startTime).inMilliseconds
        : null;
    final data = {
      'Meta':
          '${response.requestOptions.method} | ${response.statusCode} | ${response.statusMessage} | ${duration ?? 0}ms',
      'Api': response.requestOptions.path.split('/').last,
      'Data': response.data.toString(),
    };
    final pretty = const JsonEncoder.withIndent('  ').convert(data);
    printLog(pretty, name: '✅ Response');
    super.onResponse(response, handler);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    final startTime = err.requestOptions.extra['startTime'] as DateTime?;
    final duration = startTime != null
        ? DateTime.now().difference(startTime).inMilliseconds
        : null;
    final data = {
      'Meta': '${err.requestOptions.method} | ${duration}ms',
      'Error': '❌ ${err.error}',
      'Message': err.message,
    };
    final pretty = const JsonEncoder.withIndent('  ').convert(data);
    printLog(pretty, name: '❌ Error');
    super.onError(err, handler);
  }
}
