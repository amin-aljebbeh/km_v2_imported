import 'invoice_product_entity.dart';

class SubmitOrderEntity {
  final int purchasePrices;
  final int useWallet;
  final int saveRefund;
  final String userNote;
  final List<InvoiceProductEntity> products;
  int checkChangedPriceProduct;

  SubmitOrderEntity({
    this.purchasePrices,
    this.useWallet,
    this.saveRefund,
    this.userNote,
    this.products,
    this.checkChangedPriceProduct,
  });
}
