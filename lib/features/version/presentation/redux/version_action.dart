import 'package:dartz/dartz.dart';
import 'package:package_info_plus/package_info_plus.dart';

import '../../../../core/core_importer.dart';
import '../../../update_screen/pages/update_required_screen.dart';

abstract class VersionAction {
  handle({@required Store<AppState> store});
}

class CheckVersion implements VersionAction {
  final BuildContext context;

  CheckVersion({this.context});

  @override
  handle({Store<AppState> store}) async {
    store.dispatch(StartLoading());
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    Either either = await store.state.versionState.versionUseCases
        .checkVersionUseCase(platform: Platform.isAndroid ? 'android' : 'ios', appVersion: packageInfo.version);
    either.fold((failure) {
      if (failure is UpdateRequiredFailure) {
        Navigator.of(context).pushNamedAndRemoveUntil(UpdateScreen.routeName, (Route<dynamic> route) => false);
      }
    }, (_) {});
    store.dispatch(StopLoading());
  }
}

class SetVersionStatus {
  final bool versionStatus;

  SetVersionStatus({this.versionStatus});
}
