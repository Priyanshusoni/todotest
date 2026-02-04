import 'dart:async';
import 'dart:convert';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';

import 'package:todo/core/failure.dart';
import 'package:todo/core/utils/debug_print.dart';
import 'package:todo/data/database/databse_helper.dart';
import 'package:todo/domain/models/pagination_model.dart';
import 'package:flutter/foundation.dart';
import 'package:todo/core/config.dart';
import 'package:todo/core/network_info.dart';
import 'package:todo/core/utils/utils.dart';
import 'package:todo/domain/models/todo_model.dart';
import 'package:todo/domain/repository/data_repo.dart';

class DataProvider extends ChangeNotifier {
  StreamSubscription<InternetStatus>? _connSub;

  DataRepo get _dataRepo => GetLocator.locator();
  NetworkInfo get _networkInfo => GetLocator.locator();

  PaginationModel<TodoModel> _todos = PaginationModel.init();
  PaginationModel<TodoModel> get todos => _todos;

  DatabaseHelper get database => DatabaseHelper.instance;

  Future<void> init() async {
    // listen to connectivity changes and sync when back online
    try {
      _connSub = _networkInfo.connection.onStatusChange.listen((status) {
        if (status == InternetStatus.connected) {
          syncPendingOperations();
        }
      });
    } catch (e, s) {
      printLog('Failed to subscribe to network changes: $e', stackTrace: s);
    }
    // try an initial sync if online
    () async {
      final connected = await _networkInfo.isConnected;
      if (connected) await syncPendingOperations();
    }();
  }

  // Future<bool> getTodoListFromNetwork() async {
  //   try {
  //     final res = await _dataRepo.getTodoList(userId: 1, skip: 0);
  //     if (res.status) {
  //       final todosData = PaginationModel.fromMap(
  //         res.data,
  //         (data) => TodoModel.fromMap(data),
  //       );
  //       database.syncBatchTodos(todosData.data);
  //     } else {
  //       scaffoldMessage(res.message, isError: !res.status);
  //     }
  //     return res.status;
  //   } catch (e, s) {
  //     catchFailure(e, stackTrace: s, name: 'getTodoListFromNetwork');
  //     return false;
  //   }
  // }

  // Future<bool> getTodoList() async {
  //   try {
  //     _todos = PaginationModel.init();
  //     await database.initDB();
  //     List<TodoModel> localTodos = await database.getTodos(skip: 0);
  //     if (localTodos.isNotEmpty) {
  //       _todos = PaginationModel<TodoModel>(
  //         data: localTodos,
  //         total: await database.getTodosCount(),
  //         limit: localTodos.length,
  //         skip: 0,
  //       );
  //       notifyListeners();
  //       return true;
  //     }
  //     final res = await getTodoListFromNetwork();
  //     if (res) {
  //       localTodos = await database.getTodos(skip: 0);
  //       _todos = PaginationModel<TodoModel>(
  //         data: localTodos,
  //         total: await database.getTodosCount(),
  //         limit: localTodos.length,
  //         skip: 0,
  //       );
  //       notifyListeners();
  //       return true;
  //     }
  //     return false;
  //   } catch (e, s) {
  //     catchFailure(e, stackTrace: s, name: 'getTodoList');
  //     return false;
  //   }
  // }

  Future<void> getMoreTodoList() async {
    try {
      if (_todos.total == _todos.data.length) {
        return;
      }
      final res = await _dataRepo.getTodoList(
        userId: 1,
        skip: todos.data.length + todos.limit,
      );

      if (res.status) {
        _todos = _todos.addData(res.data, (data) => TodoModel.fromMap(data));
        notifyListeners();
      }
    } catch (e, s) {
      catchFailure(e, stackTrace: s, name: 'getMoreTodoList');
    }
  }

  Future<bool> getTodoList() async {
    try {
      _todos = PaginationModel.init();

      await database.initDB();
      final connected = await _networkInfo.isConnected;

      if (connected) {
        final res = await _dataRepo.getTodoList(userId: 1, skip: 0);
        if (res.status) {
          final todosData = PaginationModel.fromMap(
            res.data,
            (data) => TodoModel.fromMap(data),
          );
          await database.syncBatchTodos(todosData.data);

          final localTodos = await database.getTodos(skip: 0);
          _todos = PaginationModel<TodoModel>(
            data: localTodos,
            total: await database.getTodosCount(),
            limit: localTodos.length,
            skip: 0,
          );
          notifyListeners();
          // after loading, try syncing any pending ops
          await syncPendingOperations();
          return true;
        }
        scaffoldMessage(res.message, isError: !res.status);
        return false;
      } else {
        final localTodos = await database.getTodos(skip: 0);
        _todos = PaginationModel<TodoModel>(
          data: localTodos,
          total: await database.getTodosCount(),
          limit: localTodos.length,
          skip: 0,
        );
        notifyListeners();
        scaffoldMessage('Loaded offline data', isError: false);
        return true;
      }
    } catch (e, s) {
      catchFailure(e, stackTrace: s, name: 'getTodoList');
      return false;
    }
  }

