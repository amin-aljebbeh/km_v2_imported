import 'package:kammun_app/features/cart/domain/use_cases/cart_use_cases.dart';

import '../core/core_importer.dart';
import '../features/cart/data/data_sources/cart_remote_date_source.dart';
import '../features/cart/data/repositories/cart_repository_implement.dart';
import '../features/cart/domain/repositories/cart_repository.dart';
import '../features/cart/domain/use_cases/get_cart_use_case.dart';
import '../features/cart/domain/use_cases/update_order_use_case.dart';

Future<void> injectCart() async {
  sl.registerLazySingleton(() => UpdateOrderUseCase(cartRepository: sl()));
  sl.registerLazySingleton(() => GetCartUseCase(cartRepository: sl()));
  sl.registerLazySingleton<CartUseCases>(() => CartUseCases(updateOrderUSeCase: sl(), getCartUseCase: sl()));
  sl.registerLazySingleton<CartRepository>(
      () => CartRepositoryImplement(cartRemoteDataSource: sl(), repositoryFactory: sl()));
  sl.registerLazySingleton<CartRemoteDataSource>(() => CartRemoteDataSourceImplement());
}
