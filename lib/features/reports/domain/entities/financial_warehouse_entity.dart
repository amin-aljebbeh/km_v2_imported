import 'shopper_info_entity.dart';

class FinancialWarehouseEntity {
  FinancialWarehouseEntity({this.id, this.name, this.totalCompanyDues, this.totalProfitsShoppers, this.shoppers});

  int id;
  String name;
  int totalCompanyDues;
  int totalProfitsShoppers;
  List<ShopperInfoEntity> shoppers;
}
