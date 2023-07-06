import '../../domain/entities/general_info_entity.dart';

class GeneralInfoModel extends GeneralInfoEntity {
  GeneralInfoModel({totalCompanyDues, totalProfitsShoppers})
      : super(totalCompanyDues: totalCompanyDues, totalProfitsShoppers: totalProfitsShoppers);

  factory GeneralInfoModel.fromJson(Map<String, dynamic> json) => GeneralInfoModel(
      totalCompanyDues: json['total_company_dues'], totalProfitsShoppers: json['total_profits_shoppers']);

  Map<String, dynamic> toJson() =>
      {'total_company_dues': totalCompanyDues, 'total_profits_shoppers': totalProfitsShoppers};
}
