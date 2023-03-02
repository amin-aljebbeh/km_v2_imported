import 'package:kammun_app/features/coupons/data/models/coupon_model.dart';

import '../../../../core/core_importer.dart';

UserCouponsResponseModel userCouponsResponseModelFromJson(String str) =>
    UserCouponsResponseModel.fromJson(json.decode(str));

class UserCouponsResponseModel {
  UserCouponsResponseModel({
    this.success,
    this.data,
  });

  bool success;
  Data data;

  factory UserCouponsResponseModel.fromJson(Map<String, dynamic> json) =>
      UserCouponsResponseModel(success: json['success'], data: Data.fromJson(json['data']));

  Map<String, dynamic> toJson() => {'success': success, 'data': data.toJson()};
}

class Data {
  Data({this.id, this.coupons});

  int id;
  List<CouponModel> coupons;

  factory Data.fromJson(Map<String, dynamic> json) =>
      Data(id: json['id'], coupons: List<CouponModel>.from(json['coupons'].map((x) => CouponModel.fromJson(x))));

  Map<String, dynamic> toJson() => {'id': id, 'coupons': List<dynamic>.from(coupons.map((x) => x.toJson()))};
}
