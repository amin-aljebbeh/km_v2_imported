import 'package:kammun_app/core/core_importer.dart';
import 'package:kammun_app/features/barcode/domain/use_cases/delete_barcode_use_case.dart';

import 'set_barcode_to_product_use_case.dart';

class BarcodeUseCases {
  final SetBarcodeToProductUseCase setBarcodeToProductUseCase;
  final DeleteBarcodeUseCase deleteBarcodeUseCase;

  BarcodeUseCases({@required this.setBarcodeToProductUseCase, @required this.deleteBarcodeUseCase})
      : assert(
            setBarcodeToProductUseCase != null && deleteBarcodeUseCase != null, 'All use cases should be initialized.');
}
