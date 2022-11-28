import 'package:dartz/dartz.dart';

import '../../../../core/core_importer.dart';
import '../entities/complaint_entity.dart';

abstract class ComplaintsRepository {
  Future<Either<Failure, List<ComplaintEntity>>> getComplaints();
}
