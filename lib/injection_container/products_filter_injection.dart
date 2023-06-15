import '../core/core_importer.dart';
import '../features/products_filter/data/data_sources/products_filter_remote_data_source.dart';
import '../features/products_filter/data/repositories/products_filter_repository_implement.dart';
import '../features/products_filter/domain/repositories/products_filter_repository.dart';
import '../features/products_filter/domain/use_cases/filter_by_last_activation_date_use_case.dart';
import '../features/products_filter/domain/use_cases/filter_by_number_of_sales_use_case.dart';
import '../features/products_filter/domain/use_cases/filter_by_number_of_visits_use_case.dart';
import '../features/products_filter/domain/use_cases/get_deleted_products_from_orders_use_case.dart';
import '../features/products_filter/domain/use_cases/products_filter_use_cases.dart';

Future<void> injectProductsFilter() async {
  sl.registerLazySingleton(() => FilterByLastActivationDateUseCase(productsFilterRepository: sl()));
  sl.registerLazySingleton(() => FilterByNumberOfSalesUseCase(productsFilterRepository: sl()));
  sl.registerLazySingleton(() => FilterByNumberOfVisitsUseCase(productsFilterRepository: sl()));
  sl.registerLazySingleton(() => GetDeletedProductsFromOrdersUseCase(productsFilterRepository: sl()));
  sl.registerLazySingleton<ProductsFilterUseCases>(() => ProductsFilterUseCases(
        filterByLastActivationDateUseCase: sl(),
        filterByNumberOfSalesUseCase: sl(),
        filterByNumberOfVisitsUseCase: sl(),
        getDeletedProductsFromOrdersUseCase: sl(),
      ));
  sl.registerLazySingleton<ProductsFilterRepository>(
      () => ProductsFilterRepositoryImplement(productsFilterRemoteDataSource: sl(), repositoryFactory: sl()));
  sl.registerLazySingleton<ProductsFilterRemoteDataSource>(() => ProductsFilterRemoteDataSourceImplement());
}
