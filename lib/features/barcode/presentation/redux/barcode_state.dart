import '../../../../core/core_importer.dart';

@immutable
class BarcodeState extends Equatable {
  final BarcodeRequestType barcodeRequestType;
  final String barcodeString;
  final Function(String) onIgnore;

  const BarcodeState({this.barcodeRequestType, this.barcodeString, this.onIgnore});

  factory BarcodeState.initial() {
    return const BarcodeState(barcodeString: 'null');
  }

  BarcodeState copyWith({BarcodeRequestType barcodeRequestType, String barcodeString, Function(String) onIgnore}) {
    return BarcodeState(
      barcodeRequestType: barcodeRequestType ?? this.barcodeRequestType,
      barcodeString: barcodeString ?? this.barcodeString,
      onIgnore: onIgnore ?? this.onIgnore,
    );
  }

  @override
  List<Object> get props => [barcodeRequestType, barcodeString, onIgnore];
}
