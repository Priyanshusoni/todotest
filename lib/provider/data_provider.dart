import 'package:todo/core/failure.dart';
import 'package:todo/core/utils/debug_print.dart';
import 'package:todo/data/database/databse_helper.dart';
import 'package:todo/domain/models/pagination_model.dart';
import 'package:flutter/foundation.dart';
import 'package:todo/core/config.dart';
import 'package:todo/core/utils/utils.dart';
import 'package:todo/domain/models/todo_model.dart';
import 'package:todo/domain/repository/data_repo.dart';

class DataProvider extends ChangeNotifier {
  DataProvider();

  DataRepo get _dataRepo => GetLocator.locator();

  PaginationModel<TodoModel> _todos = PaginationModel.init();
  PaginationModel<TodoModel> get todos => _todos;

  DatabaseHelper get database => DatabaseHelper.instance;

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
      final res = await _dataRepo.getTodoList(userId: 1, skip: 0);
      if (res.status) {
        _todos = PaginationModel.fromMap(
          res.data,
          (data) => TodoModel.fromMap(data),
        );
        notifyListeners();
      } else {
        scaffoldMessage(res.message, isError: !res.status);
      }
      return res.status;
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
      final res = await _dataRepo.addTodo(
        userId: 1,
        todo: todo,
        completed: completed,
      );
      if (res.status) {
        final newTodo = TodoModel.fromMap(res.data);
        _todos = _todos.copyWith(
          data: [newTodo, ..._todos.data],
          total: _todos.total + 1,
        );
        scaffoldMessage('Todo added successfully', isError: !res.status);
      } else {
        scaffoldMessage(res.message, isError: !res.status);
      }
      return res.status;
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
      final res = await _dataRepo.updateTodo(
        todoId: id,
        todo: todo,
        completed: completed,
      );
      if (res.status) {
        final index = _todos.data.indexWhere((element) => element.id == id);
        if (index != -1) {
          final data = [..._todos.data];
          data[index] = TodoModel.fromMap(res.data);
          _todos = _todos.copyWith(data: data);
          printLog('message');
          scaffoldMessage('Todo updated successfully', isError: !res.status);
        } else {
          scaffoldMessage(res.message, isError: !res.status);
        }
      }
      return res.status;
    } catch (e, s) {
      catchFailure(e, stackTrace: s, name: 'updateTodo');
      return false;
    }
  }

  Future<bool> deleteTodo({required int id}) async {
    try {
      final res = await _dataRepo.deleteTodo(todoId: id);
      if (res.status) {
        final data = _todos.data.where((element) => element.id != id).toList();
        _todos = _todos.copyWith(data: data, total: _todos.total - 1);
        notifyListeners();
        scaffoldMessage('Todo deleted successfully', isError: !res.status);
      } else {
        scaffoldMessage(res.message, isError: !res.status);
      }
      return res.status;
    } catch (e, s) {
      catchFailure(e, stackTrace: s, name: 'deleteTodo');
      return false;
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
}
