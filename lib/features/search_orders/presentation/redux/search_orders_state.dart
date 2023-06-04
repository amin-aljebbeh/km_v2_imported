import '../../../../core/core_importer.dart';
import '../../../orders_feature/domain/entities/order_entity.dart';
import '../../domain/use_cases/search_orders_use_cases.dart';

@immutable
class SearchOrdersState extends Equatable {
  final SearchOrdersUSeCases searchOrdersUSeCases;
  final SearchOrdersTypes searchOrdersType;
  final List<OrderEntity> orders;
  final int statusFilter;
  final String phoneNumber;
  final int id;
  final int page;

  const SearchOrdersState(
      {this.statusFilter,
      this.phoneNumber,
      this.id,
      this.searchOrdersUSeCases,
      this.orders,
      this.page,
      this.searchOrdersType});

  factory SearchOrdersState.initial() {
    return SearchOrdersState(
      searchOrdersUSeCases: sl<SearchOrdersUSeCases>(),
      orders: const [],
      statusFilter: 0,
      page: 1,
      searchOrdersType: SearchOrdersTypes.none,
    );
  }

  SearchOrdersState copyWith({
    List<OrderEntity> orders,
    int statusFilter,
    int page,
    SearchOrdersTypes searchOrdersType,
    String phoneNumber,
    int id,
  }) {
    return SearchOrdersState(
      searchOrdersUSeCases: searchOrdersUSeCases,
      orders: orders ?? this.orders,
      statusFilter: statusFilter ?? this.statusFilter,
      page: page ?? this.page,
      id: id ?? this.id,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      searchOrdersType: searchOrdersType ?? this.searchOrdersType,
    );
  }

  @override
  List<Object> get props => [searchOrdersUSeCases, orders, statusFilter, page, searchOrdersType, id, phoneNumber];
}
