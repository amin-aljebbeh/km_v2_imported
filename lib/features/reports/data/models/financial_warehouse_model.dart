import '../../domain/entities/financial_warehouse_entity.dart';
import 'shopper_info_model.dart';

class FinancialWarehouseModel extends FinancialWarehouseEntity {
  FinancialWarehouseModel({id, name, totalCompanyDues, totalProfitsShoppers, shoppers})
      : super(
          id: id,
          name: name,
          totalCompanyDues: totalCompanyDues,
          totalProfitsShoppers: totalProfitsShoppers,
          shoppers: shoppers,
        );

  factory FinancialWarehouseModel.fromJson(Map<String, dynamic> json) => FinancialWarehouseModel(
        id: json['id'],
        name: json['name'],
        totalCompanyDues: json['total_company_dues'],
        totalProfitsShoppers: json['total_profits_shoppers'],
        shoppers: List<ShopperInfoModel>.from(json['shoppers'].map((x) => ShopperInfoModel.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'total_company_dues': totalCompanyDues,
        'total_profits_shoppers': totalProfitsShoppers,
      };
}
