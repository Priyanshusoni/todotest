import 'package:flutter/material.dart';
import 'package:todo/core/utils/extension.dart';
import 'package:todo/presentation/theme/app_theme.dart';
import 'package:todo/presentation/theme/text_theme.dart';
import 'package:todo/presentation/theme/theme_helper.dart';

class BlockedScreen extends StatelessWidget {
  const BlockedScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: all16,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.lock_outline, size: 70, color: AppTheme.redColor),
              vSpace20,
              Text(
                "Untrusted Device",
                style: AppTextTheme.title.red.semiBold,
              ),
              vSpace12,
              Text(
                "This app cannot run on rooted, jailbroken, or emulated devices.",
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
