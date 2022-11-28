import 'package:kammun_app/views/loading_feature/presentation/redux/loading_state.dart';

import '../core/core_importer.dart';
import '../views/complaints/presentation/redux/complaints_state.dart';
import '../views/error/presentation/redux/error_state.dart';
import '../views/inventory_feature/presentation/redux/inventory_state.dart';
import '../views/supplier/presentation/redux/supplier_state.dart';

@immutable
class AppState extends Equatable {
  final ComplaintsState complaintsState;
  final ErrorState errorState;
  final InventoryState inventoryState;
  final LoadingState loadingState;
  final SupplierState supplierState;
  const AppState({this.inventoryState, this.errorState, this.loadingState, this.supplierState, this.complaintsState});

  factory AppState.initial() => AppState(
        inventoryState: InventoryState.initial(),
        errorState: ErrorState.initial(),
        loadingState: LoadingState.initial(),
        supplierState: SupplierState.initial(),
        complaintsState: ComplaintsState.initial(),
      );

  AppState copyWith({
    InventoryState inventoryState,
    ErrorState errorState,
    LoadingState loadingState,
    SupplierState supplierState,
    ComplaintsState complaintsState,
  }) {
    return AppState(
      inventoryState: inventoryState ?? this.inventoryState,
      errorState: errorState ?? this.errorState,
      loadingState: loadingState ?? this.loadingState,
      supplierState: supplierState ?? this.supplierState,
      complaintsState: complaintsState ?? this.complaintsState,
    );
  }

  @override
  List<Object> get props => [inventoryState, errorState, loadingState, supplierState, complaintsState];
}
