import '../../../../core/core_importer.dart';
import '../../domain/use_cases/excel_inventory_use_cases.dart';

@immutable
class ExcelInventoryState extends Equatable {
  final ExcelInventoryUseCases excelInventoryUseCases;
  final File file;
  final int subWarehouseId;

  const ExcelInventoryState({
    this.file,
    this.subWarehouseId,
    this.excelInventoryUseCases,
  });

  factory ExcelInventoryState.initial() {
    return ExcelInventoryState(
      excelInventoryUseCases: sl<ExcelInventoryUseCases>()
    );
  }

  ExcelInventoryState copyWith({
    File file,
    int subWarehouseId,
  }) {
    return ExcelInventoryState(
      excelInventoryUseCases: excelInventoryUseCases,
      file: file ?? this.file,
      subWarehouseId: subWarehouseId == -1 ? null : subWarehouseId ?? this.subWarehouseId,
    );
  }

  @override
  List<Object> get props => [
        excelInventoryUseCases,
        file,
        subWarehouseId
      ];
}
