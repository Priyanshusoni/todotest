import 'dart:async';

import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';

abstract class NetworkInfo {
  InternetConnection get connection;

  Future<bool> get isConnected;
}

class NetworkInfoImpl implements NetworkInfo {
  @override
  InternetConnection get connection => InternetConnection();

  @override
  Future<bool> get isConnected => connection.hasInternetAccess;
}
