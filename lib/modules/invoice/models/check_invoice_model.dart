import '../../order/models/submit_order_model.dart';

class CheckInvoiceModel {
  CheckInvoiceModel({
    this.deliveryMethodId,
    this.addressId,
    this.paymentMethodId,
    this.purchasePrices,
    this.useWallet,
    this.products,
    this.couponCode,
    this.supportedCityId,
  });

  int deliveryMethodId;
  int addressId;
  int supportedCityId;
  int paymentMethodId;
  int purchasePrices;
  int useWallet;
  String couponCode;
  List<InvoiceProductModel> products;

  factory CheckInvoiceModel.initial() {
    return CheckInvoiceModel(couponCode: '', useWallet: 0);
  }
  factory CheckInvoiceModel.fromJson(Map<String, dynamic> json) => CheckInvoiceModel(
        deliveryMethodId: json['delivery_method_id'],
        addressId: json['address_id'],
        paymentMethodId: json['payment_method_id'],
        purchasePrices: json['purchase_prices'],
        useWallet: json['use_wallet'],
        products: List<InvoiceProductModel>.from(json['products'].map((x) => InvoiceProductModel.fromJson(x))),
        couponCode: json['coupon_code'],
        supportedCityId: json['supported_city_id'],
      );

  Map<String, dynamic> toJson() => {
        'delivery_method_id': deliveryMethodId,
        'address_id': addressId,
        'supported_city_id': supportedCityId,
        'payment_method_id': paymentMethodId,
        'purchase_prices': purchasePrices,
        'use_wallet': useWallet,
        'coupon_code': couponCode,
        'products': List<dynamic>.from(products.map((x) => x.toJson())),
      };

  CheckInvoiceModel copyWith({
    int deliveryMethodId,
    int addressId,
    int paymentMethodId,
    int purchasePrices,
    int useWallet,
    String couponCode,
    List<InvoiceProductModel> products,
    int supportedCityId,
  }) {
    return CheckInvoiceModel(
      products: products ?? this.products,
      deliveryMethodId: deliveryMethodId ?? this.deliveryMethodId,
      useWallet: useWallet ?? this.useWallet,
      addressId: addressId ?? this.addressId,
      couponCode: couponCode ?? this.couponCode,
      paymentMethodId: paymentMethodId ?? this.paymentMethodId,
      purchasePrices: purchasePrices ?? this.purchasePrices,
      supportedCityId: supportedCityId ?? this.supportedCityId,
    );
  }
}
