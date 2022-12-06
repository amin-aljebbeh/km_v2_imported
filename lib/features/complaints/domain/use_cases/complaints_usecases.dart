import 'package:kammun_app/core/core_importer.dart';
import 'package:kammun_app/features/complaints/domain/use_cases/change_complaint_status_use_case.dart';
import 'package:kammun_app/features/complaints/domain/use_cases/create_complaint_use_case.dart';
import 'package:kammun_app/features/complaints/domain/use_cases/get_complaint_types_use_case.dart';

import 'get_complaints_use_case.dart';

class ComplaintsUseCases {
  final GetComplaintsUseCase getComplaintUseCase;
  final GetComplaintTypeUSeCase getComplaintTypeUSeCase;
  final CreateComplaintUseCase createComplaintUseCase;
  final ChangeComplaintStatusUseCase changeComplaintStatusUseCase;

  const ComplaintsUseCases({
    @required this.getComplaintUseCase,
    @required this.getComplaintTypeUSeCase,
    @required this.createComplaintUseCase,
    @required this.changeComplaintStatusUseCase,
  }) : assert(
            getComplaintUseCase != null &&
                getComplaintTypeUSeCase != null &&
                createComplaintUseCase != null &&
                changeComplaintStatusUseCase != null,
            'All use cases should be initialized');
}
