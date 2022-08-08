import 'package:kammun_app/core/core_importer.dart';

SubmitOrderModel invoiceModelFromJson(String str) => SubmitOrderModel.fromJson(json.decode(str));

String invoiceModelToJson(SubmitOrderModel data) => json.encode(data.toJson());

class SubmitOrderModel {
  SubmitOrderModel({
    this.couponCode,
    this.deliveryMethodId,
    this.addressId,
    this.supportedCityId,
    this.paymentMethodId,
    this.purchasePrices,
    this.useWallet = 0,
    this.invoice,
    this.products,
    this.userNote,
  });

  String couponCode;
  int deliveryMethodId;
  int addressId;
  int supportedCityId;
  int paymentMethodId;
  int purchasePrices;
  int useWallet;
  String userNote;
  InvoiceModel invoice;
  List<InvoiceProductModel> products;

  factory SubmitOrderModel.fromJson(Map<String, dynamic> json) => SubmitOrderModel(
        couponCode: json['coupon_code'],
        deliveryMethodId: json['delivery_method_id'],
        addressId: json['address_id'],
        supportedCityId: json['supported_city_id'],
        paymentMethodId: json['payment_method_id'],
        purchasePrices: json['purchase_prices'],
        useWallet: json['use_wallet'],
        invoice: InvoiceModel.fromJson(json['invoice']),
        products: List<InvoiceProductModel>.from(json['products'].map((x) => InvoiceProductModel.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        'coupon_code': couponCode,
        'delivery_method_id': deliveryMethodId,
        'address_id': addressId,
        'supported_city_id': supportedCityId,
        'payment_method_id': paymentMethodId,
        'purchase_prices': purchasePrices,
        'use_wallet': useWallet,
        'invoice': invoice.toJson(),
        'products': List<dynamic>.from(products.map((x) => x.toJson())),
        'user_notes': userNote,
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
    InvoiceModel invoice,
    List<InvoiceProductModel> products,
  }) {
    return SubmitOrderModel(
      products: products ?? this.products,
      deliveryMethodId: deliveryMethodId ?? this.deliveryMethodId,
      supportedCityId: supportedCityId ?? this.supportedCityId,
      useWallet: useWallet ?? this.useWallet,
      addressId: addressId ?? this.addressId,
      couponCode: couponCode ?? this.couponCode,
      invoice: invoice ?? this.invoice,
      paymentMethodId: paymentMethodId ?? this.paymentMethodId,
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

  factory InvoiceProductModel.fromJson(Map<String, dynamic> json) => InvoiceProductModel(
        productId: json['product_id'],
        quantity: json['quantity'],
        price: json['price'],
      );

  Map<String, dynamic> toJson() => {'product_id': productId, 'quantity': quantity, 'price': price};
}
