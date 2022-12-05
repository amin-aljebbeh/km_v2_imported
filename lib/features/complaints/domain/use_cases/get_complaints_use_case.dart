import 'package:dartz/dartz.dart';
import 'package:kammun_app/features/complaints/domain/repositories/complaints_repository.dart';

import '../../../../core/core_importer.dart';
import '../entities/complaint_entity.dart';

class GetComplaintsUseCase {
  final ComplaintsRepository complaintsRepository;

  GetComplaintsUseCase({this.complaintsRepository});

  Future<Either<Failure, List<ComplaintEntity>>> call() async {
    return await complaintsRepository.getComplaints();
  }
}
