import 'package:kammun_app/features/warehouses/domain/entities/warehouse_entity.dart';

class CategoryEntity {
  final int id;
  final String name;
  final String imageFileName;
  final String parentCategoryId;
  final String isCompany;
  final List<WarehouseEntity> warehouses;

  CategoryEntity({this.id, this.name, this.imageFileName, this.parentCategoryId, this.isCompany, this.warehouses});
}
