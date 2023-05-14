import 'package:kammun_app/features/supplier/domain/use_cases/account_statement_use_case.dart';
import 'package:kammun_app/features/supplier/domain/use_cases/supplier_use_cases.dart';

import '../core/core_importer.dart';
import '../features/supplier/data/data_sources/supplier_remote_data_source.dart';
import '../features/supplier/data/repositories/supplier_repository_implement.dart';
import '../features/supplier/domain/repositories/supplier_repository.dart';
import '../features/supplier/domain/use_cases/remaining_statment_use_case.dart';

Future<void> injectSupplier() async {
  sl.registerLazySingleton(() => AccountStatementUseCase(supplierRepository: sl()));
  sl.registerLazySingleton(() => RemainingStatementUseCase(supplierRepository: sl()));
  sl.registerLazySingleton<SupplierUseCases>(
      () => SupplierUseCases(getSupplierAccountStatementUseCase: sl(), remainingStatementUseCase: sl()));
  sl.registerLazySingleton<SupplierRepository>(() => SupplierRepositoryImplement(supplierRemoteDataSource: sl()));
  sl.registerLazySingleton<SupplierRemoteDataSource>(() => SupplierRemoteDataSourceImplement());
}
