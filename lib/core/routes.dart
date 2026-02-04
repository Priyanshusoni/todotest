// import 'package:todo/presentation/screens/home/approval/leaves_approval_screen.dart';
import 'package:todo/presentation/screens/add_todo_screen.dart';
import 'package:flutter/material.dart';
import 'package:todo/core/utils/debug_print.dart';

class Routes {
  static const addTodo = '/add-todo';

  static Route<dynamic> generateRoute(RouteSettings settings) {
    final args = (settings.arguments as Map<String, dynamic>?) ?? {};
    printLog('${settings.name ?? ''}, args: $args', name: 'generateRoute');
    switch (settings.name) {
      case addTodo:
        {
          return MaterialPageRoute(
            settings: settings,
            builder: (_) => AddTodoScreen(todo: args['todo']),
          );
        }
      default:
        return MaterialPageRoute(
          settings: settings,
          builder: (_) => Scaffold(
            body: Center(child: Text('No route defined for ${settings.name}')),
          ),
        );
    }
  }
}
