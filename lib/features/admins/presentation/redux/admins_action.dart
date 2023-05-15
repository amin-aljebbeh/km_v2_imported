import 'package:dartz/dartz.dart';
import 'package:kammun_app/features/admins/domain/entities/admins_entity.dart';
import 'package:kammun_app/features/admins/domain/entities/role_entity.dart';

import '../../../../core/core_importer.dart';

abstract class AdminsAction {
  handle({@required Store<AppState> store});
}

class GetAdminsWithoutDetailsAction implements AdminsAction {
  final int roleId;
  final int warehouseId;
  final String searchName;

  GetAdminsWithoutDetailsAction({this.roleId, this.warehouseId, this.searchName});

  @override
  handle({Store<AppState> store}) async {
    store.dispatch(StartLoading());
    Either either = await store.state.adminsState.adminsUseCases
        .getAdminsWithoutDetailsUseCase(warehouseId: warehouseId, roleId: roleId, searchName: searchName);
    either.fold(
        (failure) => store.dispatch(SetAdmins(admins: [])), (admins) => store.dispatch(SetAdmins(admins: admins)));
    store.dispatch(StopLoading());
  }
}

class GetRolesAction implements AdminsAction {
  @override
  handle({Store<AppState> store}) async {
    Either either = await store.state.adminsState.adminsUseCases.getRolesUseCase();
    either.fold((failure) => store.dispatch(SetRoles(roles: [])), (roles) => store.dispatch(SetRoles(roles: roles)));
  }
}

class SetRoles {
  final List<RoleEntity> roles;

  SetRoles({this.roles});
}

class GetTransactionsActorsAction implements AdminsAction {
  final int categoryId;

  GetTransactionsActorsAction({this.categoryId});

  @override
  handle({Store<AppState> store}) async {
    store.dispatch(StartLoading());
    Either either = await store.state.adminsState.adminsUseCases.getTransactionsActorsUseCase(categoryId: categoryId);
    either.fold((failure) {
      store.dispatch(CatchError(errorMessage: 'حدث خطأ أثناء محاولة عرض الأدمن المتاحين لهذه العملية'));
      store.dispatch(SetTransactionsActors(admins: []));
    }, (admins) {
      List<AdminEntity> transactionsActors = admins;
      transactionsActors.removeWhere((actor) => actor.id == store.state.adminsState.admin.id);
      store.dispatch(SetTransactionsActors(admins: admins));
    });
    store.dispatch(StopLoading());
  }
}

class SetAdmins {
  final List<AdminEntity> admins;

  SetAdmins({this.admins});
}

class SetTransactionsActors {
  final List<AdminEntity> admins;

  SetTransactionsActors({this.admins});
}

class SetAdmin {
  final AdminEntity admin;

  SetAdmin({this.admin});
}
