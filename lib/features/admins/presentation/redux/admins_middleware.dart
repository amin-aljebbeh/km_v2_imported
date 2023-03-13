import 'package:dartz/dartz.dart';
import 'package:kammun_app/features/admins/presentation/redux/admins_action.dart';

import '../../../../core/core_importer.dart';

Future<void> adminsMiddleware(Store<AppState> store, action, NextDispatcher next) async {
  if (action is GetAdminsAction) {
    Either either = await store.state.adminsState.adminsUseCases.getAdminsUseCase();
    either.fold(
        (failure) => store.dispatch(SetAdmins(admins: [])), (admins) => store.dispatch(SetAdmins(admins: admins)));
  } else if (action is GetTransactionsActorsAction) {
    store.dispatch(StartLoading());
    Either either =
        await store.state.adminsState.adminsUseCases.getTransactionsActorsUseCase(categoryId: action.categoryId);
    either.fold((failure) => store.dispatch(SetTransactionsActors(admins: [])),
        (admins) => store.dispatch(SetTransactionsActors(admins: admins)));
    store.dispatch(StopLoading());
  }
  next(action);
}
