import 'package:kammun_app/features/complaints/domain/entities/complaint_entity.dart';
import 'package:kammun_app/features/complaints/domain/entities/complaint_type_entity.dart';

import '../../../../core/core_importer.dart';

class SetComplaints {
  final List<ComplaintEntity> complaints;

  SetComplaints({this.complaints});
}

class GetComplaintAction {
  final BuildContext context;

  GetComplaintAction({this.context});
}

class GetComplaintTypesAction {
  GetComplaintTypesAction();
}

class SetComplaintTypes {
  final List<ComplaintTypeEntity> complaintTypes;

  SetComplaintTypes({this.complaintTypes});
}

class CreateComplaintAction {
  final BuildContext context;
  final ComplaintEntity complaintEntity;

  CreateComplaintAction({this.complaintEntity, this.context});
}

class ChangeComplaintStatusAction {
  final int complaintId;
  final int statusId;
  final BuildContext context;

  ChangeComplaintStatusAction({this.complaintId, this.statusId, this.context});
}
