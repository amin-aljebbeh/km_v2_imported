import '../core/core_importer.dart';
import '../features/products/data/data_sources/products_remote_data_source.dart';
import '../features/products/data/repositories/products_repository_implement.dart';
import '../features/products/domain/repositories/products_repository.dart';
import '../features/products/domain/use_cases/get_barcode_products_use_case.dart';
import '../features/products/domain/use_cases/get_category_products_use_case.dart';
import '../features/products/domain/use_cases/products_use_cases.dart';
import '../features/products/domain/use_cases/search_products_use_case.dart';

Future<void> injectProducts() async {
  sl.registerLazySingleton(() => GetBarcodeProductsUseCase(productsRepository: sl()));
  sl.registerLazySingleton(() => GetCategoryProductsUseCase(productsRepository: sl()));
  sl.registerLazySingleton(() => SearchProductsUseCase(productsRepository: sl()));
  sl.registerLazySingleton<ProductsUSeCases>(() =>
      ProductsUSeCases(getBarcodeProductsUseCase: sl(), getCategoryProductsUseCase: sl(), searchProductsUseCase: sl()));
  sl.registerLazySingleton<ProductsRepository>(
      () => ProductsRepositoryImplement(productsRemoteDataSource: sl(), repositoryFactory: sl()));
  sl.registerLazySingleton<ProductsRemoteDataSource>(() => ProductsRemoteDataSourceImplement());
}
