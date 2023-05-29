import '../../data/models/invoice_product_model.dart';
import '../../domain/entities/submit_order_entity.dart';

class SubmitOrderModel extends SubmitOrderEntity {
  SubmitOrderModel({purchasePrices, useWallet, saveRefund, userNote, products, checkChangedPriceProduct})
      : super(
          purchasePrices: purchasePrices,
          useWallet: useWallet,
          saveRefund: saveRefund,
          userNote: userNote,
          products: products,
          checkChangedPriceProduct: checkChangedPriceProduct,
        );

  factory SubmitOrderModel.fromJson(Map<String, dynamic> json) => SubmitOrderModel(
        purchasePrices: json['purchase_prices'],
        useWallet: json['use_wallet'],
        products: List<InvoiceProductModel>.from(json['products'].map((x) => InvoiceProductModel.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        'purchase_prices': purchasePrices,
        'use_wallet': useWallet,
        'products': List<dynamic>.from(products.map((x) => (x as InvoiceProductModel).toJson())),
        'user_notes': userNote,
        'check_changed_price_product': checkChangedPriceProduct,
        'save_refund': saveRefund
      };
}
