import 'package:dartz/dartz.dart';

import '../../../../core/core_importer.dart';
import '../../domain/entities/complaint_entity.dart';
import '../../domain/entities/complaint_type_entity.dart';
import '../../domain/repositories/complaints_repository.dart';
import '../data_sources/complaints_remote_data_source.dart';

class ComplaintsRepositoryImplement implements ComplaintsRepository {
  final ComplaintsRemoteDataSource complaintsRemoteDataSource;
  final RepositoryFactory repositoryFactory;

  ComplaintsRepositoryImplement({this.complaintsRemoteDataSource, this.repositoryFactory});

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

  @override
  Future<Either<Failure, List<ComplaintTypeEntity>>> getComplaintTypes() async {
    try {
      List<ComplaintTypeEntity> complaints = await complaintsRemoteDataSource.getComplaintTypes();
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

  @override
  Future<Either<Failure, Unit>> createComplaint({ComplaintEntity complaintEntity}) async {
    return await repositoryFactory.failureUnitRepo(
        function: () => complaintsRemoteDataSource.createComplaint(complaintModel: complaintEntity));
  }

  @override
  Future<Either<Failure, Unit>> changeComplaintStatus({int complaintId, int statusId}) async {
    return await repositoryFactory.failureUnitRepo(
        function: () => complaintsRemoteDataSource.changeComplaintStatus(complaintId: complaintId, statusId: statusId));
  }
}
