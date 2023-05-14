import 'package:kammun_app/core/core_importer.dart';

class RemainingStatementEntity extends Equatable {
  const RemainingStatementEntity({this.subWarehouseId, this.name, this.remainingMonyForSupplier});

  final int subWarehouseId;
  final String name;
  final String remainingMonyForSupplier;

  @override
  List<Object> get props => [subWarehouseId, name, remainingMonyForSupplier];
}
