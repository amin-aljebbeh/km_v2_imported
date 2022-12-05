class KeyValueModel {
  KeyValueModel({this.key, this.value, this.info});

  String key;
  String value;
  List<KeyValueModel> info;

  factory KeyValueModel.fromJson(Map<String, dynamic> json) => KeyValueModel(
        key: json['key'],
        value: json['value'].toString(),
        info:
            json['info'] == null ? null : List<KeyValueModel>.from(json['info'].map((x) => KeyValueModel.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        'key': key,
        'value': value,
        'info': info == null ? null : List<dynamic>.from(info.map((x) => x.toJson())),
      };
}
