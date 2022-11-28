import 'package:kammun_app/views/complaints/domain/entities/complaint_entity.dart';

import '../../../../core/core_importer.dart';

class SetComplaints {
  final List<ComplaintEntity> complaints;

  SetComplaints({this.complaints});
}

class GetComplaintAction {
  final BuildContext context;

  GetComplaintAction({this.context});
}
