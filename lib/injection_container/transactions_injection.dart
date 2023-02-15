import 'package:kammun_app/features/transactions/data/data_sources/transactions_remote_data_source.dart';

import '../core/core_importer.dart';
import '../features/transactions/data/repositories/transactions_repository_implement.dart';
import '../features/transactions/domain/repositories/transactions_repository.dart';
import '../features/transactions/domain/use_cases/transactions_use_cases.dart';

Future<void> injectTransactions() async {
  sl.registerLazySingleton<TransactionsUseCase>(() => TransactionsUseCase());
  sl.registerLazySingleton<TransactionsRepository>(
      () => TransactionsRepositoryImplement(transactionsRemoteDataSource: sl(), repositoryFactory: sl()));
  sl.registerLazySingleton<TransactionRemoteDataSource>(() => TransactionsRemoteDataSourceImplement());
}
