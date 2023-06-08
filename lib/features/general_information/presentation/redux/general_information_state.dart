import 'package:kammun_app/features/general_information/domain/entities/sub_warehouse_entity.dart';

import '../../../../core/core_importer.dart';
import '../../domain/entities/category_entity.dart';
import '../../domain/entities/warehouse_entity.dart';

@immutable
class GeneralInformationState extends Equatable {
  final List<SubWarehouseEntity> subWarehouses;
  final List<WarehouseEntity> warehouses;
  final List<CategoryEntity> categories;
  final List<DropdownMenuItem> categoriesMenu;
  final CompanyInfoEntity companyInformation;

  const GeneralInformationState(
      {this.subWarehouses, this.warehouses, this.categories, this.categoriesMenu, this.companyInformation});

  factory GeneralInformationState.initial() {
    return const GeneralInformationState(subWarehouses: [], warehouses: [], categories: [], categoriesMenu: []);
  }

  GeneralInformationState copyWith({
    List<SubWarehouseEntity> subWarehouses,
    List<WarehouseEntity> warehouses,
    List<CategoryEntity> categories,
    List<DropdownMenuItem> categoriesMenu,
    CompanyInfoEntity companyInformation,
  }) {
    return GeneralInformationState(
      subWarehouses: subWarehouses ?? this.subWarehouses,
      categoriesMenu: categoriesMenu ?? this.categoriesMenu,
      warehouses: warehouses ?? this.warehouses,
      categories: categories ?? this.categories,
      companyInformation: companyInformation ?? this.companyInformation,
    );
  }

  @override
  List<Object> get props => [subWarehouses, warehouses, categories, categoriesMenu, companyInformation];
}
