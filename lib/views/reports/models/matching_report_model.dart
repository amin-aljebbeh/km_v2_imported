// To parse this JSON data, do
//
//     final matchingProducts = matchingProductsFromJson(jsonString);

import 'dart:convert';

MatchingProducts matchingProductsFromJson(String str) =>
    MatchingProducts.fromJson(json.decode(str));

String matchingProductsToJson(MatchingProducts data) =>
    json.encode(data.toJson());

class MatchingProducts {
  MatchingProducts({
    this.success,
    this.productsThatVaryInQuantity,
    this.countProductsThatVaryInQuantity,
    this.productsNotIncludedInReport,
    this.countProductsNotIncludedInReport,
    this.productsNotIncludedInKammun,
    this.countProductsNotIncludedInKammun,
  });

  bool success;
  List<ProductsThatVaryInQuantity> productsThatVaryInQuantity;
  int countProductsThatVaryInQuantity;
  List<ProductsNotIncludedInReport> productsNotIncludedInReport;
  int countProductsNotIncludedInReport;
  List<ProductsNotIncludedInKammun> productsNotIncludedInKammun;
  int countProductsNotIncludedInKammun;

  factory MatchingProducts.fromJson(Map<String, dynamic> json) =>
      MatchingProducts(
        success: json["success"],
        productsThatVaryInQuantity: List<ProductsThatVaryInQuantity>.from(
            json["products_that_vary_in_quantity"]
                .map((x) => ProductsThatVaryInQuantity.fromJson(x))),
        countProductsThatVaryInQuantity:
            json["count_products_that_vary_in_quantity"],
        productsNotIncludedInReport: List<ProductsNotIncludedInReport>.from(
            json["products_not_included_in_report"]
                .map((x) => ProductsNotIncludedInReport.fromJson(x))),
        countProductsNotIncludedInReport:
            json["count_products_not_included_in_report"],
        productsNotIncludedInKammun: List<ProductsNotIncludedInKammun>.from(
            json["products_not_included_in_kammun"]
                .map((x) => ProductsNotIncludedInKammun.fromJson(x))),
        countProductsNotIncludedInKammun:
            json["count_products_not_included_in_kammun"],
      );

  Map<String, dynamic> toJson() => {
        "success": success,
        "products_that_vary_in_quantity": List<dynamic>.from(
            productsThatVaryInQuantity.map((x) => x.toJson())),
        "count_products_that_vary_in_quantity": countProductsThatVaryInQuantity,
        "products_not_included_in_report": List<dynamic>.from(
            productsNotIncludedInReport.map((x) => x.toJson())),
        "count_products_not_included_in_report":
            countProductsNotIncludedInReport,
        "products_not_included_in_kammun": List<dynamic>.from(
            productsNotIncludedInKammun.map((x) => x.toJson())),
        "count_products_not_included_in_kammun":
            countProductsNotIncludedInKammun,
      };
}

class ProductsNotIncludedInKammun {
  ProductsNotIncludedInKammun({
    this.supplierCode,
    this.soaQuantity,
    this.soaTotalPrice,
    this.soaNameProducts,
    this.soaUnitProducts,
  });

  String supplierCode;
  double soaQuantity;
  String soaTotalPrice;
  String soaNameProducts;
  String soaUnitProducts;

  factory ProductsNotIncludedInKammun.fromJson(Map<String, dynamic> json) =>
      ProductsNotIncludedInKammun(
        supplierCode: json["supplier_code"],
        soaQuantity: json["soa_quantity"].toDouble(),
        soaTotalPrice: json["soa_total_price"],
        soaNameProducts: json["soa_name_products"],
        soaUnitProducts: json["soa_unit_products"],
      );

  Map<String, dynamic> toJson() => {
        "supplier_code": supplierCode,
        "soa_quantity": soaQuantity,
        "soa_total_price": soaTotalPrice,
        "soa_name_products": soaNameProducts,
        "soa_unit_products": soaUnitProducts,
      };
}

class ProductsNotIncludedInReport {
  ProductsNotIncludedInReport({
    this.supplierCode,
    this.kammunQuantity,
    this.kammunTotalPrice,
    this.kammunNameProducts,
    this.kammunUnitProducts,
  });

  String supplierCode;
  String kammunQuantity;
  String kammunTotalPrice;
  String kammunNameProducts;
  String kammunUnitProducts;

  factory ProductsNotIncludedInReport.fromJson(Map<String, dynamic> json) =>
      ProductsNotIncludedInReport(
        supplierCode: json["supplier_code"],
        kammunQuantity: json["kammun_quantity"],
        kammunTotalPrice: json["kammun_total_price"],
        kammunNameProducts: json["kammun_name_products"],
        kammunUnitProducts: json["kammun_unit_products"],
      );

  Map<String, dynamic> toJson() => {
        "supplier_code": supplierCode,
        "kammun_quantity": kammunQuantity,
        "kammun_total_price": kammunTotalPrice,
        "kammun_name_products": kammunNameProducts,
        "kammun_unit_products": kammunUnitProducts,
      };
}

class ProductsThatVaryInQuantity {
  ProductsThatVaryInQuantity({
    this.supplierCode,
    this.kammunQuantity,
    this.kammunTotalPrice,
    this.kammunNameProducts,
    this.kammunUnitProducts,
    this.soaQuantity,
    this.soaTotalPrice,
    this.soaNameProducts,
    this.soaUnitProducts,
    this.subtractQuantity,
    this.subtractTotalPrice,
  });

  String supplierCode;
  String kammunQuantity;
  String kammunTotalPrice;
  String kammunNameProducts;
  String kammunUnitProducts;
  double soaQuantity;
  String soaTotalPrice;
  String soaNameProducts;
  String soaUnitProducts;
  double subtractQuantity;
  String subtractTotalPrice;

  factory ProductsThatVaryInQuantity.fromJson(Map<String, dynamic> json) =>
      ProductsThatVaryInQuantity(
        supplierCode: json["supplier_code"],
        kammunQuantity: json["kammun_quantity"],
        kammunTotalPrice: json["kammun_total_price"],
        kammunNameProducts: json["kammun_name_products"],
        kammunUnitProducts: json["kammun_unit_products"],
        soaQuantity: json["soa_quantity"].toDouble(),
        soaTotalPrice: json["soa_total_price"],
        soaNameProducts: json["soa_name_products"],
        soaUnitProducts: json["soa_unit_products"],
        subtractQuantity: json["subtract_quantity"].toDouble(),
        subtractTotalPrice: json["subtract_total_price"],
      );

  Map<String, dynamic> toJson() => {
        "supplier_code": supplierCode,
        "kammun_quantity": kammunQuantity,
        "kammun_total_price": kammunTotalPrice,
        "kammun_name_products": kammunNameProducts,
        "kammun_unit_products": kammunUnitProducts,
        "soa_quantity": soaQuantity,
        "soa_total_price": soaTotalPrice,
        "soa_name_products": soaNameProducts,
        "soa_unit_products": soaUnitProducts,
        "subtract_quantity": subtractQuantity,
        "subtract_total_price": subtractTotalPrice,
      };
}
