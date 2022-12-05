import '../core/core_importer.dart';
import '../features/supplier/data/data_sources/supplier_remote_data_source.dart';
import '../features/supplier/data/repositories/supplier_repository_implement.dart';
import '../features/supplier/domain/repositories/supplier_repository.dart';

Future<void> injectSupplier() async {
  sl.registerLazySingleton<SupplierRepository>(() => SupplierRepositoryImplement(supplierRemoteDataSource: sl()));
  sl.registerLazySingleton<SupplierRemoteDataSource>(() => SupplierRemoteDataSourceImplement());
}
