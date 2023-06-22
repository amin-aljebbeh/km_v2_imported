import '../../../../core/core_importer.dart';
import '../../domain/use_cases/barcode_use_cases.dart';

@immutable
class BarcodeState extends Equatable {
  final BarcodeUseCases barcodeUseCases;
  final BarcodeRequestType barcodeRequestType;
  final String barcodeString;
  final Function(String) onIgnore;

  const BarcodeState({this.barcodeRequestType, this.barcodeString, this.onIgnore, this.barcodeUseCases});

  factory BarcodeState.initial() {
    return BarcodeState(barcodeString: 'null', barcodeUseCases: sl<BarcodeUseCases>());
  }

  BarcodeState copyWith({BarcodeRequestType barcodeRequestType, String barcodeString, Function(String) onIgnore}) {
    return BarcodeState(
      barcodeUseCases: barcodeUseCases,
      barcodeRequestType: barcodeRequestType ?? this.barcodeRequestType,
      barcodeString: barcodeString ?? this.barcodeString,
      onIgnore: onIgnore ?? this.onIgnore,
    );
  }

  @override
  List<Object> get props => [barcodeRequestType, barcodeString, onIgnore, barcodeUseCases];
}
