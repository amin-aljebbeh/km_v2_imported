import 'package:kammun_app/features/general_information/domain/entities/sub_warehouse_entity.dart';

import '../../../../core/core_importer.dart';
import '../../domain/entities/category_entity.dart';
import '../../domain/entities/supported_city_entity.dart';
import '../../domain/entities/warehouse_entity.dart';

class SetSubWarehouses {
  final List<SubWarehouseEntity> subWarehouses;

  SetSubWarehouses({this.subWarehouses});
}

class SetWarehouses {
  final List<WarehouseEntity> warehouses;

  SetWarehouses({this.warehouses});
}

class SetCategories {
  final List<CategoryEntity> categories;

  SetCategories({this.categories});
}

class SetSupportedCities {
  final List<SupportedCityEntity> supportedCities;

  SetSupportedCities({this.supportedCities});
}

class SetCategoriesMenu {
  final List<DropdownMenuItem> categories;

  SetCategoriesMenu({this.categories});
}

class SetCompanyInfo {
  final CompanyInfoEntity info;

  SetCompanyInfo({this.info});
}

class UpdateRequired {}
