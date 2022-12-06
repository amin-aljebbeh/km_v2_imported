import 'package:dartz/dartz.dart';
import 'package:kammun_app/features/admins/presentation/redux/admins_action.dart';

import '../../../../core/core_importer.dart';

Future<void> adminsMiddleware(Store<AppState> store, action, NextDispatcher next) async {
  switch (action.runtimeType) {
    case GetAdminsAction:
      Either either = await store.state.adminsState.adminsUseCases.getAdminsUseCase();
      either.fold(
          (failure) => store.dispatch(SetAdmins(admins: [])), (admins) => store.dispatch(SetAdmins(admins: admins)));
      break;
  }
  next(action);
}
