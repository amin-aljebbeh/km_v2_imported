import 'package:dartz/dartz.dart';
import 'package:kammun_app/features/complaints/domain/repositories/complaints_repository.dart';

import '../../../../core/core_importer.dart';
import '../entities/complaint_type_entity.dart';

class GetComplaintTypeUSeCase {
  final ComplaintsRepository complaintsRepository;

  GetComplaintTypeUSeCase({this.complaintsRepository});

  Future<Either<Failure, List<ComplaintTypeEntity>>> call() async {
    return await complaintsRepository.getComplaintTypes();
  }
}
