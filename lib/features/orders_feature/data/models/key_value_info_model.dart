import 'package:kammun_app/features/orders_feature/domain/entities/key_value_info_entity.dart';

class KeyValueInfoModel extends KeyValueInfoEntity {
  KeyValueInfoModel({String key, String value, info}) : super(key: key, value: value, info: info);
  factory KeyValueInfoModel.fromJson(Map<String, dynamic> json) => KeyValueInfoModel(
        key: json['key'],
        value: json['value'].toString(),
        info: json['info'] == null
            ? null
            : List<KeyValueInfoModel>.from(json['info'].map((x) => KeyValueInfoModel.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {'key': key, 'value': value};
}
