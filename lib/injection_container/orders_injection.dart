import 'package:kammun_app/features/orders_feature/data/data_sources/orders_remote_data_source.dart';
import 'package:kammun_app/features/orders_feature/domain/repositories/orders_repository.dart';
import 'package:kammun_app/features/orders_feature/domain/use_cases/orders_use_cases.dart';
import 'package:kammun_app/features/orders_feature/domain/use_cases/re_assign_order_use_case.dart';

import '../core/core_importer.dart';
import '../features/orders_feature/data/repositories/orders_repository_implement.dart';
import '../features/orders_feature/domain/use_cases/assign_order_to_shopper_use_case.dart';
import '../features/orders_feature/domain/use_cases/change_order_status_use_case.dart';
import '../features/orders_feature/domain/use_cases/get_all_orders_use_case.dart';
import '../features/orders_feature/domain/use_cases/get_order_use_case.dart';
import '../features/orders_feature/domain/use_cases/get_orders_by_user_number_use_case.dart';
import '../features/orders_feature/domain/use_cases/get_shopper_orders_use_case.dart';
import '../features/orders_feature/domain/use_cases/get_supplier_orders_use_case.dart';
import '../features/orders_feature/domain/use_cases/lock_order_use_case.dart';
import '../features/orders_feature/domain/use_cases/unlock_order_use_case.dart';
import '../features/orders_feature/domain/use_cases/update_order_rating_use_case.dart';

Future<void> injectOrders() async {
  sl.registerLazySingleton(() => ReAssignOrderUseCase(ordersRepository: sl()));
  sl.registerLazySingleton(() => UpdateOrderRatingUseCase(ordersRepository: sl()));
  sl.registerLazySingleton(() => AssignOrderToShopperUseCase(ordersRepository: sl()));
  sl.registerLazySingleton(() => ChangeOrderStatusUseCase(ordersRepository: sl()));
  sl.registerLazySingleton(() => GetAllOrdersUseCase(ordersRepository: sl()));
  sl.registerLazySingleton(() => GetOrderUseCase(ordersRepository: sl()));
  sl.registerLazySingleton(() => GetOrdersByUserNumberUseCase(ordersRepository: sl()));
  sl.registerLazySingleton(() => GetShopperOrdersUseCase(ordersRepository: sl()));
  sl.registerLazySingleton(() => GetSupplierOrdersUseCase(ordersRepository: sl()));
  sl.registerLazySingleton(() => LockOrderUseCase(ordersRepository: sl()));
  sl.registerLazySingleton(() => UnlockOrderUseCase(ordersRepository: sl()));
  sl.registerLazySingleton<OrdersUSeCases>(() => OrdersUSeCases(
        reAssignOrderUseCase: sl(),
        updateOrderRatingUseCase: sl(),
        assignOrderToShopperUseCase: sl(),
        changeOrderStatusUseCase: sl(),
        getAllOrdersUseCase: sl(),
        getOrderUseCase: sl(),
        getOrdersByUserNumberUseCase: sl(),
        getShopperOrdersUseCase: sl(),
        getSupplierOrdersUseCase: sl(),
        lockOrderUseCase: sl(),
        unlockOrderUseCase: sl(),
      ));
  sl.registerLazySingleton<OrdersRepository>(
      () => OrdersRepositoryImplement(ordersRemoteDataSource: sl(), repositoryFactory: sl()));
  sl.registerLazySingleton<OrdersRemoteDataSource>(() => OrdersRemoteDataSourceImplement());
}
