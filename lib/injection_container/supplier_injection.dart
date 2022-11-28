import '../core/core_importer.dart';
import '../views/supplier/data/data_sources/supplier_remote_data_source.dart';
import '../views/supplier/data/repositories/supplier_repository_implement.dart';
import '../views/supplier/domain/repositories/supplier_repository.dart';

Future<void> supplierInject() async {
  sl.registerLazySingleton<SupplierRepository>(() => SupplierRepositoryImplement(supplierRemoteDataSource: sl()));
  sl.registerLazySingleton<SupplierRemoteDataSource>(() => SupplierRemoteDataSourceImplement());
}
