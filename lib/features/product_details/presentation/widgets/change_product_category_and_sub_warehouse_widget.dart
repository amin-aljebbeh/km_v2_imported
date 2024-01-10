import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_searchable_dropdown/flutter_searchable_dropdown.dart';
import 'package:kammun_app/features/general_information/data/models/sub_warehouse_model.dart';

import '../../../../core/core_importer.dart';
import '../../../products/domain/entities/product_entity.dart';
import '../../../products_view/services/products_services.dart';

class ChangeProductCategoryAndSubWarehouseWidget extends StatefulWidget {
  final ProductEntity product;
  final Function(String) onChangeSubWarehouse;
  final Function(String) onChangeCategory;
  const ChangeProductCategoryAndSubWarehouseWidget(
      {Key key, this.product, this.onChangeSubWarehouse, this.onChangeCategory})
      : super(key: key);

  @override
  _ChangeProductCategoryAndSubWarehouseWidgetState createState() => _ChangeProductCategoryAndSubWarehouseWidgetState();
}

class _ChangeProductCategoryAndSubWarehouseWidgetState extends State<ChangeProductCategoryAndSubWarehouseWidget> {
  String productSubWarehouseId;
  String selectedCategory;

  @override
  Widget build(BuildContext context) {
    ProductEntity product = widget.product;
    return StoreConnector<AppState, AppState>(
      converter: (store) => store.state,
      distinct: true,
      builder: (context, state) {
        return Column(
          children: [
            Container(
              width: MediaQuery.of(context).size.width.w,
              padding:  EdgeInsets.only(left: 5.w, right: 5.w),
              margin:  EdgeInsets.only(bottom: 15.h),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(6.r), border: Border.all(width: 5.w, color: primaryColor)),
              child: Center(
                child: DropdownButton(
                  style: decisionButtonStyle,
                  underline: Container(),
                  isExpanded: false,
                  items: Services.productSubWarehouseNames(context),
                  iconEnabledColor: primaryColor,
                  value: productSubWarehouseId,
                  hint: Text(
                    state.generalInformationState.subWarehouses
                        .firstWhere((subWarehouse) => subWarehouse.id == product.subWarehouseId,
                            orElse: () => SubWarehouseModel(name: 'غير مضاف'))
                        .name,
                    style: decisionButtonStyle.copyWith(color: primaryColor),
                  ),
                  onChanged: (value) async {
                    product.warehouses.removeWhere((warehouse) => warehouse.id == 0);
                    bool remove = state.generalInformationState.subWarehouses
                        .where((subWarehouse) => subWarehouse.id == product.subWarehouseId
                    )
                        .toList()
                        .isNotEmpty;
                    bool result = await ProductsServices.changeProductSubWarehouse(product, value, remove);

                    if (result) {
                      snackBar(success: result, message: 'تم تغيير مستودع المنتج بنجاح', context: context);
                    } else {
                      snackBar(
                          success: result,
                          message: 'فشلت عملية تغيير مستودع المنتج يرجى المحاولة مجدداً',
                          context: context);
                    }
                    setState(() {
                      if (value != null) {
                        if (result) {
                          productSubWarehouseId = value;
                          product.subWarehouseId = int.parse(value);
                          widget.onChangeSubWarehouse(value);
                        }
                      }
                    });
                  },
                ),
              ),
            ),
            Container(
              width: 350,
              padding:  EdgeInsets.only(left: 5.w, right: 5.w),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(6), border: Border.all(width: 5, color: primaryColor)),
              child: Center(
                child: SearchableDropdown.single(
                  iconDisabledColor: Colors.black,
                  displayClearIcon: false,
                  style: dropdownItemStyle,
                  closeButton: TextButton(
                    child: Text(closeString, style: decisionButtonStyle.copyWith(color: primaryColor),maxLines: 2,),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                  isCaseSensitiveSearch: false,
                  underline: Container(),
                  // isExpanded: false, // remove this line
                  items: state.generalInformationState.categoriesMenu,
                  iconEnabledColor: primaryColor,
                  value: selectedCategory,
                  hint: Text('اختيار الصنف التابع له المنتج', style: decisionButtonStyle.copyWith(color: primaryColor)),
                  searchHint: Text('إختيار الصنف', style: decisionButtonStyle.copyWith(color: primaryColor)),
                  onChanged: (value) => setState(() {
                    if (value != null) {
                      selectedCategory = value.toString().split(';')[1];
                      widget.onChangeCategory(selectedCategory);
                    }
                  }),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
