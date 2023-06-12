import '../../../../core/core_importer.dart';

abstract class BarcodeAction {
  handle({@required Store<AppState> store});
}

class SetBarcodeType {
  final BarcodeRequestType barcodeRequestType;

  SetBarcodeType({this.barcodeRequestType});
}

class SetBarcodeString {
  final String barcodeString;

  SetBarcodeString({this.barcodeString});
}

class SetonIgnore {
  final Function(String) onIgnore;

  SetonIgnore({this.onIgnore});
}
