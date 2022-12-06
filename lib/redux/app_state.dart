import 'package:kammun_app/features/loading_feature/presentation/redux/loading_state.dart';

import '../core/core_importer.dart';
import '../features/admins/presentation/redux/admins_state.dart';
import '../features/complaints/presentation/redux/complaints_state.dart';
import '../features/error/presentation/redux/error_state.dart';
import '../features/inventory_feature/presentation/redux/inventory_state.dart';
import '../features/supplier/presentation/redux/supplier_state.dart';

@immutable
class AppState extends Equatable {
  final AdminsState adminsState;
  final ComplaintsState complaintsState;
  final ErrorState errorState;
  final InventoryState inventoryState;
  final LoadingState loadingState;
  final SupplierState supplierState;
  const AppState({
    this.inventoryState,
    this.errorState,
    this.loadingState,
    this.supplierState,
    this.complaintsState,
    this.adminsState,
  });

  factory AppState.initial() => AppState(
        inventoryState: InventoryState.initial(),
        errorState: ErrorState.initial(),
        loadingState: LoadingState.initial(),
        supplierState: SupplierState.initial(),
        complaintsState: ComplaintsState.initial(),
        adminsState: AdminsState.initial(),
      );

  AppState copyWith({
    InventoryState inventoryState,
    ErrorState errorState,
    LoadingState loadingState,
    SupplierState supplierState,
    ComplaintsState complaintsState,
    AdminsState adminsState,
  }) {
    return AppState(
      inventoryState: inventoryState ?? this.inventoryState,
      errorState: errorState ?? this.errorState,
      loadingState: loadingState ?? this.loadingState,
      supplierState: supplierState ?? this.supplierState,
      complaintsState: complaintsState ?? this.complaintsState,
      adminsState: adminsState ?? this.adminsState,
    );
  }

  @override
  List<Object> get props => [inventoryState, errorState, loadingState, supplierState, complaintsState, adminsState];
}
