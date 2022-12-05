import 'package:dartz/dartz.dart';
import 'package:kammun_app/features/complaints/domain/repositories/complaints_repository.dart';

import '../../../../core/core_importer.dart';
import '../entities/complaint_entity.dart';

class CreateComplaintUseCase {
  final ComplaintsRepository complaintsRepository;

  CreateComplaintUseCase({this.complaintsRepository});

  Future<Either<Failure, Unit>> call({ComplaintEntity complaintEntity}) async {
    return await complaintsRepository.createComplaint(complaintEntity: complaintEntity);
  }
}
