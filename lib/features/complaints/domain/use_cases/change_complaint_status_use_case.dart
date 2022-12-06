import 'package:dartz/dartz.dart';
import 'package:kammun_app/features/complaints/domain/repositories/complaints_repository.dart';

import '../../../../core/core_importer.dart';

class ChangeComplaintStatusUseCase {
  final ComplaintsRepository complaintsRepository;

  ChangeComplaintStatusUseCase({this.complaintsRepository});

  Future<Either<Failure, Unit>> call({int complaintId, int statusId}) async {
    return await complaintsRepository.changeComplaintStatus(statusId: statusId, complaintId: complaintId);
  }
}
