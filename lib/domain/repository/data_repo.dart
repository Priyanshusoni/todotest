import 'package:todo/domain/models/response_model.dart';

abstract class DataRepo {
  Future<ResponseModel> getTodoList({
    required int userId,
    required int skip,
    int limit = 30,
  });

  Future<ResponseModel> addTodo({
    required int userId,
    required bool completed,
    required String todo,
  });

  Future<ResponseModel> updateTodo({
    required int todoId,
    required bool completed,
    required String todo,
  });

  Future<ResponseModel> deleteTodo({required int todoId});
}
