import 'package:dartz/dartz.dart';

import '../../../../core/core_importer.dart';
import 'complaints_action.dart';

Future<void> complaintsMiddleware(Store<AppState> store, action, NextDispatcher next) async {
  switch (action.runtimeType) {
    case GetComplaintAction:
      store.dispatch(StartLoading());
      Either either = await store.state.complaintsState.complaintsUseCases.getComplaintUseCase();
      either.fold((failure) => snackBar(message: 'حدث خطأ', context: action.context, success: false),
          (complaints) => store.dispatch(SetComplaints(complaints: complaints)));
      store.dispatch(StopLoading());
      break;
    case GetComplaintTypesAction:
      Either either = await store.state.complaintsState.complaintsUseCases.getComplaintTypeUSeCase();
      either.fold((failure) => store.dispatch(SetComplaintTypes(complaintTypes: [])),
          (complaintTypes) => store.dispatch(SetComplaintTypes(complaintTypes: complaintTypes)));
      break;
    case CreateComplaintAction:
      store.dispatch(StartLoading());
      Either either = await store.state.complaintsState.complaintsUseCases.createComplaintUseCase();
      either.fold((failure) => snackBar(message: 'حدث خطأ', context: action.context, success: false),
          (complaints) => snackBar(message: 'تم تسجيل الشكوى', context: action.context, success: true));
      store.dispatch(StopLoading());
      break;
  }
  next(action);
}
