import 'package:dartz/dartz.dart';
import 'package:kammun_app/features/admins/data/models/role_model.dart';

import '../../../../core/core_importer.dart';
import '../../../authentication/data/models/login_admin_model.dart';
import '../models/admin_model.dart';
import '../models/create_admin_model.dart';
import '../models/get_admins_response_model.dart';
import '../models/roles_response_model.dart';

abstract class AdminsRemoteDataSource {
  Future<List<AdminModel>> getAdminsWithoutDetails({int roleId, int warehouseId, String searchName});

  Future<List<AdminModel>> getTransactionsActors({int categoryId});

  Future<List<RoleModel>> getRoles();

  Future<AdminLoginResponseModel> getAdmin({int adminId});

  Future<Unit> createAdmin({CreateAdminModel admin});
}

class AdminsRemoteDataSourceImplement extends AdminsRemoteDataSource {
  @override
  Future<List<AdminModel>> getAdminsWithoutDetails({int roleId, int warehouseId, String searchName}) async {
    Map<String, dynamic> param = {'role_id': roleId, 'warehouse_id': warehouseId, 'search_name': searchName};
    param.removeWhere((key, value) => value == null);
    Response response =
        await ApiProvider.sendRequest(url: adminsWithoutDetailsApi, method: HttpMethods.get, queryParameters: param);
    try {
      if (response != null) {
        if (response.statusCode == successCode) return getAdminsResponseModelFromJson(jsonEncode(response.data)).admins;
      }
    } catch (e) {
      throw (InternalException(message: e.toString()));
    }
    throw (ServerException());
  }

  @override
  Future<List<AdminModel>> getTransactionsActors({int categoryId}) async {
    Response response = await ApiProvider.sendRequest(
        url: transactionsActorsApi, method: HttpMethods.get, queryParameters: {'transaction_category_id': categoryId});
    try {
      if (response != null) {
        if (response.statusCode == successCode) return getAdminsResponseModelFromJson(jsonEncode(response.data)).admins;
      }
    } catch (e) {
      throw (InternalException(message: e.toString()));
    }
    throw (ServerException());
  }

  @override
  Future<List<RoleModel>> getRoles() async {
    Response response = await ApiProvider.sendRequest(url: roleApi, method: HttpMethods.get);
    try {
      if (response != null) {
        if (response.statusCode == successCode) return rolesResponseModelFromJson(jsonEncode(response.data)).roles;
      }
    } catch (e) {
      throw (InternalException(message: e.toString()));
    }
    throw (ServerException());
  }

  @override
  Future<AdminLoginResponseModel> getAdmin({int adminId}) async {
    Response response = await ApiProvider.sendRequest(url: adminApi + adminId.toString(), method: HttpMethods.get);
    try {
      if (response != null) {
        if (response.statusCode == successCode) return adminLoginResponseFromJson(jsonEncode(response.data));
      }
    } catch (e) {
      throw (InternalException(message: e.toString()));
    }
    throw (ServerException());
  }

  @override
  Future<Unit> createAdmin({CreateAdminModel admin}) async {
    Response response = await ApiProvider.sendRequest(
        url: registerAdminApi, method: HttpMethods.post, body: admin.toJson(), responseType: ResponseType.json);
    try {
      if (response != null) if (response.statusCode == successCode) return Future.value(unit);
    } catch (e) {
      throw (InternalException(message: e.toString()));
    }
    throw (ServerException());
  }
}
