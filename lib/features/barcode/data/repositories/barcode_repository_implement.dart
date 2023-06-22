import 'package:dartz/dartz.dart';
import 'package:kammun_app/core/core_importer.dart';
import 'package:kammun_app/features/barcode/data/data_sources/barcode_remote_data_source.dart';

import '../../domain/repositories/barcode_repository.dart';

class BarcodeRepositoryImplement implements BarcodeRepository {
  final BarcodeRemoteDataSource barcodeRemoteDataSource;
  final RepositoryFactory repositoryFactory;

  BarcodeRepositoryImplement({this.barcodeRemoteDataSource, this.repositoryFactory});
  @override
  Future<Either<Failure, String>> setBarcodeToProduct({int barcode, int productId}) async {
    try {
      String response = await barcodeRemoteDataSource.setBarcodeToProduct(productId: productId, barcode: barcode);
      return Right(response);
    } on CacheException {
      return Left(CacheFailure());
    } on ServerException {
      return Left(ServerFailure());
    } on OfflineException {
      return Left(OfflineFailure());
    } on OfflineRegionException catch (e) {
      return Left(OfflineRegionFailure(message: e.message));
    } catch (e) {
      return Left(InternalFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, Unit>> deleteBarcode({String barcodeId}) async {
    return await repositoryFactory.failureUnitRepo(
        function: () => barcodeRemoteDataSource.deleteBarcode(barcodeId: barcodeId));
  }
}
