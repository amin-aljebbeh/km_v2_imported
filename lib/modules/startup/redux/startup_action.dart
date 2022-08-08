import 'package:kammun_app/modules/startup/models/startup_models_importer.dart';

class FetchStartInformation {}

class InformationFetchedSuccessfully {
  final StartModel startModel;

  InformationFetchedSuccessfully({this.startModel});
}

class ServerMaintain {
  final String message;

  ServerMaintain({this.message});
}

class SetStartingRout {
  final String startingRout;

  SetStartingRout({this.startingRout});
}

class SetBalance {
  final String balance;

  SetBalance({this.balance});
}

class RequestSent {}
