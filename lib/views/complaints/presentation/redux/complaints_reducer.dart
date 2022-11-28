import '../../../../core/core_importer.dart';
import 'complaints_action.dart';
import 'complaints_state.dart';

Reducer<ComplaintsState> complaintsReducer = combineReducers<ComplaintsState>([
  TypedReducer<ComplaintsState, SetComplaints>(setComplaints),
]);
ComplaintsState setComplaints(ComplaintsState state, SetComplaints action) {
  return state.copyWith(complaints: action.complaints);
}
