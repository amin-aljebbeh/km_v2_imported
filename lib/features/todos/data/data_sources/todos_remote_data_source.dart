import 'package:dartz/dartz.dart';

import '../../../../core/core_importer.dart';
import '../models/todo_model.dart';

abstract class TodosRemoteDataSource {
  Future<Unit> resolveTodo({int todoId, int todoTagResolverId, String note});

  Future<TodoResponseModel> getTodos({int page});
}

class TodosRemoteDataSourceImplement extends TodosRemoteDataSource {
  @override
  Future<Unit> resolveTodo({int todoId, int todoTagResolverId, String note}) async {
    Response response = await ApiProvider.sendRequest(
        url: todosResolveApi,
        method: HttpMethods.post,
        queryParameters: {'_method': 'PUT'},
        body: {'todo_tag_resolver_id': todoTagResolverId, 'note': note});
    try {
      if (response != null) if (response.statusCode == successCode) return Future.value(unit);
    } catch (e) {
      throw (InternalException(message: e.toString()));
    }
    throw (ServerException());
  }

  @override
  Future<TodoResponseModel> getTodos({int page}) async {
    Response response = await ApiProvider.sendRequest(
        url: todosApi, method: HttpMethods.get, queryParameters: {'page': page, 'per_page': 10});
    try {
      if (response != null) {
        if (response.statusCode == successCode) {
          return todoResponseModelFromJson(jsonEncode(response.data));
        }
      }
    } catch (e) {
      throw (InternalException(message: e.toString()));
    }
    throw (ServerException());
  }
}
