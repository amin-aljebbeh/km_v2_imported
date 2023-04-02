import 'package:kammun_app/features/orders_feature/data/data_sources/orders_remote_data_source.dart';
import 'package:kammun_app/features/orders_feature/domain/repositories/orders_repository.dart';
import 'package:kammun_app/features/orders_feature/domain/use_cases/orders_use_cases.dart';
import 'package:kammun_app/features/orders_feature/domain/use_cases/re_assign_order_use_case.dart';

import '../core/core_importer.dart';
import '../features/orders_feature/data/repositories/orders_repository_implement.dart';
import '../features/orders_feature/domain/use_cases/update_order_rating_use_case.dart';

Future<void> injectOrders() async {
  sl.registerLazySingleton(() => ReAssignOrderUseCase(ordersRepository: sl()));
  sl.registerLazySingleton(() => UpdateOrderRatingUseCase(ordersRepository: sl()));
  sl.registerLazySingleton<OrdersUSeCases>(
      () => OrdersUSeCases(reAssignOrderUseCase: sl(), updateOrderRatingUseCase: sl()));
  sl.registerLazySingleton<OrdersRepository>(
      () => OrdersRepositoryImplement(ordersRemoteDataSource: sl(), repositoryFactory: sl()));
  sl.registerLazySingleton<OrdersRemoteDataSource>(() => OrdersRemoteDataSourceImplement());
}
