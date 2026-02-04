import 'package:todo/core/utils/debug_print.dart';
import 'package:flutter/material.dart';

class LifeCycle with WidgetsBindingObserver {
  AppLifecycleState? _state;
  AppLifecycleState? get state => _state;

  LifeCycle() {
    WidgetsBinding.instance.addObserver(this);
  }

  /// make sure the clients of this library invoke the dispose method
  /// so that the observer can be unregistered
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    _state = state;
    onResume();
  }

  void onResume() async {
    if (_state == AppLifecycleState.resumed) {
      printLog(_state ?? 'State', name: 'LifeCycle');
    }
  }
}