  // Future<void> getMoreTodoList() async {
  //   try {
  //     if (_todos.total == _todos.data.length) {
  //       return;
  //     }
  //     final res = await _dataRepo.getTodoList(
  //       userId: 1,
  //       skip: todos.data.length + todos.limit,
  //     );

  //     if (res.status) {
  //       _todos = _todos.addData(res.data, (data) => TodoModel.fromMap(data));
  //       notifyListeners();
  //     }
  //   } catch (e, s) {
  //     catchFailure(e, stackTrace: s, name: 'getMoreTodoList');
  //   }
  // }

  Future<bool> addTodo({required String todo, required bool completed}) async {
    try {
      await database.initDB();
      final connected = await _networkInfo.isConnected;
      printLog('addTodo: connected=$connected');
      if (connected) {
        final res = await _dataRepo.addTodo(
          userId: 1,
          todo: todo,
          completed: completed,
        );
        if (res.status) {
          final newTodo = TodoModel.fromMap(res.data);
          await database.insertTodo(newTodo);
          _todos = _todos.copyWith(
            data: [newTodo, ..._todos.data],
            total: _todos.total + 1,
          );
          scaffoldMessage('Todo added successfully', isError: !res.status);
        } else {
          scaffoldMessage(res.message, isError: !res.status);
        }
        return res.status;
      } else {
        // offline: create local todo with negative id and queue create operation
        final localId = -DateTime.now().millisecondsSinceEpoch;
        final localTodo = TodoModel(
          id: localId,
          todo: todo,
          completed: completed,
          userId: 1,
        );
        await database.insertTodo(localTodo);
        await database.insertPendingOperation(
          operation: 'create',
          payload: localTodo.toMap(),
          localId: localId,
        );
        _todos = _todos.copyWith(
          data: [localTodo, ..._todos.data],
          total: _todos.total + 1,
        );
        notifyListeners();
        scaffoldMessage('Saved offline; will sync when online', isError: false);
        return true;
      }
    } catch (e, s) {
      catchFailure(e, stackTrace: s, name: 'addTodo');
      return false;
    }
  }

  Future<bool> updateTodo({
    required int id,
    required String todo,
    required bool completed,
  }) async {
    try {
      await database.initDB();
      final connected = await _networkInfo.isConnected;

      if (connected) {
        final res = await _dataRepo.updateTodo(
          todoId: id,
          todo: todo,
          completed: completed,
        );
        if (res.status) {
          final updated = TodoModel.fromMap(res.data);
          await database.updateTodo(updated);
          final index = _todos.data.indexWhere((element) => element.id == id);
          if (index != -1) {
            final data = [..._todos.data];
            data[index] = updated;
            _todos = _todos.copyWith(data: data);
            notifyListeners();
            scaffoldMessage('Todo updated successfully', isError: !res.status);
          }
        } else {
          scaffoldMessage(res.message, isError: !res.status);
        }
        return res.status;
      } else {
        // offline: update local and queue
        final localTodo = TodoModel(
          id: id,
          todo: todo,
          completed: completed,
          userId: 1,
        );
        await database.updateTodo(localTodo);
        await database.insertPendingOperation(
          operation: 'update',
          payload: localTodo.toMap(),
          localId: id,
        );
        final index = _todos.data.indexWhere((element) => element.id == id);
        if (index != -1) {
          final data = [..._todos.data];
          data[index] = localTodo;
          _todos = _todos.copyWith(data: data);
          notifyListeners();
        }
        scaffoldMessage(
          'Updated locally; will sync when online',
          isError: false,
        );
        return true;
      }
    } catch (e, s) {
      catchFailure(e, stackTrace: s, name: 'updateTodo');
      return false;
    }
  }

