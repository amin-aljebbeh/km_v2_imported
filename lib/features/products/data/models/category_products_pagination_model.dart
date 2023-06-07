import '../../domain/entities/category_products_pagination_entity.dart';
import 'product_model.dart';

class CategoryProductsPaginationModel extends CategoryProductsPaginationEntity {
  CategoryProductsPaginationModel({
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

  factory CategoryProductsPaginationModel.fromJson(Map<String, dynamic> json) => CategoryProductsPaginationModel(
        currentPage: json['current_page'],
        products: List<ProductModel>.from(json['data'].map((x) => x == null ? null : ProductModel.fromJson(x))),
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
}
