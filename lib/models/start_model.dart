import 'models_importer.dart';

StartModel startModelFromJson(String str) => StartModel.fromJson(json.decode(str));

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
  StartDeliveryMethod deliveryMethod;

  factory StartModel.fromJson(Map<String, dynamic> json) => StartModel(
        success: json["success"],
        mobileAppConfigs: MobileAppConfigs.fromJson(json["mobile_app_configs"]),
        company: Company.fromJson(json["company"]),
        supportedCity: SupportedCity.fromJson(json["supported_city"]),
        user: User.fromJson(json["user"]),
        orders: Orders.fromJson(json["orders"]),
        category: Category.fromJson(json["category"]),
        deliveryMethod: StartDeliveryMethod.fromJson(json["delivery_method"]),
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

class Banner {
  Banner({
    this.headers,
    this.original,
    this.exception,
  });

  Headers headers;
  BannerOriginal original;
  dynamic exception;

  factory Banner.fromJson(Map<String, dynamic> json) => Banner(
        headers: Headers.fromJson(json["headers"]),
        original: BannerOriginal.fromJson(json["original"]),
        exception: json["exception"],
      );

  Map<String, dynamic> toJson() => {
        "headers": headers.toJson(),
        "original": original.toJson(),
        "exception": exception,
      };
}

class BannerOriginal {
  BannerOriginal({
    this.success,
    this.data,
  });

  bool success;
  List<PurpleDatum> data;

  factory BannerOriginal.fromJson(Map<String, dynamic> json) => BannerOriginal(
        success: json["success"],
        data: List<PurpleDatum>.from(json["data"].map((x) => PurpleDatum.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "success": success,
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
      };
}

class PurpleDatum {
  PurpleDatum({
    this.id,
    this.title,
    this.description,
    this.imageFileName,
    this.expirationDate,
    this.warehouseId,
  });

  int id;
  String title;
  String description;
  String imageFileName;
  DateTime expirationDate;
  String warehouseId;

  factory PurpleDatum.fromJson(Map<String, dynamic> json) => PurpleDatum(
        id: json["id"],
        title: json["title"],
        description: json["description"],
        imageFileName: json["image_file_name"],
        expirationDate: DateTime.parse(json["expiration_date"]),
        warehouseId: json["warehouse_id"].toString(),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "title": title,
        "description": description,
        "image_file_name": imageFileName,
        "expiration_date": expirationDate.toIso8601String(),
        "warehouse_id": warehouseId,
      };
}
