import 'package:flutter/material.dart';
import 'package:todo/presentation/theme/app_theme.dart';

class Loader extends StatelessWidget {
  const Loader({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Material(
        elevation: 2,
        shape: const CircleBorder(),
        child: CircularProgressIndicator(
          strokeWidth: 2,
          backgroundColor: AppTheme.primaryColor.withValues(alpha: 0.1),
        ),
      ),
    );
  }
}
