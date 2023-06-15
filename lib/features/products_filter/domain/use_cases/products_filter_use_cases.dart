import '../../../../core/core_importer.dart';
import 'filter_by_last_activation_date_use_case.dart';
import 'filter_by_number_of_sales_use_case.dart';
import 'filter_by_number_of_visits_use_case.dart';
import 'get_deleted_products_from_orders_use_case.dart';

class ProductsFilterUseCases {
  final FilterByLastActivationDateUseCase filterByLastActivationDateUseCase;
  final FilterByNumberOfSalesUseCase filterByNumberOfSalesUseCase;
  final FilterByNumberOfVisitsUseCase filterByNumberOfVisitsUseCase;
  final GetDeletedProductsFromOrdersUseCase getDeletedProductsFromOrdersUseCase;

  ProductsFilterUseCases({
    @required this.filterByLastActivationDateUseCase,
    @required this.filterByNumberOfSalesUseCase,
    @required this.filterByNumberOfVisitsUseCase,
    @required this.getDeletedProductsFromOrdersUseCase,
  }) : assert(
          filterByLastActivationDateUseCase != null &&
              filterByNumberOfSalesUseCase != null &&
              filterByNumberOfVisitsUseCase != null &&
              getDeletedProductsFromOrdersUseCase != null,
          'All use cases should ne initialized.',
        );
}
