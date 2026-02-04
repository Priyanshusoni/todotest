import 'package:flutter/material.dart';
import 'package:todo/core/utils/extension.dart';
import 'package:todo/presentation/theme/app_theme.dart';
import 'package:todo/presentation/theme/text_theme.dart';
import 'package:todo/presentation/theme/theme_helper.dart';

class NoDataFound extends StatelessWidget {
  final String message;
  const NoDataFound({super.key, this.message = 'No todos at the moment!'});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: ConstrainedBox(
            constraints: BoxConstraints(minHeight: constraints.maxHeight),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircleAvatar(
                    radius: 36,
                    backgroundColor: AppTheme.primaryColor.shade700,
                    foregroundColor: AppTheme.primaryColor.shade100,
                    child: Icon(Icons.search_off, size: 36),
                  ),
                  vSpace16,
                  Text(
                    message,
                    style: AppTextTheme.subtitle.grey,
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
