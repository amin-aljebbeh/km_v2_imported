import 'package:dartz/dartz.dart';
import 'package:kammun_app/views/complaints/data/data_sources/complaints_remote_data_source.dart';
import 'package:kammun_app/views/complaints/domain/entities/complaint_entity.dart';
import 'package:kammun_app/views/complaints/domain/repositories/complaints_repository.dart';

import '../../../../core/core_importer.dart';

class ComplaintsRepositoryImplement implements ComplaintsRepository {
  final ComplaintsRemoteDataSource complaintsRemoteDataSource;

  ComplaintsRepositoryImplement({this.complaintsRemoteDataSource});

  @override
  Future<Either<Failure, List<ComplaintEntity>>> getComplaints() async {
    try {
      List<ComplaintEntity> complaints = await complaintsRemoteDataSource.getComplaints();
      return Right(complaints);
    } on CacheException {
      return Left(CacheFailure());
    } on ServerException {
      return Left(ServerFailure());
    } on OfflineException {
      return Left(OfflineFailure());
    } catch (e) {
      return Left(InternalFailure());
    }
  }
}
