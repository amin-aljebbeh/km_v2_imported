import '../../../../core/core_importer.dart';
import 'coupon_model.dart';

GetCouponsResponseModel couponsModelFromJson(String str) => GetCouponsResponseModel.fromJson(json.decode(str));

String couponsModelToJson(GetCouponsResponseModel data) => json.encode(data.toJson());

class GetCouponsResponseModel {
  GetCouponsResponseModel({this.success, this.data});

  bool success;
  PaginationModel data;

  factory GetCouponsResponseModel.fromJson(Map<String, dynamic> json) =>
      GetCouponsResponseModel(success: json['success'], data: PaginationModel.fromJson(json['data']));

  Map<String, dynamic> toJson() => {'success': success, 'data': data.toJson()};
}

class PaginationModel {
  PaginationModel({
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

  int currentPage;
  List<CouponModel> coupons;
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

  factory PaginationModel.fromJson(Map<String, dynamic> json) => PaginationModel(
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
        "data": List<dynamic>.from(coupons.map((x) => x.toJson())),
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
