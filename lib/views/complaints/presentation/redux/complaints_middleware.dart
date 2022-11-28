import 'package:dartz/dartz.dart';

import '../../../../core/core_importer.dart';
import 'complaints_action.dart';

Future<void> complaintsMiddleware(Store<AppState> store, action, NextDispatcher next) async {
  if (action is GetComplaintAction) {
    store.dispatch(StartLoading());
    Either either = await store.state.complaintsState.complaintsUseCases.getComplaintUseCase();
    either.fold((failure) => snackBar(message: 'حدث خطأ', context: action.context, success: false),
        (complaints) => store.dispatch(SetComplaints(complaints: complaints)));
    store.dispatch(StopLoading());
  }
  next(action);
}
