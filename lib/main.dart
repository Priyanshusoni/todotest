// import 'package:event_bus/event_bus.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:todo/core/config.dart';
import 'package:todo/core/constants/env_keys.dart';
import 'package:todo/core/routes.dart';
import 'package:todo/core/utils/keys.dart';
import 'package:todo/presentation/screens/block_screen.dart';
import 'package:todo/presentation/screens/home_screen.dart';
import 'package:todo/presentation/theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// final eventBus = EventBus();

void main() async {
  await Config.init();
  runApp(ProviderScope(child: const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: dotenv.env[EnvKeys.appName],
      debugShowCheckedModeBanner: false,
      navigatorKey: Keys.navigatorKey,
      scaffoldMessengerKey: Keys.messangerKey,
      onGenerateRoute: Routes.generateRoute,
      theme: AppTheme.theme,
      home: Config.isTrusted ? const HomeScreen() : const BlockedScreen(),
      builder: (context, child) {
        return MediaQuery(
          data: MediaQuery.of(
            context,
          ).copyWith(textScaler: const TextScaler.linear(1.0)),
          child: child!,
        );
      },
    );
  }
}
