import 'package:dio/dio.dart';

class AuthTokenInterceptor extends InterceptorsWrapper {
  final String? authToken;

  AuthTokenInterceptor({this.authToken});

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    if (authToken != null) {
      options.headers['Authorization'] = 'Bearer $authToken';
    }
    super.onRequest(options, handler);
  }
}
