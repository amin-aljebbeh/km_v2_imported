import '../../../core/core_importer.dart';
import 'startup_action.dart';
import 'startup_state.dart';

Reducer<StartupState> startupReducer = combineReducers<StartupState>([
  TypedReducer<StartupState, InformationFetchedSuccessfully>(informationFetchedSuccessfully),
  TypedReducer<StartupState, ServerMaintain>(serverMaintain),
  TypedReducer<StartupState, SetStartingRout>(setStartingRout),
  TypedReducer<StartupState, SetBalance>(setBalance),
  TypedReducer<StartupState, RequestSent>(requestSent),
]);

StartupState informationFetchedSuccessfully(StartupState state, InformationFetchedSuccessfully action) {
  return state.copyWith(startModel: action.startModel, informationFetched: true);
}

StartupState serverMaintain(StartupState state, ServerMaintain action) {
  return state.copyWith(serverMaintain: true, message: action.message);
}

StartupState setStartingRout(StartupState state, SetStartingRout action) {
  return state.copyWith(startingRout: action.startingRout);
}

StartupState requestSent(StartupState state, RequestSent action) {
  return state.copyWith(requestSent: true);
}

StartupState setBalance(StartupState state, SetBalance action) {
  StartModel startModel = state.startModel;
  startModel.user.balance = action.balance;
  return state.copyWith(startModel: startModel);
}
