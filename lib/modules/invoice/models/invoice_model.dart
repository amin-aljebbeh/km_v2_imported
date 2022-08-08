import 'dart:convert';

InvoiceModel invoiceFromJson(String str) => InvoiceModel.fromJson(json.decode(str));

String invoiceToJson(InvoiceModel data) => json.encode(data.toJson());

class InvoiceModel {
  InvoiceModel({
    this.tax,
    this.extraFees,
    this.couponDiscount,
    this.walletDiscount,
    this.ePaymentValue,
    this.cachValue,
    this.totalCost,
    this.totalProductCost,
    this.totalDeliveryCost,
  });

  String tax;
  String extraFees;
  String couponDiscount;
  String walletDiscount;
  String ePaymentValue;
  String cachValue;
  String totalCost;
  String totalProductCost;
  String totalDeliveryCost;

  InvoiceModel copyWith({
    String tax,
    String extraFees,
    String couponDiscount,
    String walletDiscount,
    String ePaymentValue,
    String cachValue,
    String totalCost,
    String totalProductCost,
    String totalDeliveryCost,
  }) {
    return InvoiceModel(
      cachValue: cachValue ?? this.cachValue,
      couponDiscount: couponDiscount ?? this.couponDiscount,
      ePaymentValue: ePaymentValue ?? this.ePaymentValue,
      extraFees: extraFees ?? this.extraFees,
      tax: tax ?? this.tax,
      totalCost: totalCost ?? this.totalCost,
      totalProductCost: totalProductCost ?? this.totalProductCost,
      totalDeliveryCost: totalDeliveryCost ?? this.totalDeliveryCost,
      walletDiscount: walletDiscount ?? this.walletDiscount,
    );
  }

  factory InvoiceModel.fromJson(Map<String, dynamic> json) => InvoiceModel(
        tax: json['tax'].toString(),
        extraFees: json['extra_fees'].toString(),
        couponDiscount: json['coupon_discount'].toString(),
        walletDiscount: json['wallet_discount'].toString(),
        ePaymentValue: json['e_payment_value'].toString(),
        cachValue: json['cach_value'].toString(),
        totalCost: json['total_cost'].toString(),
        totalProductCost: json['total_product_cost'].toString(),
        totalDeliveryCost: json['total_delivery_cost'].toString(),
      );

  Map<String, dynamic> toJson() => {
        'tax': tax,
        'extra_fees': extraFees,
        'coupon_discount': couponDiscount,
        'wallet_discount': walletDiscount,
        'e_payment_value': ePaymentValue,
        'cach_value': cachValue,
        'total_cost': totalCost,
        'total_product_cost': totalProductCost,
        'total_delivery_cost': totalDeliveryCost,
      };
}
