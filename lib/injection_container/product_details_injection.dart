import '../core/core_importer.dart';
import '../features/product_details/data/data_sources/products_details_remote_data_source.dart';
import '../features/product_details/data/repositories/product_details_repository_implement.dart';
import '../features/product_details/domain/repositories/product_details_repository.dart';
import '../features/product_details/domain/use_cases/delete_product_use_case.dart';
import '../features/product_details/domain/use_cases/product_details_use_cases.dart';

Future<void> injectProductDetails() async {
  sl.registerLazySingleton(() => DeleteProductUseCase(productDetailsRepository: sl()));
  sl.registerLazySingleton<ProductDetailsUSeCases>(() => ProductDetailsUSeCases(deleteProductUseCase: sl()));
  sl.registerLazySingleton<ProductDetailsRepository>(
      () => ProductDetailsRepositoryImplement(productDetailsRemoteDataSource: sl(), repositoryFactory: sl()));
  sl.registerLazySingleton<ProductDetailsRemoteDataSource>(() => ProductDetailsRemoteDataSourceImplement());
}
