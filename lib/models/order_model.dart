// To parse this JSON data, do
//
//     final empty = emptyFromJson(jsonString);

import 'dart:convert';

StartModel startModelFromJson(String str) =>
    StartModel.fromJson(json.decode(str));

String emptyToJson(StartModel data) => json.encode(data.toJson());

class StartModel {
  StartModel({
    this.success,
    this.data,
  });

  bool success;
  Data data;

  factory StartModel.fromJson(Map<String, dynamic> json) => StartModel(
        success: json["success"] == null ? null : json["success"],
        data: json["data"] == null ? null : Data.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "success": success == null ? null : success,
        "data": data == null ? null : data.toJson(),
      };
}

class Data {
  Data({
    this.currentPage,
    this.data,
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
  List<OrdersOriginalData> data;
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

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        currentPage: json["current_page"] == null ? null : json["current_page"],
        data: json["data"] == null
            ? null
            : List<OrdersOriginalData>.from(
                json["data"].map((x) => OrdersOriginalData.fromJson(x))),
        firstPageUrl:
            json["first_page_url"] == null ? null : json["first_page_url"],
        from: json["from"] == null ? null : json["from"],
        lastPage: json["last_page"] == null ? null : json["last_page"],
        lastPageUrl:
            json["last_page_url"] == null ? null : json["last_page_url"],
        nextPageUrl:
            json["next_page_url"] == null ? null : json["next_page_url"],
        path: json["path"] == null ? null : json["path"],
        perPage: json["per_page"] == null ? null : json["per_page"],
        prevPageUrl: json["prev_page_url"],
        to: json["to"] == null ? null : json["to"],
        total: json["total"] == null ? null : json["total"],
      );

  Map<String, dynamic> toJson() => {
        "current_page": currentPage == null ? null : currentPage,
        "data": data == null
            ? null
            : List<dynamic>.from(data.map((x) => x.toJson())),
        "first_page_url": firstPageUrl == null ? null : firstPageUrl,
        "from": from == null ? null : from,
        "last_page": lastPage == null ? null : lastPage,
        "last_page_url": lastPageUrl == null ? null : lastPageUrl,
        "next_page_url": nextPageUrl == null ? null : nextPageUrl,
        "path": path == null ? null : path,
        "per_page": perPage == null ? null : perPage,
        "prev_page_url": prevPageUrl,
        "to": to == null ? null : to,
        "total": total == null ? null : total,
      };
}

class OrdersOriginalData {
  OrdersOriginalData({
    this.id,
    this.expectedTimeMinutes,
    this.deliveryCost,
    this.supportedCityCost,
    this.orderStatusId,
    this.paymentMethodId,
    this.deliveryMethodId,
    this.warehouseId,
    this.addressId,
    this.userId,
    this.deliveryId,
    this.shopperId,
    this.couponId,
    this.userDeliveryRating,
    this.userPriceRating,
    this.userFeedback,
    this.total,
    this.createdAt,
    this.updatedAt,
    this.acceptedAt,
    this.readyAt,
    this.shippedAt,
    this.deliveredAt,
    this.deletedAt,
    this.userNotes,
    this.supportedCityId,
    this.underUpdate,
    this.deliveryStaffId,
    this.products,
    this.paymentMethod,
    this.deliveryMethod,
    this.orderStatus,
    this.address,
    this.coupon,
    this.warehouse,
    this.user,
    this.spendingsOrder,
    this.shopper,
    this.delivery,
  });

  int id;
  int expectedTimeMinutes;
  String deliveryCost;
  String supportedCityCost;
  int orderStatusId;
  int paymentMethodId;
  int deliveryMethodId;
  int warehouseId;
  int addressId;
  int userId;
  int deliveryId;
  int shopperId;
  dynamic couponId;
  dynamic userDeliveryRating;
  dynamic userPriceRating;
  dynamic userFeedback;
  String total;
  DateTime createdAt;
  DateTime updatedAt;
  DateTime acceptedAt;
  DateTime readyAt;
  DateTime shippedAt;
  DateTime deliveredAt;
  dynamic deletedAt;
  dynamic userNotes;
  int supportedCityId;
  int underUpdate;
  dynamic deliveryStaffId;
  List<Product> products;
  Delivery paymentMethod;
  Delivery deliveryMethod;
  Delivery orderStatus;
  Address address;
  dynamic coupon;
  Warehouse warehouse;
  User user;
  List<dynamic> spendingsOrder;
  Delivery shopper;
  Delivery delivery;

