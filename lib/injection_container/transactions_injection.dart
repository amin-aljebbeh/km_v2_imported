import 'package:kammun_app/features/transactions/data/data_sources/transactions_remote_data_source.dart';

import '../core/core_importer.dart';
import '../features/transactions/data/repositories/transactions_repository_implement.dart';
import '../features/transactions/domain/repositories/transactions_repository.dart';
import '../features/transactions/domain/use_cases/create_transaction_use_case.dart';
import '../features/transactions/domain/use_cases/delete_transaction_request_use_case.dart';
import '../features/transactions/domain/use_cases/get_admin_balance_use_case.dart';
import '../features/transactions/domain/use_cases/get_shopper_report_use_case.dart';
import '../features/transactions/domain/use_cases/get_transaction_categories_use_case.dart';
import '../features/transactions/domain/use_cases/get_transaction_requests_use_case.dart';
import '../features/transactions/domain/use_cases/get_transactions_use_case.dart';
import '../features/transactions/domain/use_cases/transactions_use_cases.dart';
import '../features/transactions/domain/use_cases/update_transaction_request_use_case.dart';

Future<void> injectTransactions() async {
  sl.registerLazySingleton(() => DeleteTransactionRequestUseCase(transactionsRepository: sl()));
  sl.registerLazySingleton(() => GetTransactionRequestsUseCase(transactionsRepository: sl()));
  sl.registerLazySingleton(() => ChangeTransactionRequestStatusUseCase(transactionsRepository: sl()));
  sl.registerLazySingleton(() => GetTransactionCategoriesUseCase(transactionsRepository: sl()));
  sl.registerLazySingleton(() => CreateTransactionUseCase(transactionsRepository: sl()));
  sl.registerLazySingleton(() => GetTransactionsUseCase(transactionsRepository: sl()));
  sl.registerLazySingleton(() => GetShopperReportUseCase(transactionsRepository: sl()));
  sl.registerLazySingleton(() => GetAdminBalanceUseCase(transactionsRepository: sl()));
  sl.registerLazySingleton<TransactionsUseCase>(() => TransactionsUseCase(
        deleteTransactionRequestUseCase: sl(),
        getTransactionRequestsUseCase: sl(),
        getTransactionCategoriesUseCase: sl(),
        changeTransactionRequestStatusUseCase: sl(),
        createTransactionUseCase: sl(),
        getTransactionsUseCase: sl(),
        getShopperReportUseCase: sl(),
        getAdminBalanceUseCase: sl(),
      ));
  sl.registerLazySingleton<TransactionsRepository>(
      () => TransactionsRepositoryImplement(transactionsRemoteDataSource: sl(), repositoryFactory: sl()));
  sl.registerLazySingleton<TransactionRemoteDataSource>(() => TransactionsRemoteDataSourceImplement());
}
