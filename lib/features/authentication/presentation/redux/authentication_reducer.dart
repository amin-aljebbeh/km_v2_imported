import 'package:kammun_app/features/authentication/presentation/redux/authentication_state.dart';

import '../../../../core/core_importer.dart';

Reducer<AuthenticationState> authenticationReducer = combineReducers<AuthenticationState>([
  // TypedReducer<AuthenticationState, SetRefund>(setRefund),
]);

//
// AuthenticationState setDeliveryPrice(AuthenticationState state, SetDeliveryPrice action) {
//   return state.copyWith(deliveryPrice: action.deliveryPrice);
// }
