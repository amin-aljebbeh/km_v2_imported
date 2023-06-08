import 'package:kammun_app/features/general_information/presentation/redux/general_information_action.dart';
import 'package:kammun_app/features/general_information/presentation/redux/general_information_state.dart';

import '../../../../core/core_importer.dart';

Reducer<GeneralInformationState> generalInformationReducer = combineReducers<GeneralInformationState>([
  TypedReducer<GeneralInformationState, SetSubWarehouses>(setSubWarehouses),
  TypedReducer<GeneralInformationState, SetWarehouses>(setWarehouses),
  TypedReducer<GeneralInformationState, SetCategories>(setCategories),
  TypedReducer<GeneralInformationState, SetCategoriesMenu>(setCategoriesMenu),
  TypedReducer<GeneralInformationState, SetCompanyInfo>(setCompanyInfo),
]);

GeneralInformationState setSubWarehouses(GeneralInformationState state, SetSubWarehouses action) =>
    state.copyWith(subWarehouses: action.subWarehouses);

GeneralInformationState setWarehouses(GeneralInformationState state, SetWarehouses action) =>
    state.copyWith(warehouses: action.warehouses);

GeneralInformationState setCategories(GeneralInformationState state, SetCategories action) =>
    state.copyWith(categories: action.categories);

GeneralInformationState setCategoriesMenu(GeneralInformationState state, SetCategoriesMenu action) =>
    state.copyWith(categoriesMenu: action.categories);

GeneralInformationState setCompanyInfo(GeneralInformationState state, SetCompanyInfo action) =>
    state.copyWith(companyInformation: action.info);
