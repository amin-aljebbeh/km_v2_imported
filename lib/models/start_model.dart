import 'dart:convert';

StartModel startModelFromJson(String str) =>
    StartModel.fromJson(json.decode(str));

OrdersOriginal ordersFromJson(String str) =>
    OrdersOriginal.fromJson(json.decode(str));

SupportedCityOriginal supportedCityOriginalFromJson(String str) =>
    SupportedCityOriginal.fromJson(json.decode(str));

// List<CategoryOriginalData> categoryOriginalDataFromJson(dynamic json) =>
//     List<CategoryOriginalData>.from(json.map((x) => CategoryOriginalData.fromJson(x)));

CategoryOriginal categoryOriginalFromJson(String str) =>
    CategoryOriginal.fromJson(json.decode(str));
// CategoryOriginal categoryOriginalFromJson //CategoryOriginal

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

class Headers {
  Headers();

  factory Headers.fromJson(Map<String, dynamic> json) => Headers();

  Map<String, dynamic> toJson() => {};
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
        data: List<PurpleDatum>.from(
            json["data"].map((x) => PurpleDatum.fromJson(x))),
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

class Category {
  Category({
    this.headers,
    this.original,
    this.exception,
  });

  Headers headers;
  CategoryOriginal original;
  dynamic exception;

  factory Category.fromJson(Map<String, dynamic> json) => Category(
        headers: Headers.fromJson(json["headers"]),
        original: CategoryOriginal.fromJson(json["original"]),
        exception: json["exception"],
      );

  Map<String, dynamic> toJson() => {
        "headers": headers.toJson(),
        "original": original.toJson(),
        "exception": exception,
      };
}

class CategoryOriginal {
  CategoryOriginal({
    this.success,
    this.data,
  });

  bool success;
  List<CategoryOriginalData> data;

