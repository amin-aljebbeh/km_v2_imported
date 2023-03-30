import 'package:dartz/dartz.dart';
import 'package:kammun_app/features/admins/presentation/redux/admins_action.dart';

import '../../../../core/core_importer.dart';
import '../../domain/entities/admins_entity.dart';

Future<void> adminsMiddleware(Store<AppState> store, action, NextDispatcher next) async {
  if (action is GetAdminsWithoutDetailsAction) {
    store.dispatch(StartLoading());
    Either either = await store.state.adminsState.adminsUseCases.getAdminsWithoutDetailsUseCase(
        warehouseId: action.warehouseId, roleId: action.roleId, searchName: action.searchName);
    either.fold(
        (failure) => store.dispatch(SetAdmins(admins: [])), (admins) => store.dispatch(SetAdmins(admins: admins)));
    store.dispatch(StopLoading());
  } else if (action is GetTransactionsActorsAction) {
    store.dispatch(StartLoading());
    Either either =
        await store.state.adminsState.adminsUseCases.getTransactionsActorsUseCase(categoryId: action.categoryId);
    either.fold((failure) => store.dispatch(SetTransactionsActors(admins: [])), (admins) {
      List<AdminEntity> transactionsActors = admins;
      transactionsActors.removeWhere((actor) => actor.id == store.state.adminsState.admin.id);
      store.dispatch(SetTransactionsActors(admins: admins));
    });
    store.dispatch(StopLoading());
  } else if (action is GetRolesAction) {
    Either either = await store.state.adminsState.adminsUseCases.getRolesUseCase();
    either.fold((failure) => store.dispatch(SetRoles(roles: [])), (roles) => store.dispatch(SetRoles(roles: roles)));
  }
  next(action);
}
