import 'package:kammun_app/features/barcode/domain/entities/barcode_entity.dart';

import '../../../../core/core_importer.dart';

CreateBarcodeResponseModel createBarcodeResponseModelFromJson(String str) =>
    CreateBarcodeResponseModel.fromJson(json.decode(str));

String createBarcodeResponseModelToJson(CreateBarcodeResponseModel data) => json.encode(data.toJson());

class CreateBarcodeResponseModel {
  bool success;
  BarcodeModel data;

  CreateBarcodeResponseModel({this.success, this.data});

  factory CreateBarcodeResponseModel.fromJson(Map<String, dynamic> json) =>
      CreateBarcodeResponseModel(success: json['success'], data: BarcodeModel.fromJson(json['data']));

  Map<String, dynamic> toJson() => {'success': success, 'data': data.toJson()};
}

class BarcodeModel extends BarcodeEntity {
  BarcodeModel(
      {String productId, String barcode, String warehouseId, DateTime updatedAt, DateTime createdAt, String id})
      : super(
          productId: productId,
          barcode: barcode,
          warehouseId: warehouseId,
          updatedAt: updatedAt,
          createdAt: createdAt,
          id: id,
        );

  factory BarcodeModel.fromJson(Map<String, dynamic> json) {
    return BarcodeModel(
      productId: json['product_id'] == null ? '0' : json['product_id'].toString(),
      barcode: json['barcode'] == null ? 'null' : json['barcode'].toString(),
      warehouseId: json['warehouse_id'] == null ? '0' : json['warehouse_id'].toString(),
      updatedAt: json['updated_at'] == null ? null : DateTime.parse(json['updated_at']),
      createdAt: json['created_at'] == null ? null : DateTime.parse(json['created_at']),
      id: json['id'] == null ? '0' : json['id'].toString(),
    );
  }

  Map<String, dynamic> toJson() => {'product_id': productId, 'barcode': barcode, 'warehouse_id': warehouseId, 'id': id};
}
