import 'dart:convert';

import 'start_model_importer.dart';

//OrdersOriginalData
StartModel startModelFromJson(String str) =>
    StartModel.fromJson(json.decode(str));

String startModelToJson(StartModel data) => json.encode(data.toJson());

class StartModel {
  StartModel(
      {this.success,
      this.mobileAppConfigs,
      this.company,
      this.supportedCity,
      this.user,
      this.orders,
      this.category,
      this.banner,
      this.deliveryMethod});

  bool success;
  MobileAppConfigs mobileAppConfigs;
  Company company;
  SupportedCity supportedCity;
  User user;
  Orders orders;
  Category category;
  Banner banner;
  DeliveryMethod deliveryMethod;

  factory StartModel.fromJson(Map<String, dynamic> json) => StartModel(
        success: json["success"],
        mobileAppConfigs: MobileAppConfigs.fromJson(json["mobile_app_configs"]),
        company: Company.fromJson(json["company"]),
        supportedCity: SupportedCity.fromJson(json["supported_city"]),
        user: User.fromJson(json["user"]),
        orders: Orders.fromJson(json["orders"]),
        category: Category.fromJson(json["category"]),
        deliveryMethod: DeliveryMethod.fromJson(json["delivery_method"]),
        banner: Banner.fromJson(json["banner"]),
      );

  Map<String, dynamic> toJson() => {
        "success": success,
        "mobile_app_configs": mobileAppConfigs.toJson(),
        "company": company.toJson(),
        "supported_city": supportedCity.toJson(),
        "user": user.toJson(),
        "orders": orders.toJson(),
        "category": category.toJson(),
        "banner": banner.toJson(),
        "delivery_method": deliveryMethod.toJson()
      };
}
