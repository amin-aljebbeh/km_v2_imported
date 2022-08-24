import 'dart:convert';

SubmitOrderModel invoiceModelFromJson(String str) => SubmitOrderModel.fromJson(json.decode(str));

String invoiceModelToJson(SubmitOrderModel data) => json.encode(data.toJson());

class SubmitOrderModel {
  SubmitOrderModel(
      {this.purchasePrices, this.useWallet = 0, this.products, this.userNote, this.checkChangedPriceProduct});

  int purchasePrices;
  int useWallet;
  String userNote;
  List<InvoiceProductModel> products;
  int checkChangedPriceProduct;

  factory SubmitOrderModel.fromJson(Map<String, dynamic> json) => SubmitOrderModel(
        purchasePrices: json['purchase_prices'],
        useWallet: json['use_wallet'],
        products: List<InvoiceProductModel>.from(json['products'].map((x) => InvoiceProductModel.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        'purchase_prices': purchasePrices,
        'use_wallet': useWallet,
        'products': List<dynamic>.from(products.map((x) => x.toJson())),
        'user_notes': userNote,
        'check_changed_price_product': checkChangedPriceProduct
      };

  SubmitOrderModel copyWith({
    String couponCode,
    int deliveryMethodId,
    int addressId,
    int supportedCityId,
    int paymentMethodId,
    int purchasePrices,
    int useWallet,
    String userNote,
    List<InvoiceProductModel> products,
  }) {
    return SubmitOrderModel(
      products: products ?? this.products,
      useWallet: useWallet ?? this.useWallet,
      purchasePrices: purchasePrices ?? this.purchasePrices,
      userNote: userNote ?? this.userNote,
    );
  }
}

class InvoiceProductModel {
  InvoiceProductModel({this.productId, this.quantity, this.price});

  int productId;
  int quantity;
  int price;

  factory InvoiceProductModel.fromJson(Map<String, dynamic> json) =>
      InvoiceProductModel(productId: json['product_id'], quantity: json['quantity'], price: json['price']);

  Map<String, dynamic> toJson() => {'product_id': productId, 'quantity': quantity, 'price': price};
}
