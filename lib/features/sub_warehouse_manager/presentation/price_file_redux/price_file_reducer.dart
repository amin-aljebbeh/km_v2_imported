import '../../../../core/core_importer.dart';
import 'price_file_action.dart';
import 'price_file_state.dart';

Reducer<PriceFileState> priceFileReducer = combineReducers<PriceFileState>([
  TypedReducer<PriceFileState, SetPriceFileProduct>(setPriceFileProduct),
  TypedReducer<PriceFileState, SetPriceSent>(setPriceSent),
  TypedReducer<PriceFileState, SetPriceSelected>(setPriceSelected),
  TypedReducer<PriceFileState, PriceLoading>(priceLoading),
  TypedReducer<PriceFileState, PriceError>(priceError),
  TypedReducer<PriceFileState, InitPriceFile>(initPriceFile),
]);

PriceFileState initPriceFile(PriceFileState state, InitPriceFile action) => PriceFileState.initial();

PriceFileState setPriceFileProduct(PriceFileState state, SetPriceFileProduct action) =>
    state.copyWith(priceFileProductEntity: action.priceFileProductEntity);

PriceFileState setPriceSent(PriceFileState state, SetPriceSent action) => state.copyWith(priceSent: action.sent);

PriceFileState setPriceSelected(PriceFileState state, SetPriceSelected action) =>
    state.copyWith(priceSelected: action.selected);

PriceFileState priceLoading(PriceFileState state, PriceLoading action) => state.copyWith(loading: action.loading);

PriceFileState priceError(PriceFileState state, PriceError action) => state.copyWith(error: action.error);
