import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get_it/get_it.dart';
import 'package:todo/core/enums.dart';
import 'package:todo/core/network_info.dart';
import 'package:todo/core/services/app_lifecycle.dart';
import 'package:todo/core/utils/debug_print.dart';
import 'package:todo/core/utils/utils.dart';
import 'package:todo/data/repository/data_repo_impl.dart';
import 'package:todo/domain/repository/data_repo.dart';

class Config {
  static late LifeCycle lifeCycle;
  static const _appEnv = AppEnv.dev;
  static bool get isDev => _appEnv == AppEnv.dev;

  static bool isTrusted = false;
  static FLAVOR flavor = FLAVOR.dev;

  static Future<void> init() async {
    WidgetsFlutterBinding.ensureInitialized();
    const flavorValue = String.fromEnvironment('FLAVOR');

    flavor = FLAVOR.values.firstWhere(
      (f) => f.name == flavorValue,
      orElse: () => FLAVOR.dev,
    );
    printLog('App Flavor: ${flavor.name}');
    // We Can use this for different flavor based initialization

    await dotenv.load(fileName: '${_appEnv.name}.env');
    GetLocator.initDependency();
    await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    isTrusted = await checkDeviceTrust();
  }
}

class GetLocator {
  static final locator = GetIt.instance;
  static void initDependency() {
    // Repositories
    locator.registerLazySingleton<DataRepo>(() => DataRepoImpl());

    // Network info
    locator.registerLazySingleton<NetworkInfo>(() => NetworkInfoImpl());
  }
}
