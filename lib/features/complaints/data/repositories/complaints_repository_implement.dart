import 'package:dartz/dartz.dart';
import 'package:kammun_app/features/complaints/data/data_sources/complaints_remote_data_source.dart';
import 'package:kammun_app/features/complaints/domain/entities/complaint_entity.dart';
import 'package:kammun_app/features/complaints/domain/entities/complaint_type_entity.dart';
import 'package:kammun_app/features/complaints/domain/repositories/complaints_repository.dart';

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
    try {
      await complaintsRemoteDataSource.createComplaint(complaintModel: complaintEntity);
      return const Right(unit);
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
