// To parse this JSON data, do
//
//     final empty = emptyFromJson(jsonString);

import 'package:kammun_app/core/models/models_importer.dart';

import '../../products/data/models/product_model.dart';

FilteredProductsModel filteredProductsModelFromJson(String str) => FilteredProductsModel.fromJson(json.decode(str));

String filteredProductsModelToJson(FilteredProductsModel data) => json.encode(data.toJson());

class FilteredProductsModel {
  FilteredProductsModel({this.success, this.data});

  bool success;
  FilterPagination data;

  factory FilteredProductsModel.fromJson(Map<String, dynamic> json) =>
      FilteredProductsModel(success: json["success"], data: FilterPagination.fromJson(json["data"]));

  Map<String, dynamic> toJson() => {"success": success, "data": data.toJson()};
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
  List<ProductModel> products;
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
        currentPage: json["current_page"],
        products: List<ProductModel>.from(json["data"].map((x) => ProductModel.fromJson(x))),
        firstPageUrl: json["first_page_url"],
        from: json["from"],
        lastPage: json["last_page"],
        lastPageUrl: json["last_page_url"],
        nextPageUrl: json["next_page_url"],
        path: json["path"],
        perPage: json["per_page"],
        prevPageUrl: json["prev_page_url"],
        to: json["to"],
        total: json["total"],
      );

  Map<String, dynamic> toJson() => {
        "current_page": currentPage,
        "first_page_url": firstPageUrl,
        "from": from,
        "last_page": lastPage,
        "last_page_url": lastPageUrl,
        "next_page_url": nextPageUrl,
        "path": path,
        "per_page": perPage,
        "prev_page_url": prevPageUrl,
        "to": to,
        "total": total,
      };
}