  Future<bool> deleteTodo({required int id}) async {
    try {
      await database.initDB();
      final connected = await _networkInfo.isConnected;

      if (connected) {
        final res = await _dataRepo.deleteTodo(todoId: id);
        if (res.status) {
          await database.deleteTodo(id);
          final data = _todos.data
              .where((element) => element.id != id)
              .toList();
          _todos = _todos.copyWith(data: data, total: _todos.total - 1);
          notifyListeners();
          scaffoldMessage('Todo deleted successfully', isError: !res.status);
        } else {
          scaffoldMessage(res.message, isError: !res.status);
        }
        return res.status;
      } else {
        // offline: delete locally and queue delete
        await database.deleteTodo(id);
        await database.insertPendingOperation(
          operation: 'delete',
          payload: {'id': id},
          localId: id,
        );
        final data = _todos.data.where((element) => element.id != id).toList();
        _todos = _todos.copyWith(data: data, total: _todos.total - 1);
        notifyListeners();
        scaffoldMessage(
          'Deleted locally; will sync when online',
          isError: false,
        );
        return true;
      }
    } catch (e, s) {
      catchFailure(e, stackTrace: s, name: 'deleteTodo');
      return false;
    }
  }

  Future<void> syncPendingOperations() async {
    try {
      final connected = await _networkInfo.isConnected;
      if (!connected) return;

      final pendings = await database.getPendingOperations();
      for (final p in pendings) {
        final pendingId = p['id'] as int;
        final operation = p['operation'] as String;
        final localId = p['local_id'] as int;
        final payload =
            json.decode(p['payload'] as String) as Map<String, dynamic>;

        if (operation == 'create') {
          final res = await _dataRepo.addTodo(
            userId: payload['userId'] ?? 1,
            todo: payload['todo'] as String,
            completed: (payload['completed'] is int)
                ? (payload['completed'] as int) == 1
                : (payload['completed'] as bool),
          );
          if (res.status) {
            final remoteTodo = TodoModel.fromMap(res.data);
            // update local id to remote id
            await database.updateTodoId(localId, remoteTodo.id);
            await database.deletePendingOperation(pendingId);
            // update in-memory list
            final index = _todos.data.indexWhere((e) => e.id == localId);
            if (index != -1) {
              final data = [..._todos.data];
              data[index] = remoteTodo;
              _todos = _todos.copyWith(data: data);
              notifyListeners();
            }
          }
        } else if (operation == 'update') {
          // find current todo to determine remote id
          final localTodo = await database.getTodoById(localId);
          if (localTodo == null) {
            await database.deletePendingOperation(pendingId);
            continue;
          }
          if (localTodo.id <= 0) {
            // still not created on server; skip until create synced
            continue;
          }
          final res = await _dataRepo.updateTodo(
            todoId: localTodo.id,
            todo: localTodo.todo,
            completed: localTodo.completed,
          );
          if (res.status) {
            await database.updateTodo(TodoModel.fromMap(res.data));
            await database.deletePendingOperation(pendingId);
          }
        } else if (operation == 'delete') {
          final localTodo = await database.getTodoById(localId);
          int remoteId = localId;
          if (localTodo != null && localTodo.id > 0) remoteId = localTodo.id;

          if (remoteId > 0) {
            await _dataRepo.deleteTodo(todoId: remoteId);
            // regardless of server response, remove local and pending
            await database.deleteTodo(localId);
            await database.deletePendingOperation(pendingId);
            final data = _todos.data
                .where((element) => element.id != localId)
                .toList();
            _todos = _todos.copyWith(
              data: data,
              total: await database.getTodosCount(),
            );
            notifyListeners();
          } else {
            // local-only, just remove
            await database.deleteTodo(localId);
            await database.deletePendingOperation(pendingId);
            final data = _todos.data
                .where((element) => element.id != localId)
                .toList();
            _todos = _todos.copyWith(
              data: data,
              total: await database.getTodosCount(),
            );
            notifyListeners();
          }
        }
      }
    } catch (e, s) {
      catchFailure(
        e,
        stackTrace: s,
        name: 'syncPendingOperations',
        showMessage: false,
      );
    }
  }

  void catchFailure(
    Object? failure, {
    StackTrace? stackTrace,
    String name = '',
    bool showMessage = true,
  }) {
    if (failure is! Failure) {
      printLog(failure.toString(), stackTrace: stackTrace, name: name);
      return;
    }
    printLog(failure.error, stackTrace: failure.stackTrace, name: name);
    if (failure is ServerFailure) {
      scaffoldMessage('statusCode: ${failure.statusCode} ${failure.message}');
      if (failure.statusCode == 502 || failure.statusCode == 401) {
        // logout(isLocal: true);
      }
    } else {
      if (showMessage) {
        scaffoldMessage(failure.message);
      }
    }
  }

  @override
  void dispose() {
    _connSub?.cancel();
    super.dispose();
  }
}
