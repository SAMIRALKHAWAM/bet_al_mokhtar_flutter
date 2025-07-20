import 'package:dio/dio.dart';

import 'end_point.dart';
class DioHelper {
  static late Dio dio;
  static init() {
    dio = Dio(BaseOptions(
      baseUrl: baseurl,
      receiveDataWhenStatusError: true,

    ));
  }

  static Future<Response> postData({
    required String url,
    dynamic data,
  }) async {
    dio.options.headers = {
      'Accept': 'application/json',
      'Authorization': 'Bearer $token'
    };

    return await dio.post(url, data: data);
  }



  static Future<Response> DeleteData({
    required String url,
  }) async {
    dio.options.headers = {
      'Accept': 'application/json',
      'Authorization': 'Bearer $token'
    };

    return await dio.delete(url);
  }

  static Future<Response> getData({
    required String url,
    // required Map<String,dynamic> query,
  }) async {
    dio.options.headers = {
      'Accept': 'application/json',
      'Authorization': 'Bearer $token'
    };
    return await dio.get(url);
  }

  static Future<Response> getdo({
    required String url,
    // required Map<String,dynamic> query,
  }) async {

    return await dio.get(url,options: Options(responseType: ResponseType.stream));
  }

}




// import 'package:dio/dio.dart';
//
// import 'cash_helper.dart';
// import 'end_point.dart';
//
// class DioHelper {
//   static late Dio dio;
//   static init() {
//     dio = Dio(BaseOptions(baseUrl: baseurl, receiveDataWhenStatusError: true));
//
//
//
//     dio.interceptors.add(
//       InterceptorsWrapper(
//         onError: (DioException error, ErrorInterceptorHandler handler) async {
//
//           if (error.response?.statusCode == 401) {
//             print('🔄 Token expired. Trying to refresh...');
//
//             bool success = await refreshTokenFunction();
//
//             if (success) {
//
//               final RequestOptions requestOptions = error.requestOptions;
//
//               requestOptions.headers['Authorization'] = 'Bearer $token';
//
//               try {
//                 final response = await dio.fetch(requestOptions);
//                 return handler.resolve(response);
//               } catch (e) {
//                 return handler.reject(error);
//               }
//             } else {
//               print('❌ Refresh token failed, logging out user.');
//
//               await CachHelper.removeData(key: 'token');
//               await CachHelper.removeData(key: 'refresh_token');
//
//               // مثال لتوجيه المستخدم - تحتاج معرف navigatorKey مهيأ
//               // navigatorKey.currentState?.pushNamedAndRemoveUntil('/login', (route) => false);
//
//               return handler.reject(error);
//             }
//           }
//
//           return handler.next(error);
//         },
//       ),
//     );
//   }
//
//   static Future<Response> postData({required String url, dynamic data}) async {
//     dio.options.headers = {
//       'Accept': 'application/json',
//       'Content-Type': 'application/json',
//       'Authorization': 'Bearer $token',
//     };
//
//     return await dio.post(url, data: data);
//   }
//
//   static Future<Response> patchData({required String url, dynamic data}) async {
//     dio.options.headers = {
//       'Accept': 'application/json',
//       'Authorization': 'Bearer $token',
//     };
//     return await dio.patch(url, data: data);
//   }
//
//
//   static Future<Response> deleteData({required String url}) async {
//     dio.options.headers = {
//       'Accept': 'application/json',
//       'Authorization': 'Bearer $token',
//     };
//
//     return await dio.delete(url);
//   }
//
//   static Future<Response> getData({
//     required String url,
//     // required Map<String,dynamic> query,
//   }) async {
//     dio.options.headers = {
//       'Accept': 'application/json',
//       'Authorization': 'Bearer $token',
//     };
//     return await dio.get(url);
//   }
//
//
//   ////////////////////////////////////////
//
//   static Future<bool> refreshTokenFunction() async {
//     try {
//       final response = await dio.post(
//         'auth/refresh',
//         data: {'refresh_token': refreshToken},
//         options: Options(
//           headers: {
//             'Accept': 'application/json',
//             'Authorization': 'Bearer $refreshToken',
//           },
//         ),
//       );
//
//       final newAccessToken = response.data['access_token'];
//       final newRefreshToken = response.data['refresh_token'];
//
//       setToken(newAccessToken);
//       setRefreshToken(newRefreshToken);
//
//       await CachHelper.saveData(key: 'token', value: newAccessToken);
//       await CachHelper.saveData(key: 'refresh_token', value: newRefreshToken);
//
//       return true;
//     } catch (e) {
//       print('Refresh token failed: $e');
//       return false;
//     }
//   }
// }