import 'package:kammun_app/features/order_details/domain/use_cases/order_details_use_cases.dart';

import '../core/core_importer.dart';
import '../features/order_details/data/data_sources/order_details_remote_data_source.dart';
import '../features/order_details/data/repositories/order_details_repository_implement.dart';
import '../features/order_details/domain/repositories/order_details_repository.dart';
import '../features/order_details/domain/use_cases/add_image_to_order_use_case.dart';
import '../features/order_details/domain/use_cases/delete_image_from_order_use_case.dart';
import '../features/order_details/domain/use_cases/update_order_product_use_case.dart';

Future<void> injectOrderDetails() async {
  sl.registerLazySingleton(() => AddImageToOrderUseCase(orderDetailsRepository: sl()));
  sl.registerLazySingleton(() => DeleteImageFromOrderUseCase(orderDetailsRepository: sl()));
  sl.registerLazySingleton(() => UpdateOrderProductUseCase(orderDetailsRepository: sl()));
  sl.registerLazySingleton<OrderDetailsUseCases>(() => OrderDetailsUseCases(
      addImageToOrderUseCase: sl(), deleteImageFromOrderUseCase: sl(), updateOrderProductUseCase: sl()));
  sl.registerLazySingleton<OrderDetailsRepository>(
      () => OrderDetailsRepositoryImplement(orderDetailsRemoteDataSource: sl(), repositoryFactory: sl()));
  sl.registerLazySingleton<OrderDetailsRemoteDataSource>(() => OrderDetailsRemoteDataSourceImplement());
}
