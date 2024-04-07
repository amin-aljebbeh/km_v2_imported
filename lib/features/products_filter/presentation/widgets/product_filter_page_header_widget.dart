import '../../../../core/core_importer.dart';
import '../redux/products_filter_action.dart';

class ProductFilterPageHeaderWidget extends StatelessWidget {
   ProductFilterPageHeaderWidget({Key key, this.controller})
      : super(key: key);
  final TextEditingController controller;
  final TextEditingController pageController = TextEditingController();


  @override
  Widget build(BuildContext context) {
    var store = StoreProvider.of<AppState>(context);
    return StoreConnector<AppState, AppState>(
      converter: (store) => store.state,
      distinct: true,
      builder: (context, state) {
        var productsFilterState = state.productsFilterState;
        return Padding(
          padding: EdgeInsets.only(bottom: MediaQuery
              .of(context)
              .size
              .height * 0.02),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              IconButton(
                icon: Icon(Icons.arrow_back, size: 40, color: primaryColor),
                onPressed: () {
                  if (productsFilterState.filteredProducts.isNotEmpty &&
                      productsFilterState.hasNextFilteredProducts &&
                      (controller.text.isNotEmpty ||
                          productsFilterState.filteredProductsTypes ==
                              FilteredProductsTypes.deleted)) {
                    store.dispatch(
                        InitProductsFilter(context: context,
                            page: productsFilterState.filteredProductsPage +
                                1));
                  }
                },
              ),
              DropdownButton(
                hint: Text('فلترة المنتجات', style: dropdownItemStyle),
                // ignore: prefer_null_aware_operators
                value: productsFilterState.filteredProductsTypes == null
                    ? null
                    : productsFilterState.filteredProductsTypes.index,
                items: Services.dropdownStringList(productFilter),
                onChanged: (value) {
                  store.dispatch(SetFilteredProductsViewTypes(
                      type: FilteredProductsTypes.values[value]));
                  if (value == 3) {
                    showMyDialog(
                      context: context,
                      title: 'اختر تاريخ',
                      dialogButtons: [
                        const CloseWidget(),
                        DialogButton(
                          text: send,
                          onTap: () {
                            if (validDates(context)) {
                              Navigator.of(context).pop();
                              store.dispatch(
                                  InitProductsFilter(context: context));
                            } else {
                              Toast.show('الرجاء إدخال كافة البيانات', 
                                  duration: Toast.lengthLong,
                                  gravity: Toast.center);
                            }
                          },
                        )
                      ],
                      content: KDatePicker(
                        onConfirmStart: (date) =>
                            store.dispatch(SetFromDate(fromDate: date)),
                        onConfirmEnd: (date) =>
                            store.dispatch(SetToDate(toDate: date)),
                      ),
                    );
                  } else {
                    if (controller.text.isNotEmpty) {
                      store.dispatch(InitProductsFilter(context: context));
                    }
                  }
                },
              ),
              IconButton(
                icon: Icon(
                  productsFilterState.biggerThan
                      ? Icons.keyboard_arrow_up
                      : Icons.keyboard_arrow_down,
                  size: 40,
                  color: primaryColor,
                ),
                onPressed: () {
                  if (controller.text.isNotEmpty &&
                      productsFilterState.filteredProductsTypes !=
                          FilteredProductsTypes.deleted) {
                    store.dispatch(SetBiggerThan(
                        biggerThan: !productsFilterState.biggerThan));
                    store.dispatch(InitProductsFilter(context: context));
                  }
                },
              ),
              Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: EntryField(
                  onSubmit: (value) => store.dispatch(InitProductsFilter(context: context)),
                  controller: controller,
                  textInputType: TextInputType.number,
                  onChange: () => store.dispatch(
                      SetFilterValue(value: int.parse(controller.text))),
                  width: MediaQuery
                      .of(context)
                      .size
                      .width * 0.1,
                ),
              ),
              IconButton(
                icon: Icon(Icons.arrow_forward, size: 40, color: primaryColor),
                onPressed: () {
                  if ((controller.text.isNotEmpty ||
                      productsFilterState.filteredProductsTypes ==
                          FilteredProductsTypes.deleted)) {
                    if (productsFilterState.filteredProductsPage > 1) {
                      store.dispatch(
                          InitProductsFilter(context: context,
                              page: productsFilterState.filteredProductsPage -
                                  1));
                    } else {
                      store.dispatch(
                          GetFilteredProductsAction(context: context));
                    }
                  }
                },
              ),
            ],
          ),
        );
      },
    );
  }

  bool validDates(BuildContext context) {
    var state = StoreProvider.of<AppState>(context).state.productsFilterState;
    return state.fromDate != null && state.toDate != null;
  }
}