  factory CategoryOriginal.fromJson(Map<String, dynamic> json) =>
      CategoryOriginal(
        success: json["success"],
        data: List<CategoryOriginalData>.from(
            json["data"].map((x) => CategoryOriginalData.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "success": success,
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
      };
}

class CategoryOriginalData {
  CategoryOriginalData({
    this.id,
    this.name,
    this.imageFileName,
    this.parentCategoryId,
    this.isCompany,
    this.warehouses,
  });

  int id;
  String name;
  String imageFileName;
  String parentCategoryId;
  String isCompany;
  List<Warehouse> warehouses;

  factory CategoryOriginalData.fromJson(Map<String, dynamic> json) =>
      CategoryOriginalData(
        id: json["id"],
        name: json["name"],
        imageFileName: json["image_file_name"],
        parentCategoryId: json["parent_category_id"] == null
            ? null
            : json["parent_category_id"].toString(),
        isCompany: json["is_company"].toString(),
        warehouses: List<Warehouse>.from(
            json["warehouses"].map((x) => Warehouse.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "image_file_name": imageFileName,
        "parent_category_id":
            parentCategoryId == null ? null : parentCategoryId,
        "is_company": isCompany,
        "warehouses": List<dynamic>.from(warehouses.map((x) => x.toJson())),
      };
}

class Warehouse {
  Warehouse({
    this.id,
    this.name,
    this.description,
    this.numberOfWorkers,
    this.isActive,
    this.pivot,
  });

  int id;
  String name;
  String description;
  String numberOfWorkers;
  String isActive;
  WarehousePivot pivot;

  factory Warehouse.fromJson(Map<String, dynamic> json) => Warehouse(
        id: json["id"],
        name: json["name"],
        description: json["description"],
        numberOfWorkers: json["number_of_workers"].toString(),
        isActive: json["is_active"].toString(),
        pivot: json["pivot"] == null
            ? null
            : WarehousePivot.fromJson(json["pivot"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "description": description,
        "number_of_workers": numberOfWorkers,
        "is_active": isActive,
        "pivot": pivot == null ? null : pivot.toJson(),
      };
}

class WarehousePivot {
  WarehousePivot({
    this.categoryId,
    this.warehouseId,
    this.isActive,
    this.isFeatured,
    this.priority,
    this.numberOfVisits,
    this.price,
  });

  String categoryId;
  String warehouseId;
  String isActive;
  String isFeatured;
  String priority;
  String numberOfVisits;

  String price;

  factory WarehousePivot.fromJson(Map<String, dynamic> json) => WarehousePivot(
        categoryId: json["category_id"].toString(),
        warehouseId: json["warehouse_id"].toString(),
        price: json["price"].toString(),
        isActive: json["is_active"].toString(),
        isFeatured: json["is_featured"].toString(),
        priority: json["priority"].toString(),
        numberOfVisits: json["number_of_visits"].toString(),
      );

  Map<String, dynamic> toJson() => {
        "category_id": categoryId,
        "warehouse_id": warehouseId,
        "is_active": isActive,
        "price": price,
        "is_featured": isFeatured,
        "priority": priority,
        "number_of_visits": numberOfVisits,
      };
}

class Company {
  Company({
    this.headers,
    this.original,
    this.exception,
  });

  Headers headers;
  CompanyOriginal original;
  dynamic exception;

  factory Company.fromJson(Map<String, dynamic> json) => Company(
        headers: Headers.fromJson(json["headers"]),
        original: CompanyOriginal.fromJson(json["original"]),
        exception: json["exception"],
      );

  Map<String, dynamic> toJson() => {
        "headers": headers.toJson(),
        "original": original.toJson(),
        "exception": exception,
      };
}

class CompanyOriginal {
  CompanyOriginal({
    this.success,
    this.data,
  });

  bool success;
  List<CompanyOriginalData> data;

  factory CompanyOriginal.fromJson(Map<String, dynamic> json) =>
      CompanyOriginal(
        success: json["success"],
        data: List<CompanyOriginalData>.from(
            json["data"].map((x) => CompanyOriginalData.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "success": success,
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
      };
}

class CompanyOriginalData {
  CompanyOriginalData({
    this.id,
    this.name,
    this.logoFileName,
    this.phone,
    this.email,
    this.addressId,
    this.whatsappNumber,
    this.supportNumber,
    this.facebookUrl,
    this.instagramUrl,
    this.messengerUrl,
    this.supportUrl,
    this.websiteUrl,
    this.baseUrl,
    this.imageBaseUrl,
    this.currency,
    this.additionalInfo,
  });

  int id;
  String name;
  String logoFileName;
  String phone;
  String email;
  dynamic addressId;
  String whatsappNumber;
  String supportNumber;
  String facebookUrl;
  String instagramUrl;
  String messengerUrl;
  String supportUrl;
  String websiteUrl;
  String baseUrl;
  String imageBaseUrl;
  String currency;
  String additionalInfo;

  factory CompanyOriginalData.fromJson(Map<String, dynamic> json) =>
      CompanyOriginalData(
        id: json["id"],
        name: json["name"],
        logoFileName: json["logo_file_name"],
        phone: json["phone"].toString(),
        email: json["email"],
        addressId: json["address_id"].toString(),
        whatsappNumber: json["whatsapp_number"].toString(),
        supportNumber: json["support_number"].toString(),
        facebookUrl: json["facebook_url"].toString(),
        instagramUrl: json["instagram_url"].toString(),
        messengerUrl: json["messenger_url"].toString(),
        supportUrl: json["support_url"].toString(),
        websiteUrl: json["website_url"].toString(),
        baseUrl: json["base_url"].toString(),
        imageBaseUrl: json["image_base_url"].toString(),
        currency: json["currency"].toString(),
        additionalInfo: json["additional_info"].toString(),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "logo_file_name": logoFileName,
        "phone": phone,
        "email": email,
        "address_id": addressId,
        "whatsapp_number": whatsappNumber,
        "support_number": supportNumber,
        "facebook_url": facebookUrl,
        "instagram_url": instagramUrl,
        "messenger_url": messengerUrl,
        "support_url": supportUrl,
        "website_url": websiteUrl,
        "base_url": baseUrl,
        "image_base_url": imageBaseUrl,
        "currency": currency,
        "additional_info": additionalInfo,
      };
}

class MobileAppConfigs {
  MobileAppConfigs({
    this.headers,
    this.original,
    this.exception,
  });

  Headers headers;
  MobileAppConfigsOriginal original;
  dynamic exception;

  factory MobileAppConfigs.fromJson(Map<String, dynamic> json) =>
      MobileAppConfigs(
        headers: Headers.fromJson(json["headers"]),
        original: MobileAppConfigsOriginal.fromJson(json["original"]),
        exception: json["exception"],
      );

  Map<String, dynamic> toJson() => {
        "headers": headers.toJson(),
        "original": original.toJson(),
        "exception": exception,
      };
}

class MobileAppConfigsOriginal {
  MobileAppConfigsOriginal({
    this.success,
    this.data,
  });

  bool success;
  List<StickyDatum> data;

  factory MobileAppConfigsOriginal.fromJson(Map<String, dynamic> json) =>
      MobileAppConfigsOriginal(
        success: json["success"],
        data: List<StickyDatum>.from(
            json["data"].map((x) => StickyDatum.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "success": success,
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
      };
}

class StickyDatum {
  StickyDatum({
    this.id,
    this.iosCurrentVersion,
    this.iosLastSupportedVersion,
    this.androidCurrentVersion,
    this.androidLastSupportedVersion,
    this.googlePlayUrl,
    this.appStoreUrl,
    this.iosIsActive,
    this.androidIsActive,
    this.maintenanceMessages,
  });

  int id;
  String iosCurrentVersion;
  String iosLastSupportedVersion;
  String androidCurrentVersion;
  String androidLastSupportedVersion;
  String googlePlayUrl;
  String appStoreUrl;
  String iosIsActive;
  String androidIsActive;
  String maintenanceMessages;

  factory StickyDatum.fromJson(Map<String, dynamic> json) => StickyDatum(
        id: json["id"],
        iosCurrentVersion: json["ios_current_version"].toString(),
        iosLastSupportedVersion: json["ios_last_supported_version"].toString(),
        androidCurrentVersion: json["android_current_version"].toString(),
        androidLastSupportedVersion:
            json["android_last_supported_version"].toString(),
        googlePlayUrl: json["google_play_url"].toString(),
        appStoreUrl: json["app_store_url"].toString(),
        iosIsActive: json["ios_is_active"].toString(),
        maintenanceMessages: json["maintenance_messages"].toString(),
        androidIsActive: json["android_is_active"].toString(),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "ios_current_version": iosCurrentVersion,
        "ios_last_supported_version": iosLastSupportedVersion,
        "android_current_version": androidCurrentVersion,
        "android_last_supported_version": androidLastSupportedVersion,
        "google_play_url": googlePlayUrl,
        "app_store_url": appStoreUrl,
        "ios_is_active": iosIsActive,
        "maintenance_messages": maintenanceMessages,
        "android_is_active": androidIsActive,
      };
}

class Orders {
  Orders({
    this.headers,
    this.original,
    this.exception,
  });

  Headers headers;
  OrdersOriginal original;
  dynamic exception;

  factory Orders.fromJson(Map<String, dynamic> json) => Orders(
        headers: Headers.fromJson(json["headers"]),
        original: OrdersOriginal.fromJson(json["original"]),
        exception: json["exception"],
      );

  Map<String, dynamic> toJson() => {
        "headers": headers.toJson(),
        "original": original.toJson(),
        "exception": exception,
      };
}

class OrdersOriginal {
  OrdersOriginal({
    this.success,
    this.data,
  });

  bool success;
  PageData data;

  factory OrdersOriginal.fromJson(Map<String, dynamic> json) => OrdersOriginal(
        success: json["success"],
        data: PageData.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "success": success,
        "data": data.toJson(),
      };
}

class PageData {
  PageData({
    this.data,
  });

  List<OrdersOriginalData> data;

  factory PageData.fromJson(Map<String, dynamic> json) => PageData(
        data: List<OrdersOriginalData>.from(
            json["data"].map((x) => OrdersOriginalData.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
      };
}

class OrdersOriginalData {
  OrdersOriginalData(
      {this.id,
      this.expectedTimeMinutes,
      this.deliveryCost,
      this.supportedCityCost,
      this.orderStatusId,
      this.paymentMethodId,
      this.deliveryMethodId,
      this.warehouseId,
      this.addressId,
      this.userId,
      this.couponId,
      this.userDeliveryRating,
      this.userPriceRating,
      this.userComment,
      this.total,
      this.userNotes,
      this.supportedCityId,
      this.underUpdate,
      this.deliveryStaffId,
      this.products,
      this.address,
      this.userData,
      this.createdAt});

  int id;
  String expectedTimeMinutes;
  String deliveryCost;
  String supportedCityCost;
  String orderStatusId;
  String paymentMethodId;
  String deliveryMethodId;
  String warehouseId;
  String addressId;
  String userId;
  dynamic couponId;
  dynamic userDeliveryRating;
  dynamic userPriceRating;
  dynamic userComment;
  String total;
  DateTime createdAt;
  OrderAddress address;
  UserData userData;

  String userNotes;
  String supportedCityId;
  String underUpdate;
  dynamic deliveryStaffId;
  List<OrderProducts> products;

  factory OrdersOriginalData.fromJson(Map<String, dynamic> json) =>
      OrdersOriginalData(
        id: json["id"],
        expectedTimeMinutes: json["expected_time_minutes"].toString(),
        deliveryCost: json["delivery_cost"].toString(),
        supportedCityCost: json["supported_city_cost"].toString(),
        orderStatusId: json["order_status_id"].toString(),
        paymentMethodId: json["payment_method_id"].toString(),
        deliveryMethodId: json["delivery_method_id"].toString(),
        warehouseId: json["warehouse_id"].toString(),
        addressId: json["address_id"].toString(),
        userId: json["user_id"].toString(),
        couponId: json["coupon_id"].toString(),
        userDeliveryRating: json["user_delivery_rating"].toString(),
        userPriceRating: json["user_price_rating"].toString(),
        userComment: json["user_comment"].toString(),
        total: json["total"].toString(),
        userData: UserData.fromJson(json["user"]),
        address: OrderAddress.fromJson(json["address"]),
        userNotes: json["user_notes"],
        createdAt: DateTime.parse(json["created_at"]),
        supportedCityId: json["supported_city_id"].toString(),
        underUpdate: json["under_update"].toString(),
        deliveryStaffId: json["delivery_staff_id"].toString(),
        products: List<OrderProducts>.from(
            json["products"].map((x) => OrderProducts.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "expected_time_minutes": expectedTimeMinutes,
        "delivery_cost": deliveryCost,
        "supported_city_cost": supportedCityCost,
        "order_status_id": orderStatusId,
        "payment_method_id": paymentMethodId,
        "delivery_method_id": deliveryMethodId,
        "warehouse_id": warehouseId,
        "address_id": addressId,
        "user_id": userId,
        "coupon_id": couponId,
        "user_delivery_rating": userDeliveryRating,
        "user_price_rating": userPriceRating,
        "user_comment": userComment,
        "total": total,
        "created_at": createdAt.toIso8601String(),
        "user_notes": userNotes,
        "address": address.toJson(),
        "user": userData.toJson(),
        "supported_city_id": supportedCityId,
        "under_update": underUpdate,
        "delivery_staff_id": deliveryStaffId,
        "products": List<dynamic>.from(products.map((x) => x.toJson())),
      };
}

class OrderProducts {
  OrderProducts({
    this.id,
    this.name,
    this.description,
    this.unit,
    this.isInFacebook,
    this.categoryId,
    this.quantity,
    this.pivot,
    this.images,
    this.supplierCode,
  });

  int id;
  String name;
  String description;
  String unit;
  String isInFacebook;
  String categoryId;
  String quantity;
  String supplierCode;

  OrderProductPivot pivot;

  List<ProductImage> images;

  factory OrderProducts.fromJson(Map<String, dynamic> json) => OrderProducts(
        id: json["id"],
        name: json["name"],
        description: json["description"],
        unit: json["unit"].toString(),
        isInFacebook: json["is_in_facebook"].toString(),
        categoryId: json["category_id"].toString(),
        supplierCode: json["supplier_code"].toString(),
        quantity: json["quantity"].toString(),
        pivot: OrderProductPivot.fromJson(json["pivot"]),
        images: List<ProductImage>.from(
            json["images"].map((x) => ProductImage.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "description": description,
        "unit": unit,
        "is_in_facebook": isInFacebook,
        "category_id": categoryId,
        "quantity": quantity,
        "pivot": pivot.toJson(),
        "supplier_code": supplierCode,
        "images": List<dynamic>.from(images.map((x) => x.toJson())),
      };
}

class ProductImage {
  ProductImage({
    this.id,
    this.productId,
    this.imageFileName,
  });

  int id;
  String productId;
  String imageFileName;

  factory ProductImage.fromJson(Map<String, dynamic> json) => ProductImage(
        id: json["id"],
        productId: json["product_id"].toString(),
        imageFileName: json["image_file_name"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "product_id": productId,
        "image_file_name": imageFileName,
      };
}

class OrderProductPivot {
  OrderProductPivot(
      {this.orderId, this.productId, this.purchasePrice, this.quantity});

  String orderId;
  String productId;
  String purchasePrice;

  String quantity;

  factory OrderProductPivot.fromJson(Map<String, dynamic> json) =>
      OrderProductPivot(
        orderId: json["order_id"].toString(),
        productId: json["product_id"].toString(),
        purchasePrice: json["purchase_price"].toString(),
        quantity: json["quantity"].toString(),
      );

  Map<String, dynamic> toJson() => {
        "order_id": orderId,
        "product_id": productId,
        "purchase_price": purchasePrice,
        "quantity": quantity,
      };
}

class SupportedCity {
  SupportedCity({
    this.headers,
    this.original,
    this.exception,
  });

  Headers headers;
  SupportedCityOriginal original;
  dynamic exception;

  factory SupportedCity.fromJson(Map<String, dynamic> json) => SupportedCity(
        headers: Headers.fromJson(json["headers"]),
        original: SupportedCityOriginal.fromJson(json["original"]),
        exception: json["exception"],
      );

  Map<String, dynamic> toJson() => {
        "headers": headers.toJson(),
        "original": original.toJson(),
        "exception": exception,
      };
}

class SupportedCityOriginal {
  SupportedCityOriginal({
    this.success,
    this.data,
  });

  bool success;
  List<IndigoDatum> data;

  factory SupportedCityOriginal.fromJson(Map<String, dynamic> json) =>
      SupportedCityOriginal(
        success: json["success"],
        data: List<IndigoDatum>.from(
            json["data"].map((x) => IndigoDatum.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "success": success,
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
      };
}

class IndigoDatum {
  IndigoDatum({
    this.id,
    this.name,
    this.deliveryPrice,
    this.warehouseId,
    this.couponTypeId,
    this.isActive,
    this.maintenanceMessages,
    this.supportPhoneNumber,
    this.warehouse,
  });

  int id;
  String name;
  String deliveryPrice;
  String warehouseId;
  String couponTypeId;
  String isActive;
  Warehouse warehouse;
  String supportPhoneNumber;
  String maintenanceMessages;

  factory IndigoDatum.fromJson(Map<String, dynamic> json) => IndigoDatum(
        id: json["id"],
        name: json["name"],
        deliveryPrice: json["delivery_price"].toString(),
        warehouseId: json["warehouse_id"].toString(),
        couponTypeId: json["coupon_type_id"].toString(),
        isActive: json["is_active"].toString(),
        supportPhoneNumber: json["support_phone_number"].toString(),
        maintenanceMessages: json["maintenance_messages"].toString(),
        warehouse: Warehouse.fromJson(
          json["warehouse"],
        ),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "delivery_price": deliveryPrice,
        "warehouse_id": warehouseId,
        "coupon_type_id": couponTypeId,
        "is_active": isActive,
        "maintenance_messages": maintenanceMessages,
        "support_phone_number": supportPhoneNumber,
        "warehouse": warehouse.toJson(),
      };
}

class User {
  User({
    this.headers,
    this.original,
    this.exception,
  });

  Headers headers;
  UserOriginal original;
  dynamic exception;

  factory User.fromJson(Map<String, dynamic> json) => User(
        headers: Headers.fromJson(json["headers"]),
        original: UserOriginal.fromJson(json["original"]),
        exception: json["exception"],
      );

  Map<String, dynamic> toJson() => {
        "headers": headers.toJson(),
        "original": original.toJson(),
        "exception": exception,
      };
}

class UserOriginal {
  UserOriginal({
    this.success,
    this.data,
  });

  bool success;
  UserData data;

  factory UserOriginal.fromJson(Map<String, dynamic> json) => UserOriginal(
        success: json["success"],
        data: UserData.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "success": success,
        "data": data.toJson(),
      };
}

class UserData {
  UserData({
    this.id,
    this.name,
    this.phone,
    this.email,
    this.firebaseToken,
    this.isBanned,
    this.isActivated,
    this.couponId,
    this.rememberToken,
    this.warehouseId,
    this.supportedCityId,
    // this.addresses,
    this.coupon,
  });

  int id;
  String name;
  String phone;
  dynamic email;
  dynamic firebaseToken;
  String isBanned;
  String isActivated;
  dynamic couponId;
  dynamic rememberToken;

  String warehouseId;
  dynamic supportedCityId;
  // List<Address> addresses;
  dynamic coupon;

  factory UserData.fromJson(Map<String, dynamic> json) => UserData(
        id: json["id"],
        name: json["name"],
        phone: json["phone"],
        email: json["email"],
        firebaseToken: json["firebase_token"],
        isBanned: json["is_banned"].toString(),
        isActivated: json["is_activated"].toString(),
        couponId: json["coupon_id"].toString(),
        rememberToken: json["remember_token"].toString(),
        warehouseId: json["warehouse_id"].toString(),
        supportedCityId: json["supported_city_id"].toString(),
        // addresses: List<Address>.from(
        //     json["addresses"].map((x) => Address.fromJson(x))),
        coupon: json["coupon"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "phone": phone,
        "email": email,
        "firebase_token": firebaseToken,
        "is_banned": isBanned,
        "is_activated": isActivated,
        "coupon_id": couponId,
        "remember_token": rememberToken,
        "warehouse_id": warehouseId,
        "supported_city_id": supportedCityId,
        // "addresses": List<dynamic>.from(addresses.map((x) => x.toJson())),
        "coupon": coupon,
      };
}

class OrderAddress {
  OrderAddress(
      {this.id,
      this.supportedCityId,
      this.street,
      this.building,
      this.floor,
      this.description,
      this.deliveryPrice,
      this.lat,
      this.lon,
      this.entrance});

  int id;
  String supportedCityId;
  String street;
  String building;
  String floor;
  String description;
  int deliveryPrice;
  String lat;
  String lon;
  String entrance;

  factory OrderAddress.fromJson(Map<String, dynamic> json) => OrderAddress(
        id: json["id"],
        supportedCityId: json["supported_city_id"].toString(),
        street: json["street"].toString(),
        building: json["building"].toString(),
        floor: json["floor"].toString(),
        description: json["description"].toString(),
        deliveryPrice: json["deliveryPrice"],
        lat: json["lat"].toString(),
        lon: json["lon"].toString(),
        entrance: json["entrance"].toString(),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "supported_city_id": supportedCityId,
        "street": street,
        "building": building,
        "floor": floor,
        "description": description,
        "deliveryPrice": deliveryPrice,
        "lat": lat,
        "lon": lon,
        "entrance": entrance,
      };
}

class Address {
  Address(
      {this.id,
      this.supportedCityId,
      this.street,
      this.building,
      this.floor,
      this.description,
      this.pivot,
      this.supportedCityName,
      this.deliveryPrice,
      this.lat,
      this.lon,
      this.entrance});

  int id;
  String supportedCityId;
  String street;
  String building;
  String floor;
  String description;
  AddressPivot pivot;
  String supportedCityName;
  int deliveryPrice;
  String lat;
  String lon;
  String entrance;

  factory Address.fromJson(Map<String, dynamic> json) => Address(
        id: json["id"],
        supportedCityId: json["supported_city_id"].toString(),
        street: json["street"].toString(),
        building: json["building"].toString(),
        floor: json["floor"].toString(),
        description: json["description"].toString(),
        supportedCityName: json["supportedCityName"].toString(),
        deliveryPrice: json["deliveryPrice"],
        lat: json["lat"].toString(),
        lon: json["lon"].toString(),
        entrance: json["entrance"].toString(),
        pivot: AddressPivot.fromJson(json["pivot"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "supported_city_id": supportedCityId,
        "street": street,
        "building": building,
        "floor": floor,
        "description": description,
        "supportedCityName": supportedCityName,
        "deliveryPrice": deliveryPrice,
        "lat": lat,
        "lon": lon,
        "entrance": entrance,
        "pivot": pivot.toJson(),
      };
}

class AddressPivot {
  AddressPivot({
    this.userId,
    this.addressId,
  });

  String userId;
  String addressId;
  dynamic createdAt;
  dynamic updatedAt;

  factory AddressPivot.fromJson(Map<String, dynamic> json) => AddressPivot(
        userId: json["user_id"].toString(),
        addressId: json["address_id"].toString(),
      );

  Map<String, dynamic> toJson() => {
        "user_id": userId,
        "address_id": addressId,
        "created_at": createdAt,
        "updated_at": updatedAt,
      };
}

class DeliveryMethod {
  DeliveryMethod({
    this.headers,
    this.original,
    this.exception,
  });

  Headers headers;
  DeliveryMethodOriginal original;
  dynamic exception;

  factory DeliveryMethod.fromJson(Map<String, dynamic> json) => DeliveryMethod(
        headers: Headers.fromJson(json["headers"]),
        original: DeliveryMethodOriginal.fromJson(json["original"]),
        exception: json["exception"],
      );

  Map<String, dynamic> toJson() => {
        "headers": headers.toJson(),
        "original": original.toJson(),
        "exception": exception,
      };
}

class DeliveryMethodOriginal {
  DeliveryMethodOriginal({
    this.success,
    this.data,
  });

  bool success;
  List<DeliveryMethodOriginalData> data;

  factory DeliveryMethodOriginal.fromJson(Map<String, dynamic> json) =>
      DeliveryMethodOriginal(
        success: json["success"],
        data: List<DeliveryMethodOriginalData>.from(
            json["data"].map((x) => DeliveryMethodOriginalData.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "success": success,
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
      };
}

class DeliveryMethodOriginalData {
  DeliveryMethodOriginalData({
    this.id,
    this.name,
    this.price,
    this.isActive,
    this.message,
  });

  int id;
  String name;
  String price;
  String isActive;
  String message;

  factory DeliveryMethodOriginalData.fromJson(Map<String, dynamic> json) =>
      DeliveryMethodOriginalData(
        id: json["id"],
        name: json["name"],
        price: json["price"].toString(),
        isActive: json["is_active"].toString(),
        message: json["message"].toString(),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "price": price,
        "message": message,
        "is_active": isActive
      };
}
