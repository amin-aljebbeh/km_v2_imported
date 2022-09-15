import 'package:kammun_app/views/loading_feature/presentation/redux/loading_state.dart';

import '../core/core_importer.dart';
import '../views/error/presentation/redux/error_state.dart';
import '../views/inventory_feature/presentation/redux/inventory_state.dart';

@immutable
class AppState extends Equatable {
  final ErrorState errorState;
  final InventoryState inventoryState;
  final LoadingState loadingState;
  const AppState({this.inventoryState, this.errorState, this.loadingState});

  factory AppState.initial() => AppState(
      inventoryState: InventoryState.initial(), errorState: ErrorState.initial(), loadingState: LoadingState.initial());

  AppState copyWith(InventoryState inventoryState, ErrorState errorState, LoadingState loadingState) {
    return AppState(
        inventoryState: inventoryState ?? this.inventoryState,
        errorState: errorState ?? this.errorState,
        loadingState: loadingState ?? this.loadingState);
  }

  @override
  List<Object> get props => [inventoryState, errorState, loadingState];
}
