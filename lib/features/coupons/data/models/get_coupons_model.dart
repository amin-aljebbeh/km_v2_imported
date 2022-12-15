import '../../../../core/core_importer.dart';
import '../../domain/entities/coupons_pagination_entity.dart';
import '../../domain/entities/get_coupons_response_entity.dart';
import 'coupon_model.dart';

GetCouponsResponseModel couponsModelFromJson(String str) => GetCouponsResponseModel.fromJson(json.decode(str));

String couponsModelToJson(GetCouponsResponseModel data) => json.encode(data.toJson());

class GetCouponsResponseModel extends GetCouponsResponseEntity {
  const GetCouponsResponseModel({success, data}) : super(success: success, data: data);

  factory GetCouponsResponseModel.fromJson(Map<String, dynamic> json) =>
      GetCouponsResponseModel(success: json['success'], data: CouponsPaginationModel.fromJson(json['data']));

  Map<String, dynamic> toJson() => {'success': success, 'data': (data as CouponsPaginationModel).toJson()};
}

class CouponsPaginationModel extends CouponsPaginationEntity {
  const CouponsPaginationModel({
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
    total,
  }) : super(
          currentPage: currentPage,
          coupons: coupons,
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

  factory CouponsPaginationModel.fromJson(Map<String, dynamic> json) => CouponsPaginationModel(
        currentPage: json['current_page'],
        coupons: List<CouponModel>.from(json['data'].map((x) => CouponModel.fromJson(x))),
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
        "current_page": currentPage,
        "data": List<dynamic>.from(coupons.map((x) => (x as CouponModel).toJson())),
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
