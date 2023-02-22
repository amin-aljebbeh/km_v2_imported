import 'package:kammun_app/features/transactions/data/data_sources/transactions_remote_data_source.dart';

import '../core/core_importer.dart';
import '../features/transactions/data/repositories/transactions_repository_implement.dart';
import '../features/transactions/domain/repositories/transactions_repository.dart';
import '../features/transactions/domain/use_cases/create_transaction_request_use_case.dart';
import '../features/transactions/domain/use_cases/delete_transaction_request_use_case.dart';
import '../features/transactions/domain/use_cases/get_transaction_categories_use_case.dart';
import '../features/transactions/domain/use_cases/get_transaction_requests_use_case.dart';
import '../features/transactions/domain/use_cases/transactions_use_cases.dart';
import '../features/transactions/domain/use_cases/update_transaction_request_use_case.dart';

Future<void> injectTransactions() async {
  sl.registerLazySingleton(() => CreateTransactionRequestUseCase(transactionsRepository: sl()));
  sl.registerLazySingleton(() => DeleteTransactionRequestUseCase(transactionsRepository: sl()));
  sl.registerLazySingleton(() => GetTransactionRequestsUseCase(transactionsRepository: sl()));
  sl.registerLazySingleton(() => UpdateTransactionRequestUseCase(transactionsRepository: sl()));
  sl.registerLazySingleton(() => GetTransactionCategoriesUseCase(transactionsRepository: sl()));
  sl.registerLazySingleton<TransactionsUseCase>(() => TransactionsUseCase(
        createTransactionRequestUseCase: sl(),
        deleteTransactionRequestUseCase: sl(),
        getTransactionRequestsUseCase: sl(),
        getTransactionCategoriesUseCase: sl(),
        updateTransactionRequestUseCase: sl(),
      ));
  sl.registerLazySingleton<TransactionsRepository>(
      () => TransactionsRepositoryImplement(transactionsRemoteDataSource: sl(), repositoryFactory: sl()));
  sl.registerLazySingleton<TransactionRemoteDataSource>(() => TransactionsRemoteDataSourceImplement());
}
