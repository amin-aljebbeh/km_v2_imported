import '../../../core/core_importer.dart';

StartModel startModelFromJson(String str) => StartModel.fromJson(json.decode(str));

String startModelToJson(StartModel data) => json.encode(data.toJson());

class StartModel {
  StartModel({
    this.success,
    this.mobileAppConfigs,
    this.company,
    this.supportedCities,
    this.user,
    this.userFavorites,
    this.orderUnderUpdate,
    this.warehouses,
    this.specialProduct,
    this.categories,
    this.banners,
    this.subWarehouse,
  });

  bool success;
  MobileAppConfigs mobileAppConfigs;
  Company company;
  List<SupportedCityModel> supportedCities;
  List<StartModelWarehouse> warehouses;
  User user;
  List<UserFavorite> userFavorites;
  OrdersOriginalData orderUnderUpdate;
  List<CategoryModel> categories;
  List<BannerModel> banners;
  List<KeyValueModel> specialProduct;
  List<SubWarehouse> subWarehouse;

  factory StartModel.fromJson(Map<String, dynamic> json) => StartModel(
        success: json['success'],
        mobileAppConfigs: MobileAppConfigs.fromJson(json['mobile_app_configs']),
        company: Company.fromJson(json['company']),
        supportedCities: json['supported_city'] != null
            ? List<SupportedCityModel>.from(json['supported_city'].map((x) => SupportedCityModel.fromJson(x)))
            : null,
        user: User.fromJson(json['user']),
        userFavorites: List<UserFavorite>.from(json['user_favorite'].map((x) => UserFavorite.fromJson(x))),
        orderUnderUpdate:
            json['order_under_update'] != null ? OrdersOriginalData.fromJson(json['order_under_update']) : null,
        categories: List<CategoryModel>.from(json['category'].map((x) => CategoryModel.fromJson(x))),
        banners: List<BannerModel>.from(json['banner'].map((x) => BannerModel.fromJson(x))),
        subWarehouse: List<SubWarehouse>.from(json['sub_warehouse'].map((x) => SubWarehouse.fromJson(x))),
        specialProduct: List<KeyValueModel>.from(json['special_product'].map((x) => KeyValueModel.fromJson(x))),
        warehouses: List<StartModelWarehouse>.from(json['warehouses'].map((x) => StartModelWarehouse.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        'success': success,
        'mobile_app_configs': mobileAppConfigs.toJson(),
        'company': company.toJson(),
        'supported_city': List<dynamic>.from(supportedCities.map((x) => x.toJson())),
        'user': user.toJson(),
        'user_favorite': List<dynamic>.from(userFavorites.map((x) => x.toJson())),
        'order_under_update': orderUnderUpdate,
        'category': List<dynamic>.from(categories.map((x) => x.toJson())),
        'banner': List<dynamic>.from(banners.map((x) => x.toJson())),
        'sub_warehouse': List<dynamic>.from(subWarehouse.map((x) => x.toJson())),
      };
}

class BannerModel {
  BannerModel({this.id, this.title, this.description, this.imageFileName, this.expirationDate, this.warehouseId});

  int id;
  String title;
  String description;
  String imageFileName;
  DateTime expirationDate;
  int warehouseId;

  factory BannerModel.fromJson(Map<String, dynamic> json) => BannerModel(
        id: json['id'],
        title: json['title'],
        description: json['description'],
        imageFileName: json['image_file_name'],
        expirationDate: DateTime.parse(json['expiration_date']),
        warehouseId: json['warehouse_id'],
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'description': description,
        'image_file_name': imageFileName,
        'expiration_date': expirationDate.toIso8601String(),
        'warehouse_id': warehouseId,
      };
}

class UserFavorite {
  UserFavorite({this.productId});

  int productId;

  factory UserFavorite.fromJson(Map<String, dynamic> json) => UserFavorite(
        productId: json['product_id'],
      );

  Map<String, dynamic> toJson() => {'product_id': productId};
}

class SubWarehouse {
  SubWarehouse({this.id, this.displayName});

  int id;
  String displayName;

  factory SubWarehouse.fromJson(Map<String, dynamic> json) => SubWarehouse(
        id: json['id'],
        displayName: json['display_name'] ?? 'null',
      );

  Map<String, dynamic> toJson() => {'id': id, 'display_name': displayName};
}
