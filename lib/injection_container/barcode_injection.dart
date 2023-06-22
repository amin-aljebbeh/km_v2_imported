import '../core/core_importer.dart';
import '../features/barcode/data/data_sources/barcode_remote_data_source.dart';
import '../features/barcode/data/repositories/barcode_repository_implement.dart';
import '../features/barcode/domain/repositories/barcode_repository.dart';
import '../features/barcode/domain/use_cases/barcode_use_cases.dart';
import '../features/barcode/domain/use_cases/delete_barcode_use_case.dart';
import '../features/barcode/domain/use_cases/set_barcode_to_product_use_case.dart';

Future<void> injectBarcode() async {
  sl.registerLazySingleton(() => SetBarcodeToProductUseCase(barcodeRepository: sl()));
  sl.registerLazySingleton(() => DeleteBarcodeUseCase(barcodeRepository: sl()));
  sl.registerLazySingleton<BarcodeUseCases>(
      () => BarcodeUseCases(setBarcodeToProductUseCase: sl(), deleteBarcodeUseCase: sl()));
  sl.registerLazySingleton<BarcodeRepository>(
      () => BarcodeRepositoryImplement(barcodeRemoteDataSource: sl(), repositoryFactory: sl()));
  sl.registerLazySingleton<BarcodeRemoteDataSource>(() => BarcodeRemoteDataSourceImplement());
}
