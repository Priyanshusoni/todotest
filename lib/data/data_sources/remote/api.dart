import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:todo/core/constants/env_keys.dart';

class API {
  static String _host = '';
  static String get getHost => _host;
  static set setHost(String value) => _host = value;

  static final _apiUrl = dotenv.env[EnvKeys.apiUrl]!;
  static String get apiUrl => _apiUrl;

  static const todos = '/todos';
  static const addTodo = '/todos/add';
}
