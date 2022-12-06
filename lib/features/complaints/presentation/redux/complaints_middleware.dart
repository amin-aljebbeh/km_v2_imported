import 'package:dartz/dartz.dart';

import '../../../../core/core_importer.dart';
import 'complaints_action.dart';

Future<void> complaintsMiddleware(Store<AppState> store, action, NextDispatcher next) async {
  switch (action.runtimeType) {
    case GetComplaintAction:
      var actionType = action as GetComplaintAction;
      store.dispatch(StartLoading());
      Either either = await store.state.complaintsState.complaintsUseCases.getComplaintUseCase();
      either.fold((failure) => snackBar(message: 'حدث خطأ', context: actionType.context, success: false),
          (complaints) => store.dispatch(SetComplaints(complaints: complaints)));
      store.dispatch(StopLoading());
      break;
    case GetComplaintTypesAction:
      Either either = await store.state.complaintsState.complaintsUseCases.getComplaintTypeUSeCase();
      either.fold((failure) => store.dispatch(SetComplaintTypes(complaintTypes: [])),
          (complaintTypes) => store.dispatch(SetComplaintTypes(complaintTypes: complaintTypes)));
      break;
    case CreateComplaintAction:
      var actionType = action as CreateComplaintAction;
      store.dispatch(StartLoading());
      Either either = await store.state.complaintsState.complaintsUseCases
          .createComplaintUseCase(complaintEntity: actionType.complaintEntity);
      either.fold((failure) => snackBar(message: 'حدث خطأ', context: actionType.context, success: false),
          (_) => snackBar(message: 'تم تسجيل الشكوى', context: actionType.context, success: true));
      store.dispatch(StopLoading());
      break;
    case ChangeComplaintStatusAction:
      var actionType = action as ChangeComplaintStatusAction;
      store.dispatch(StartLoading());
      Either either = await store.state.complaintsState.complaintsUseCases
          .changeComplaintStatusUseCase(complaintId: actionType.complaintId, statusId: actionType.statusId);
      either.fold((failure) => snackBar(message: 'حدث خطأ', context: actionType.context, success: false),
          (_) => snackBar(message: 'تم تعديل الشكوى', context: actionType.context, success: true));
      store.dispatch(StopLoading());
      break;
  }
  next(action);
}
