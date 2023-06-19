import '../../../../core/core_importer.dart';
import '../../domain/use_cases/sub_warehouse_manager_use_cases.dart';

@immutable
class SubWarehouseManagerState extends Equatable {
  final SubWarehouseManagerUseCases subWarehouseManagerUseCases;
  final File file;
  final int subWarehouseId;

  const SubWarehouseManagerState({this.file, this.subWarehouseId, this.subWarehouseManagerUseCases});

  factory SubWarehouseManagerState.initial() {
    return SubWarehouseManagerState(subWarehouseManagerUseCases: sl<SubWarehouseManagerUseCases>());
  }

  SubWarehouseManagerState copyWith({File file, int subWarehouseId}) {
    return SubWarehouseManagerState(
      subWarehouseManagerUseCases: subWarehouseManagerUseCases,
      file: file ?? this.file,
      subWarehouseId: subWarehouseId == -1 ? null : subWarehouseId ?? this.subWarehouseId,
    );
  }

  @override
  List<Object> get props => [subWarehouseManagerUseCases, file, subWarehouseId];
}
