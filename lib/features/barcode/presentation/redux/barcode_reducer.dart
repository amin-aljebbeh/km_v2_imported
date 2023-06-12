import '../../../../core/core_importer.dart';
import 'barcode_action.dart';
import 'barcode_state.dart';

Reducer<BarcodeState> barcodeReducer = combineReducers<BarcodeState>([
  TypedReducer<BarcodeState, SetBarcodeType>(setBarcodeType),
  TypedReducer<BarcodeState, SetBarcodeString>(setBarcodeString),
  TypedReducer<BarcodeState, SetonIgnore>(setonIgnore),
]);

BarcodeState setBarcodeType(BarcodeState state, SetBarcodeType action) {
  return state.copyWith(barcodeRequestType: action.barcodeRequestType);
}

BarcodeState setBarcodeString(BarcodeState state, SetBarcodeString action) {
  return state.copyWith(barcodeString: action.barcodeString);
}

BarcodeState setonIgnore(BarcodeState state, SetonIgnore action) {
  return state.copyWith(onIgnore: action.onIgnore);
}
