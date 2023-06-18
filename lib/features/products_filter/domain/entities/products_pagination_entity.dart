import 'package:kammun_app/features/products/domain/entities/product_entity.dart';

class ProductsPaginationEntity {
  ProductsPaginationEntity({this.success, this.page});

  bool success;
  ProductsPageEntity page;
}

class ProductsPageEntity {
  ProductsPageEntity({
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
  List<ProductEntity> products;
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
}
