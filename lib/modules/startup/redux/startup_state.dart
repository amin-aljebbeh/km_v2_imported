import 'package:meta/meta.dart';
import 'package:kammun_app/modules/home_page/view/store_view.dart';
import '../models/startup_models_importer.dart';

@immutable
class StartupState {
  final bool informationFetched;
  final bool requestSent;
  final bool serverMaintain;
  final StartModel startModel;
  final String message;
  final String startingRout;

  const StartupState({
    this.startingRout,
    this.message,
    this.startModel,
    this.informationFetched,
    this.serverMaintain,
    this.requestSent,
  });

  factory StartupState.initial() {
    return StartupState(
      informationFetched: false,
      startModel: null,
      serverMaintain: false,
      message: '',
      startingRout: StoreView.routeName,
      requestSent: false,
    );
  }

  StartupState copyWith(
      {bool informationFetched,
      StartModel startModel,
      bool serverMaintain,
      String message,
      String startingRout,
      bool requestSent}) {
    return StartupState(
      informationFetched: informationFetched ?? this.informationFetched,
      startModel: startModel ?? this.startModel,
      serverMaintain: serverMaintain ?? this.serverMaintain,
      message: message ?? this.message,
      startingRout: startingRout ?? this.startingRout,
      requestSent: requestSent ?? this.requestSent,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is StartupState &&
          runtimeType == other.runtimeType &&
          informationFetched == other.informationFetched &&
          startModel == other.startModel &&
          serverMaintain == other.serverMaintain &&
          message == other.message &&
          startingRout == other.startingRout &&
          requestSent == other.requestSent;

  @override
  int get hashCode => super.hashCode;
}
