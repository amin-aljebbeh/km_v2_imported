import '../core_importer.dart';

class KeyValueModel {
  KeyValueModel({this.key, this.value, this.info, this.products});

  String key;
  String value;
  ProductResponse products;
  List<KeyValueModel> info;

  factory KeyValueModel.fromJson(Map<String, dynamic> json) => KeyValueModel(
        key: json['key'],
        value: json['value'].toString(),
        products: json['products'] == null ? null : ProductResponse.fromJson(json['products']),
        info:
            json['info'] == null ? null : List<KeyValueModel>.from(json['info'].map((x) => KeyValueModel.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        'key': key,
        'value': value,
        'info': info == null ? null : List<dynamic>.from(info.map((x) => x.toJson())),
      };
}
