import '../core/core_importer.dart';
import '../features/search_orders/data/data_sources/search_orders_remote_data_source.dart';
import '../features/search_orders/data/repositories/search_orders_repository_implement.dart';
import '../features/search_orders/domain/repositories/search_orders_repository.dart';
import '../features/search_orders/domain/use_cases/get_order_use_case.dart';
import '../features/search_orders/domain/use_cases/get_orders_by_user_number_use_case.dart';
import '../features/search_orders/domain/use_cases/search_orders_use_cases.dart';

Future<void> injectSearchOrders() async {
  sl.registerLazySingleton(() => GetOrderUseCase(ordersRepository: sl()));
  sl.registerLazySingleton(() => GetOrdersByUserNumberUseCase(ordersRepository: sl()));
  sl.registerLazySingleton<SearchOrdersUSeCases>(
      () => SearchOrdersUSeCases(getOrdersByUserNumberUseCase: sl(), getOrderUseCase: sl()));
  sl.registerLazySingleton<SearchOrdersRepository>(
      () => SearchOrdersRepositoryImplement(ordersRemoteDataSource: sl(), repositoryFactory: sl()));
  sl.registerLazySingleton<SearchOrdersRemoteDataSource>(() => SearchOrdersRemoteDataSourceImplement());
}
