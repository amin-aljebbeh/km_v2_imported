import 'package:kammun_app/features/general_information/domain/entities/sub_warehouse_entity.dart';
import 'package:kammun_app/features/general_information/domain/entities/supported_city_entity.dart';

import '../../../../core/core_importer.dart';
import '../../domain/entities/category_entity.dart';
import '../../domain/entities/warehouse_entity.dart';

@immutable
class GeneralInformationState extends Equatable {
  final List<SubWarehouseEntity> subWarehouses;
  final List<WarehouseEntity> warehouses;
  final List<CategoryEntity> categories;
  final List<SupportedCityEntity> supportedCities;
  final List<DropdownMenuItem> categoriesMenu;
  final CompanyInfoEntity companyInformation;

  const GeneralInformationState({
    this.subWarehouses,
    this.warehouses,
    this.categories,
    this.categoriesMenu,
    this.companyInformation,
    this.supportedCities,
  });

  factory GeneralInformationState.initial() {
    return const GeneralInformationState(
        subWarehouses: [], warehouses: [], categories: [], categoriesMenu: [], supportedCities: []);
  }

  GeneralInformationState copyWith({
    List<SubWarehouseEntity> subWarehouses,
    List<WarehouseEntity> warehouses,
    List<CategoryEntity> categories,
    List<DropdownMenuItem> categoriesMenu,
    CompanyInfoEntity companyInformation,
    List<SupportedCityEntity> supportedCities,
  }) {
    return GeneralInformationState(
      subWarehouses: subWarehouses ?? this.subWarehouses,
      categoriesMenu: categoriesMenu ?? this.categoriesMenu,
      warehouses: warehouses ?? this.warehouses,
      supportedCities: supportedCities ?? this.supportedCities,
      categories: categories ?? this.categories,
      companyInformation: companyInformation ?? this.companyInformation,
    );
  }

  @override
  List<Object> get props =>
      [subWarehouses, warehouses, categories, categoriesMenu, companyInformation, supportedCities];
}
