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
  BarcodeModel({String barcode, String warehouseId, String id})
      : super(barcode: barcode, warehouseId: warehouseId, id: id);

  factory BarcodeModel.fromJson(Map<String, dynamic> json) {
    return BarcodeModel(
      barcode: json['barcode'] == null ? 'null' : json['barcode'].toString(),
      warehouseId: json['warehouse_id'] == null ? '0' : json['warehouse_id'].toString(),
      id: json['id'] == null ? '0' : json['id'].toString(),
    );
  }

  Map<String, dynamic> toJson() => {'barcode': barcode, 'warehouse_id': warehouseId, 'id': id};
}
