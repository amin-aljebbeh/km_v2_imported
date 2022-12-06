import 'package:dartz/dartz.dart';
import 'package:kammun_app/features/complaints/domain/entities/complaint_type_entity.dart';

import '../../../../core/core_importer.dart';
import '../entities/complaint_entity.dart';

abstract class ComplaintsRepository {
  Future<Either<Failure, List<ComplaintEntity>>> getComplaints();
  Future<Either<Failure, List<ComplaintTypeEntity>>> getComplaintTypes();
  Future<Either<Failure, Unit>> createComplaint({ComplaintEntity complaintEntity});
  Future<Either<Failure, Unit>> changeComplaintStatus({int complaintId, int statusId});
}
