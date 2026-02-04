// import 'dart:async';

// // import 'package:todo/domain/models/auth_model.dart';
// import 'package:flutter_secure_storage/flutter_secure_storage.dart';

// class SecureStorage {
//   static const FlutterSecureStorage _secureStorage = FlutterSecureStorage();

//   static const _auth = 'auth';

//   // static Future<EmployeeModel?> getAuthData() async {
//   //   final data = await _secureStorage.read(key: _auth);
//   //   return data == null ? null : EmployeeModel.fromJson(data);
//   // }

//   static Future<bool> setAuthData(EmployeeModel value) async {
//     try {
//       await _secureStorage.write(key: _auth, value: value.toJson());
//       return true;
//     } catch (e) {
//       return false;
//     }
//   }

//   static Future<bool> saveData(String key, String value) async {
//     try {
//       await _secureStorage.write(key: key, value: value);
//       return true;
//     } catch (e) {
//       return false;
//     }
//   }

//   static Future<String?> getData(String key) async {
//     try {
//       return await _secureStorage.read(key: key);
//     } catch (e) {
//       return null;
//     }
//   }

//   static Future<void> clear() async {
//     await _secureStorage.deleteAll();
//   }
// }
