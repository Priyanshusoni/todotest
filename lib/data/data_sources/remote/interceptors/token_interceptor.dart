// import 'package:dio/dio.dart';

// class TokenInterceptor extends InterceptorsWrapper {
//   final Dio dio;

//   TokenInterceptor(this.dio);

//   @override
//   void onError(DioError err, ErrorInterceptorHandler handler) async {
//     if (err.response?.statusCode == 401) {
//       // Example refresh logic (replace with real one)
//       final refreshToken = "stored_refresh_token";
//       try {
//         final refreshResponse = await dio.post(
//           "/auth/refresh",
//           data: {"refresh_token": refreshToken},
//         );
//         final newAccessToken = refreshResponse.data["access_token"];
//         // Save token somewhere...

//         final retryRequest = await dio.request(
//           err.requestOptions.path,
//           options: Options(
//             method: err.requestOptions.method,
//             headers: {
//               ...err.requestOptions.headers,
//               "Authorization": "Bearer $newAccessToken",
//             },
//           ),
//           data: err.requestOptions.data,
//           queryParameters: err.requestOptions.queryParameters,
//         );
//         return handler.resolve(retryRequest);
//       } catch (e) {
//         return handler.next(err);
//       }
//     }
//     return handler.next(err);
//   }
// }
