
import '../../../../core/core_importer.dart';
import '../../domain/entities/balance_entity.dart';

Balance balanceModelFromJson(String str) => Balance.fromJson(json.decode(str));

class Balance {
  Balance( {this.success, this.data});

  bool success;
  BalanceModel data;

  factory Balance.fromJson(Map<String, dynamic> json) =>
      Balance(success: json['status'],
        data: json["data"] == null ? null : BalanceModel.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {'status': success, 'data': data};

}

class BalanceModel extends BalanceEntity {
  BalanceModel({
    shopperSum,
    companySum,

  }) : super(

    shopperSum :shopperSum,
    companySum:companySum,
  );

  factory BalanceModel.fromJson(Map<String, dynamic> json) => BalanceModel(
    companySum: json['company_sum'] ,
    shopperSum: json['shopper_sum'],

  );

  Map<String, dynamic> toJson() => {
    'shopperSum': shopperSum,
    'companySum': companySum,

  };
}
