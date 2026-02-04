import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';
import 'package:todo/provider/data_provider.dart';

final dataProvider = ChangeNotifierProvider<DataProvider>(
  (ref) => DataProvider(),
);

final networkProvider = StreamProvider<bool>((ref) async* {
  final networkInfo = InternetConnection();
  await for (final value in networkInfo.onStatusChange) {
    yield value == InternetStatus.connected;
  }
});
