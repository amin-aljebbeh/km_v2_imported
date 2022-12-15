import 'package:kammun_app/core/core_importer.dart';
import 'package:kammun_app/features/coupons/domain/entities/coupon_entity.dart';

class CouponsPaginationEntity extends Equatable {
  final int currentPage;
  final List<CouponEntity> coupons;
  final String firstPageUrl;
  final int from;
  final int lastPage;
  final String lastPageUrl;
  final String nextPageUrl;
  final String path;
  final int perPage;
  final String prevPageUrl;
  final int to;
  final int total;

  const CouponsPaginationEntity({
    this.currentPage,
    this.coupons,
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
  @override
  List<Object> get props => [
        currentPage,
        coupons,
        firstPageUrl,
        from,
        lastPage,
        lastPageUrl,
        nextPageUrl,
        path,
        perPage,
        prevPageUrl,
        to,
        total
      ];
}
