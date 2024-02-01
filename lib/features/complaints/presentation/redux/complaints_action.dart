import 'package:dartz/dartz.dart';
import 'package:kammun_app/core/utils/toasta.dart';
import 'package:kammun_app/features/complaints/domain/entities/complaint_entity.dart';
import 'package:kammun_app/features/complaints/domain/entities/complaint_type_entity.dart';

import '../../../../core/core_importer.dart';

abstract class ComplaintsAction {
  handle({@required Store<AppState> store});
}

class SetComplaints {
  final List<ComplaintEntity> complaints;

  SetComplaints({this.complaints});
}

class GetComplaintAction implements ComplaintsAction {
  final BuildContext context;

  GetComplaintAction({this.context});

  @override
  handle({Store<AppState> store}) async {
    store.dispatch(StartLoading());
    Either either = await store.state.complaintsState.complaintsUseCases.getComplaintUseCase();
    either.fold((failure) => snackBar(message: 'حدث خطأ', context: context, success: false),
        (complaints) => store.dispatch(SetComplaints(complaints: complaints)));
    store.dispatch(StopLoading());
  }
}

class GetComplaintTypesAction implements ComplaintsAction {
  GetComplaintTypesAction();

  @override
  handle({Store<AppState> store}) async {
    Either either = await store.state.complaintsState.complaintsUseCases.getComplaintTypeUSeCase();
    either.fold((failure) => store.dispatch(SetComplaintTypes(complaintTypes: [])),
        (complaintTypes) => store.dispatch(SetComplaintTypes(complaintTypes: complaintTypes)));
  }
}

class SetComplaintTypes {
  final List<ComplaintTypeEntity> complaintTypes;

  SetComplaintTypes({this.complaintTypes});
}

class CreateComplaintAction implements ComplaintsAction {
  final BuildContext context;
  final ComplaintEntity complaintEntity;

  CreateComplaintAction({this.complaintEntity, this.context});

  @override
  handle({Store<AppState> store}) async {
    store.dispatch(StartLoading());
    Either either =
        await store.state.complaintsState.complaintsUseCases.createComplaintUseCase(complaintEntity: complaintEntity);
    either.fold((failure) => store.dispatch(CatchError(errorMessage: 'حدث خطأ')),
        (_) => Utility.showToast(message: 'تم تسجيل الشكوى'));
    store.dispatch(StopLoading());
  }
}

class ChangeComplaintStatusAction implements ComplaintsAction {
  final int complaintId;
  final int statusId;
  final BuildContext context;

  ChangeComplaintStatusAction({this.complaintId, this.statusId, this.context});

  @override
  handle({Store<AppState> store}) async {
    store.dispatch(StartLoading());
    Either either = await store.state.complaintsState.complaintsUseCases
        .changeComplaintStatusUseCase(complaintId: complaintId, statusId: statusId);
    either.fold((failure) => store.dispatch(CatchError(errorMessage: 'حدث خطأ')),
        (_) => Utility.showToast(message: 'تم تعديل الشكوى'));
    store.dispatch(StopLoading());
  }
}