  factory OrdersOriginalData.fromJson(Map<String, dynamic> json) =>
      OrdersOriginalData(
        id: json["id"] == null ? null : json["id"],
        expectedTimeMinutes: json["expected_time_minutes"] == null
            ? null
            : json["expected_time_minutes"],
        deliveryCost:
            json["delivery_cost"] == null ? null : json["delivery_cost"],
        supportedCityCost: json["supported_city_cost"] == null
            ? null
            : json["supported_city_cost"],
        orderStatusId:
            json["order_status_id"] == null ? null : json["order_status_id"],
        paymentMethodId: json["payment_method_id"] == null
            ? null
            : json["payment_method_id"],
        deliveryMethodId: json["delivery_method_id"] == null
            ? null
            : json["delivery_method_id"],
        warehouseId: json["warehouse_id"] == null ? null : json["warehouse_id"],
        addressId: json["address_id"] == null ? null : json["address_id"],
        userId: json["user_id"] == null ? null : json["user_id"],
        deliveryId: json["delivery_id"] == null ? null : json["delivery_id"],
        shopperId: json["shopper_id"] == null ? null : json["shopper_id"],
        couponId: json["coupon_id"],
        userDeliveryRating: json["user_delivery_rating"],
        userPriceRating: json["user_price_rating"],
        userFeedback: json["user_feedback"],
        total: json["total"] == null ? null : json["total"],
        createdAt: json["created_at"] == null
            ? null
            : DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"] == null
            ? null
            : DateTime.parse(json["updated_at"]),
        acceptedAt: json["accepted_at"] == null
            ? null
            : DateTime.parse(json["accepted_at"]),
        readyAt:
            json["ready_at"] == null ? null : DateTime.parse(json["ready_at"]),
        shippedAt: json["shipped_at"] == null
            ? null
            : DateTime.parse(json["shipped_at"]),
        deliveredAt: json["delivered_at"] == null
            ? null
            : DateTime.parse(json["delivered_at"]),
        deletedAt: json["deleted_at"],
        userNotes: json["user_notes"],
        supportedCityId: json["supported_city_id"] == null
            ? null
            : json["supported_city_id"],
        underUpdate: json["under_update"] == null ? null : json["under_update"],
        deliveryStaffId: json["delivery_staff_id"],
        products: json["products"] == null
            ? null
            : List<Product>.from(
                json["products"].map((x) => Product.fromJson(x))),
        paymentMethod: json["payment_method"] == null
            ? null
            : Delivery.fromJson(json["payment_method"]),
        deliveryMethod: json["delivery_method"] == null
            ? null
            : Delivery.fromJson(json["delivery_method"]),
        orderStatus: json["order_status"] == null
            ? null
            : Delivery.fromJson(json["order_status"]),
        address:
            json["address"] == null ? null : Address.fromJson(json["address"]),
        coupon: json["coupon"],
        warehouse: json["warehouse"] == null
            ? null
            : Warehouse.fromJson(json["warehouse"]),
        user: json["user"] == null ? null : User.fromJson(json["user"]),
        spendingsOrder: json["spendings_order"] == null
            ? null
            : List<dynamic>.from(json["spendings_order"].map((x) => x)),
        shopper:
            json["shopper"] == null ? null : Delivery.fromJson(json["shopper"]),
        delivery: json["delivery"] == null
            ? null
            : Delivery.fromJson(json["delivery"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id == null ? null : id,
        "expected_time_minutes":
            expectedTimeMinutes == null ? null : expectedTimeMinutes,
        "delivery_cost": deliveryCost == null ? null : deliveryCost,
        "supported_city_cost":
            supportedCityCost == null ? null : supportedCityCost,
        "order_status_id": orderStatusId == null ? null : orderStatusId,
        "payment_method_id": paymentMethodId == null ? null : paymentMethodId,
        "delivery_method_id":
            deliveryMethodId == null ? null : deliveryMethodId,
        "warehouse_id": warehouseId == null ? null : warehouseId,
        "address_id": addressId == null ? null : addressId,
        "user_id": userId == null ? null : userId,
        "delivery_id": deliveryId == null ? null : deliveryId,
        "shopper_id": shopperId == null ? null : shopperId,
        "coupon_id": couponId,
        "user_delivery_rating": userDeliveryRating,
        "user_price_rating": userPriceRating,
        "user_feedback": userFeedback,
        "total": total == null ? null : total,
        "created_at": createdAt == null ? null : createdAt.toIso8601String(),
        "updated_at": updatedAt == null ? null : updatedAt.toIso8601String(),
        "accepted_at": acceptedAt == null ? null : acceptedAt.toIso8601String(),
        "ready_at": readyAt == null ? null : readyAt.toIso8601String(),
        "shipped_at": shippedAt == null ? null : shippedAt.toIso8601String(),
        "delivered_at":
            deliveredAt == null ? null : deliveredAt.toIso8601String(),
        "deleted_at": deletedAt,
        "user_notes": userNotes,
        "supported_city_id": supportedCityId == null ? null : supportedCityId,
        "under_update": underUpdate == null ? null : underUpdate,
        "delivery_staff_id": deliveryStaffId,
        "products": products == null
            ? null
            : List<dynamic>.from(products.map((x) => x.toJson())),
        "payment_method": paymentMethod == null ? null : paymentMethod.toJson(),
        "delivery_method":
            deliveryMethod == null ? null : deliveryMethod.toJson(),
        "order_status": orderStatus == null ? null : orderStatus.toJson(),
        "address": address == null ? null : address.toJson(),
        "coupon": coupon,
        "warehouse": warehouse == null ? null : warehouse.toJson(),
        "user": user == null ? null : user.toJson(),
        "spendings_order": spendingsOrder == null
            ? null
            : List<dynamic>.from(spendingsOrder.map((x) => x)),
        "shopper": shopper == null ? null : shopper.toJson(),
        "delivery": delivery == null ? null : delivery.toJson(),
      };
}

class Address {
  Address({
    this.id,
    this.supportedCityId,
    this.street,
    this.building,
    this.floor,
    this.entrance,
    this.lon,
    this.lat,
    this.description,
  });

  int id;
  int supportedCityId;
  String street;
  String building;
  String floor;
  String entrance;
  dynamic lon;
  dynamic lat;
  String description;

  factory Address.fromJson(Map<String, dynamic> json) => Address(
        id: json["id"] == null ? null : json["id"],
        supportedCityId: json["supported_city_id"] == null
            ? null
            : json["supported_city_id"],
        street: json["street"] == null ? null : json["street"],
        building: json["building"] == null ? null : json["building"],
        floor: json["floor"] == null ? null : json["floor"],
        entrance: json["entrance"] == null ? null : json["entrance"],
        lon: json["lon"],
        lat: json["lat"],
        description: json["description"] == null ? null : json["description"],
      );

  Map<String, dynamic> toJson() => {
        "id": id == null ? null : id,
        "supported_city_id": supportedCityId == null ? null : supportedCityId,
        "street": street == null ? null : street,
        "building": building == null ? null : building,
        "floor": floor == null ? null : floor,
        "entrance": entrance == null ? null : entrance,
        "lon": lon,
        "lat": lat,
        "description": description == null ? null : description,
      };
}

class Delivery {
  Delivery({
    this.id,
    this.name,
  });

  int id;
  String name;

  factory Delivery.fromJson(Map<String, dynamic> json) => Delivery(
        id: json["id"] == null ? null : json["id"],
        name: json["name"] == null ? null : json["name"],
      );

  Map<String, dynamic> toJson() => {
        "id": id == null ? null : id,
        "name": name == null ? null : name,
      };
}

class Product {
  Product({
    this.id,
    this.name,
    this.description,
    this.weight,
    this.supplierCode,
    this.warehouseId,
    this.subWarehouseId,
    this.priceFactor,
    this.isActive,
    this.quantity,
    this.unit,
    this.purchasePrice,
    this.pivot,
    this.images,
  });

  int id;
  String name;
  String description;
  String weight;
  String supplierCode;
  int warehouseId;
  int subWarehouseId;
  String priceFactor;
  int isActive;
  String quantity;
  String unit;
  String purchasePrice;
  Pivot pivot;
  List<Image> images;

  factory Product.fromJson(Map<String, dynamic> json) => Product(
        id: json["id"] == null ? null : json["id"],
        name: json["name"] == null ? null : json["name"],
        description: json["description"] == null ? null : json["description"],
        weight: json["weight"] == null ? null : json["weight"],
        supplierCode:
            json["supplier_code"] == null ? null : json["supplier_code"],
        warehouseId: json["warehouse_id"] == null ? null : json["warehouse_id"],
        subWarehouseId:
            json["sub_warehouse_id"] == null ? null : json["sub_warehouse_id"],
        priceFactor: json["price_factor"] == null ? null : json["price_factor"],
        isActive: json["is_active"] == null ? null : json["is_active"],
        quantity: json["quantity"] == null ? null : json["quantity"],
        unit: json["unit"] == null ? null : json["unit"],
        purchasePrice:
            json["purchase_price"] == null ? null : json["purchase_price"],
        pivot: json["pivot"] == null ? null : Pivot.fromJson(json["pivot"]),
        images: json["images"] == null
            ? null
            : List<Image>.from(json["images"].map((x) => Image.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "id": id == null ? null : id,
        "name": name == null ? null : name,
        "description": description == null ? null : description,
        "weight": weight == null ? null : weight,
        "supplier_code": supplierCode == null ? null : supplierCode,
        "warehouse_id": warehouseId == null ? null : warehouseId,
        "sub_warehouse_id": subWarehouseId == null ? null : subWarehouseId,
        "price_factor": priceFactor == null ? null : priceFactor,
        "is_active": isActive == null ? null : isActive,
        "quantity": quantity == null ? null : quantity,
        "unit": unit == null ? null : unit,
        "purchase_price": purchasePrice == null ? null : purchasePrice,
        "pivot": pivot == null ? null : pivot.toJson(),
        "images": images == null
            ? null
            : List<dynamic>.from(images.map((x) => x.toJson())),
      };
}

class Image {
  Image({
    this.id,
    this.productId,
    this.imageFileName,
  });

  int id;
  int productId;
  String imageFileName;

  factory Image.fromJson(Map<String, dynamic> json) => Image(
        id: json["id"] == null ? null : json["id"],
        productId: json["product_id"] == null ? null : json["product_id"],
        imageFileName:
            json["image_file_name"] == null ? null : json["image_file_name"],
      );

  Map<String, dynamic> toJson() => {
        "id": id == null ? null : id,
        "product_id": productId == null ? null : productId,
        "image_file_name": imageFileName == null ? null : imageFileName,
      };
}

class Pivot {
  Pivot({
    this.orderId,
    this.productId,
    this.quantity,
    this.purchasePrice,
    this.subWarehouseId,
    this.productQuantity,
    this.productUnit,
    this.createdAt,
    this.updatedAt,
  });

  int orderId;
  int productId;
  int quantity;
  String purchasePrice;
  int subWarehouseId;
  String productQuantity;
  String productUnit;
  DateTime createdAt;
  DateTime updatedAt;

  factory Pivot.fromJson(Map<String, dynamic> json) => Pivot(
        orderId: json["order_id"] == null ? null : json["order_id"],
        productId: json["product_id"] == null ? null : json["product_id"],
        quantity: json["quantity"] == null ? null : json["quantity"],
        purchasePrice:
            json["purchase_price"] == null ? null : json["purchase_price"],
        subWarehouseId:
            json["sub_warehouse_id"] == null ? null : json["sub_warehouse_id"],
        productQuantity:
            json["product_quantity"] == null ? null : json["product_quantity"],
        productUnit: json["product_unit"] == null ? null : json["product_unit"],
        createdAt: json["created_at"] == null
            ? null
            : DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"] == null
            ? null
            : DateTime.parse(json["updated_at"]),
      );

  Map<String, dynamic> toJson() => {
        "order_id": orderId == null ? null : orderId,
        "product_id": productId == null ? null : productId,
        "quantity": quantity == null ? null : quantity,
        "purchase_price": purchasePrice == null ? null : purchasePrice,
        "sub_warehouse_id": subWarehouseId == null ? null : subWarehouseId,
        "product_quantity": productQuantity == null ? null : productQuantity,
        "product_unit": productUnit == null ? null : productUnit,
        "created_at": createdAt == null ? null : createdAt.toIso8601String(),
        "updated_at": updatedAt == null ? null : updatedAt.toIso8601String(),
      };
}

class User {
  User({
    this.id,
    this.name,
    this.phone,
    this.email,
    this.firebaseToken,
    this.isBanned,
    this.isActivated,
    this.couponId,
    this.rememberToken,
    this.createdAt,
    this.supportedCityId,
    this.warehouseId,
    this.platformType,
    this.balance,
  });

  int id;
  dynamic name;
  String phone;
  dynamic email;
  String firebaseToken;
  int isBanned;
  int isActivated;
  dynamic couponId;
  dynamic rememberToken;
  DateTime createdAt;
  int supportedCityId;
  int warehouseId;
  String platformType;
  String balance;

  factory User.fromJson(Map<String, dynamic> json) => User(
        id: json["id"] == null ? null : json["id"],
        name: json["name"],
        phone: json["phone"] == null ? null : json["phone"],
        email: json["email"],
        firebaseToken:
            json["firebase_token"] == null ? null : json["firebase_token"],
        isBanned: json["is_banned"] == null ? null : json["is_banned"],
        isActivated: json["is_activated"] == null ? null : json["is_activated"],
        couponId: json["coupon_id"],
        rememberToken: json["remember_token"],
        createdAt: json["created_at"] == null
            ? null
            : DateTime.parse(json["created_at"]),
        supportedCityId: json["supported_city_id"] == null
            ? null
            : json["supported_city_id"],
        warehouseId: json["warehouse_id"] == null ? null : json["warehouse_id"],
        platformType:
            json["platform_type"] == null ? null : json["platform_type"],
        balance: json["balance"] == null ? null : json["balance"],
      );

  Map<String, dynamic> toJson() => {
        "id": id == null ? null : id,
        "name": name,
        "phone": phone == null ? null : phone,
        "email": email,
        "firebase_token": firebaseToken == null ? null : firebaseToken,
        "is_banned": isBanned == null ? null : isBanned,
        "is_activated": isActivated == null ? null : isActivated,
        "coupon_id": couponId,
        "remember_token": rememberToken,
        "created_at": createdAt == null ? null : createdAt.toIso8601String(),
        "supported_city_id": supportedCityId == null ? null : supportedCityId,
        "warehouse_id": warehouseId == null ? null : warehouseId,
        "platform_type": platformType == null ? null : platformType,
        "balance": balance == null ? null : balance,
      };
}

class Warehouse {
  Warehouse({
    this.id,
    this.name,
    this.description,
    this.numberOfWorkers,
    this.shopperAlgorithmId,
    this.isActive,
  });

  int id;
  String name;
  String description;
  int numberOfWorkers;
  int shopperAlgorithmId;
  int isActive;

  factory Warehouse.fromJson(Map<String, dynamic> json) => Warehouse(
        id: json["id"] == null ? null : json["id"],
        name: json["name"] == null ? null : json["name"],
        description: json["description"] == null ? null : json["description"],
        numberOfWorkers: json["number_of_workers"] == null
            ? null
            : json["number_of_workers"],
        shopperAlgorithmId: json["shopper_algorithm_id"] == null
            ? null
            : json["shopper_algorithm_id"],
        isActive: json["is_active"] == null ? null : json["is_active"],
      );

  Map<String, dynamic> toJson() => {
        "id": id == null ? null : id,
        "name": name == null ? null : name,
        "description": description == null ? null : description,
        "number_of_workers": numberOfWorkers == null ? null : numberOfWorkers,
        "shopper_algorithm_id":
            shopperAlgorithmId == null ? null : shopperAlgorithmId,
        "is_active": isActive == null ? null : isActive,
      };
}
