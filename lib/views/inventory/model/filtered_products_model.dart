// To parse this JSON data, do
//
//     final empty = emptyFromJson(jsonString);

import 'dart:convert';

import 'package:kammun_app/models/models_importer.dart';

FilteredProductsModel filteredProductsModelFromJson(String str) =>
    FilteredProductsModel.fromJson(json.decode(str));

String filteredProductsModelToJson(FilteredProductsModel data) => json.encode(data.toJson());

class FilteredProductsModel {
  FilteredProductsModel({
    this.success,
    this.data,
  });

  bool success;
  FilterPagination data;

  factory FilteredProductsModel.fromJson(Map<String, dynamic> json) => FilteredProductsModel(
        success: json["success"] == null ? null : json["success"],
        data: json["data"] == null ? null : FilterPagination.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "success": success == null ? null : success,
        "data": data == null ? null : data.toJson(),
      };
}

class FilterPagination {
  FilterPagination({
    this.currentPage,
    this.products,
    this.firstPageUrl,
    this.from,
    this.lastPage,
    this.lastPageUrl,
    this.nextPageUrl,
    this.path,
    this.perPage,
    this.prevPageUrl,
    this.to,
    this.total,
  });

  int currentPage;
  List<ProductData> products;
  String firstPageUrl;
  int from;
  int lastPage;
  String lastPageUrl;
  String nextPageUrl;
  String path;
  int perPage;
  dynamic prevPageUrl;
  int to;
  int total;

  factory FilterPagination.fromJson(Map<String, dynamic> json) => FilterPagination(
        currentPage: json["current_page"] == null ? null : json["current_page"],
        products:
            json["data"] == null ? null : List<ProductData>.from(json["data"].map((x) => ProductData.fromJson(x))),
        firstPageUrl: json["first_page_url"] == null ? null : json["first_page_url"],
        from: json["from"] == null ? null : json["from"],
        lastPage: json["last_page"] == null ? null : json["last_page"],
        lastPageUrl: json["last_page_url"] == null ? null : json["last_page_url"],
        nextPageUrl: json["next_page_url"] == null ? null : json["next_page_url"],
        path: json["path"] == null ? null : json["path"],
        perPage: json["per_page"] == null ? null : json["per_page"],
        prevPageUrl: json["prev_page_url"],
        to: json["to"] == null ? null : json["to"],
        total: json["total"] == null ? null : json["total"],
      );

  Map<String, dynamic> toJson() => {
        "current_page": currentPage == null ? null : currentPage,
        "data": products == null ? null : List<dynamic>.from(products.map((x) => x.toJson())),
        "first_page_url": firstPageUrl == null ? null : firstPageUrl,
        "from": from == null ? null : from,
        "last_page": lastPage == null ? null : lastPage,
        "last_page_url": lastPageUrl == null ? null : lastPageUrl,
        "next_page_url": nextPageUrl == null ? null : nextPageUrl,
        "path": path == null ? null : path,
        "per_page": perPage == null ? null : perPage,
        "prev_page_url": prevPageUrl,
        "to": to == null ? null : to,
        "total": total == null ? null : total,
      };
}
