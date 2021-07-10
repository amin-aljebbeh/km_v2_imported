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
        success: json["success"] == null ? null : json["success"],
        productsThatVaryInQuantity:
            json["products_that_vary_in_quantity"] == null
                ? null
                : List<ProductsThatVaryInQuantity>.from(
                    json["products_that_vary_in_quantity"]
                        .map((x) => ProductsThatVaryInQuantity.fromJson(x))),
        countProductsThatVaryInQuantity:
            json["count_products_that_vary_in_quantity"] == null
                ? null
                : json["count_products_that_vary_in_quantity"],
        productsNotIncludedInReport:
            json["products_not_included_in_report"] == null
                ? null
                : List<ProductsNotIncludedInReport>.from(
                    json["products_not_included_in_report"]
                        .map((x) => ProductsNotIncludedInReport.fromJson(x))),
        countProductsNotIncludedInReport:
            json["count_products_not_included_in_report"] == null
                ? null
                : json["count_products_not_included_in_report"],
        productsNotIncludedInKammun:
            json["products_not_included_in_kammun"] == null
                ? null
                : List<ProductsNotIncludedInKammun>.from(
                    json["products_not_included_in_kammun"]
                        .map((x) => ProductsNotIncludedInKammun.fromJson(x))),
        countProductsNotIncludedInKammun:
            json["count_products_not_included_in_kammun"] == null
                ? null
                : json["count_products_not_included_in_kammun"],
      );

  Map<String, dynamic> toJson() => {
        "success": success == null ? null : success,
        "products_that_vary_in_quantity": productsThatVaryInQuantity == null
            ? null
            : List<dynamic>.from(
                productsThatVaryInQuantity.map((x) => x.toJson())),
        "count_products_that_vary_in_quantity":
            countProductsThatVaryInQuantity == null
                ? null
                : countProductsThatVaryInQuantity,
        "products_not_included_in_report": productsNotIncludedInReport == null
            ? null
            : List<dynamic>.from(
                productsNotIncludedInReport.map((x) => x.toJson())),
        "count_products_not_included_in_report":
            countProductsNotIncludedInReport == null
                ? null
                : countProductsNotIncludedInReport,
        "products_not_included_in_kammun": productsNotIncludedInKammun == null
            ? null
            : List<dynamic>.from(
                productsNotIncludedInKammun.map((x) => x.toJson())),
        "count_products_not_included_in_kammun":
            countProductsNotIncludedInKammun == null
                ? null
                : countProductsNotIncludedInKammun,
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
        supplierCode:
            json["supplier_code"] == null ? null : json["supplier_code"],
        soaQuantity: json["soa_quantity"] == null
            ? null
            : json["soa_quantity"].toDouble(),
        soaTotalPrice:
            json["soa_total_price"] == null ? null : json["soa_total_price"],
        soaNameProducts: json["soa_name_products"] == null
            ? null
            : json["soa_name_products"],
        soaUnitProducts: json["soa_unit_products"] == null
            ? null
            : json["soa_unit_products"],
      );

  Map<String, dynamic> toJson() => {
        "supplier_code": supplierCode == null ? null : supplierCode,
        "soa_quantity": soaQuantity == null ? null : soaQuantity,
        "soa_total_price": soaTotalPrice == null ? null : soaTotalPrice,
        "soa_name_products": soaNameProducts == null ? null : soaNameProducts,
        "soa_unit_products": soaUnitProducts == null ? null : soaUnitProducts,
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
        supplierCode:
            json["supplier_code"] == null ? null : json["supplier_code"],
        kammunQuantity:
            json["kammun_quantity"] == null ? null : json["kammun_quantity"],
        kammunTotalPrice: json["kammun_total_price"] == null
            ? null
            : json["kammun_total_price"],
        kammunNameProducts: json["kammun_name_products"] == null
            ? null
            : json["kammun_name_products"],
        kammunUnitProducts: json["kammun_unit_products"] == null
            ? null
            : json["kammun_unit_products"],
      );

  Map<String, dynamic> toJson() => {
        "supplier_code": supplierCode == null ? null : supplierCode,
        "kammun_quantity": kammunQuantity == null ? null : kammunQuantity,
        "kammun_total_price":
            kammunTotalPrice == null ? null : kammunTotalPrice,
        "kammun_name_products":
            kammunNameProducts == null ? null : kammunNameProducts,
        "kammun_unit_products":
            kammunUnitProducts == null ? null : kammunUnitProducts,
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
        supplierCode:
            json["supplier_code"] == null ? null : json["supplier_code"],
        kammunQuantity:
            json["kammun_quantity"] == null ? null : json["kammun_quantity"],
        kammunTotalPrice: json["kammun_total_price"] == null
            ? null
            : json["kammun_total_price"],
        kammunNameProducts: json["kammun_name_products"] == null
            ? null
            : json["kammun_name_products"],
        kammunUnitProducts: json["kammun_unit_products"] == null
            ? null
            : json["kammun_unit_products"],
        soaQuantity: json["soa_quantity"] == null
            ? null
            : json["soa_quantity"].toDouble(),
        soaTotalPrice:
            json["soa_total_price"] == null ? null : json["soa_total_price"],
        soaNameProducts: json["soa_name_products"] == null
            ? null
            : json["soa_name_products"],
        soaUnitProducts: json["soa_unit_products"] == null
            ? null
            : json["soa_unit_products"],
        subtractQuantity: json["subtract_quantity"] == null
            ? null
            : json["subtract_quantity"].toDouble(),
        subtractTotalPrice: json["subtract_total_price"] == null
            ? null
            : json["subtract_total_price"],
      );

  Map<String, dynamic> toJson() => {
        "supplier_code": supplierCode == null ? null : supplierCode,
        "kammun_quantity": kammunQuantity == null ? null : kammunQuantity,
        "kammun_total_price":
            kammunTotalPrice == null ? null : kammunTotalPrice,
        "kammun_name_products":
            kammunNameProducts == null ? null : kammunNameProducts,
        "kammun_unit_products":
            kammunUnitProducts == null ? null : kammunUnitProducts,
        "soa_quantity": soaQuantity == null ? null : soaQuantity,
        "soa_total_price": soaTotalPrice == null ? null : soaTotalPrice,
        "soa_name_products": soaNameProducts == null ? null : soaNameProducts,
        "soa_unit_products": soaUnitProducts == null ? null : soaUnitProducts,
        "subtract_quantity": subtractQuantity == null ? null : subtractQuantity,
        "subtract_total_price":
            subtractTotalPrice == null ? null : subtractTotalPrice,
      };
}
