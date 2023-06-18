import 'package:kammun_app/features/products_filter/domain/entities/products_pagination_entity.dart';

import '../../../../core/core_importer.dart';
import '../../../products/data/models/product_model.dart';

ProductsPaginationModel productsPaginationModelFromJson(String str) =>
    ProductsPaginationModel.fromJson(json.decode(str));

class ProductsPaginationModel extends ProductsPaginationEntity {
  ProductsPaginationModel({success, page}) : super(page: page, success: success);

  factory ProductsPaginationModel.fromJson(Map<String, dynamic> json) =>
      ProductsPaginationModel(success: json['success'], page: ProductsPageModel.fromJson(json['data']));
}

class ProductsPageModel extends ProductsPageEntity {
  ProductsPageModel({
    currentPage,
    products,
    firstPageUrl,
    from,
    lastPage,
    lastPageUrl,
    nextPageUrl,
    path,
    perPage,
    prevPageUrl,
    to,
    total,
  }) : super(
          currentPage: currentPage,
          products: products,
          firstPageUrl: firstPageUrl,
          from: from,
          lastPage: lastPage,
          lastPageUrl: lastPageUrl,
          nextPageUrl: nextPageUrl,
          path: path,
          perPage: perPage,
          prevPageUrl: prevPageUrl,
          to: to,
          total: total,
        );

  factory ProductsPageModel.fromJson(Map<String, dynamic> json) => ProductsPageModel(
        currentPage: json['current_page'],
        products: List<ProductModel>.from(json['data'].map((x) => ProductModel.fromJson(x))),
        firstPageUrl: json['first_page_url'],
        from: json['from'],
        lastPage: json['last_page'],
        lastPageUrl: json['last_page_url'],
        nextPageUrl: json['next_page_url'],
        path: json['path'],
        perPage: json['per_page'],
        prevPageUrl: json['prev_page_url'],
        to: json['to'],
        total: json['total'],
      );

  Map<String, dynamic> toJson() => {
        'current_page': currentPage,
        'first_page_url': firstPageUrl,
        'from': from,
        'last_page': lastPage,
        'last_page_url': lastPageUrl,
        'next_page_url': nextPageUrl,
        'path': path,
        'per_page': perPage,
        'prev_page_url': prevPageUrl,
        'to': to,
        'total': total,
      };
}
