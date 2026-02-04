import 'package:todo/core/failure.dart';
import 'package:todo/data/data_sources/remote/api.dart';
import 'package:todo/data/data_sources/remote/api_service.dart';
import 'package:todo/domain/models/response_model.dart';
import 'package:todo/domain/repository/data_repo.dart';

class DataRepoImpl implements DataRepo {
  @override
  Future<ResponseModel> addTodo({
    required int userId,
    required bool completed,
    required String todo,
  }) async {
    try {
      return await ApiService.request(
        api: API.addTodo,
        method: MethodType.post,
        payload: {"todo": todo, "completed": completed, "userId": userId},
      );
    } on Failure {
      rethrow;
    } catch (e, s) {
      throw UnknownFailure(error: e.toString(), stackTrace: s);
    }
  }

  @override
  Future<ResponseModel> getTodoList({
    required int userId,
    required int skip,
    int limit = 30,
  }) async {
    try {
      return await ApiService.request(
        api: '${API.todos}/user/$userId',
        method: MethodType.get,
        // queryParameters: {'skip': skip, 'limit': limit}, // use this if want paginated api
      );
    } on Failure {
      rethrow;
    } catch (e, s) {
      throw UnknownFailure(error: e.toString(), stackTrace: s);
    }
  }

  @override
  Future<ResponseModel> updateTodo({
    required int todoId,
    required bool completed,
    required String todo,
  }) async {
    try {
      return await ApiService.request(
        api: '${API.todos}/$todoId',
        method: MethodType.put,
        payload: {"todo": todo, "completed": completed},
      );
    } on Failure {
      rethrow;
    } catch (e, s) {
      throw UnknownFailure(error: e.toString(), stackTrace: s);
    }
  }

  @override
  Future<ResponseModel> deleteTodo({required int todoId}) async {
    try {
      return await ApiService.request(
        api: '${API.todos}/$todoId',
        method: MethodType.delete,
      );
    } on Failure {
      rethrow;
    } catch (e, s) {
      throw UnknownFailure(error: e.toString(), stackTrace: s);
    }
  }
}
