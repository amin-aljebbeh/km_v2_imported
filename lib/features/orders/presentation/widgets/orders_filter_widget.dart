import 'package:kammun_app/features/general_information/domain/entities/warehouse_entity.dart';

import '../../../../core/core_importer.dart';
import '../redux/orders_action.dart';

class OrdersFilterWidget extends StatelessWidget {
  OrdersFilterWidget({Key key}) : super(key: key);
  final TextEditingController pageController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    var store = StoreProvider.of<AppState>(context);
    return StoreConnector<AppState, AppState>(
      converter: (store) => store.state,
      distinct: true,
      builder: (context, state) {
        List<WarehouseEntity> warehouses = [WarehouseEntity(name: 'جميع المستودعات', id: 0)];
        warehouses.addAll(state.generalInformationState.warehouses);
        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Column(
              children: [
                DropdownButton(
                  value: state.ordersState.statusFilter,
                  items: Services.dropdownStringList(orderStatus),
                  onChanged: (value) {
                    store.dispatch(SetOrdersStatusFilter(filter: value));
                    store.dispatch(SetOrdersPage(page: 1));
                    store.dispatch(SetLimitedOrdersPage(page: 1));
                    pageController.clear();
                    store.dispatch(GetOrdersAction(context: context));
                  },
                ),
                if (Services.hasRole(context, operationManagerRole))
                  DropdownButton(
                    value: state.ordersState.assignFilter,
                    items: Services.dropdownStringList(orderTypes),
                    onChanged: (value) {
                      store.dispatch(SetAssignFilter(filter: value));
                      store.dispatch(SetLimitedOrdersPage(page: 1));
                      store.dispatch(SetOrdersPage(page: 1));
                      store.dispatch(GetOrdersAction(context: context));
                    },
                  ),
              ],
            ),
            Expanded(
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      if (Services.hasRole(context, agentRole))
                        InkWell(
                            child: Icon(Icons.star_rounded,
                                size: 40, color: state.ordersState.rateFilter == 1 ? kmColors : searchGreyColor),
                            onTap: () {
                              store.dispatch(SetRateFilter(filter: state.ordersState.rateFilter == 1 ? 0 : 1));
                              store.dispatch(GetOrdersAction(context: context));
                            }),
                      if (Services.hasRole(context, operationManagerRole))
                        SearchOrderByPhoneNumber(context: context, onChoose: () {}),
                      IconButton(
                        onPressed: () {
                          if (state.ordersState.limitedOrdersPage < 15) {
                            store.dispatch(SetLimitedOrdersPage(page: state.ordersState.limitedOrdersPage + 1));
                          }
                          store.dispatch(SetOrdersPage(page: state.ordersState.ordersPage + 1));
                          store.dispatch(GetOrdersAction(context: context));
                        },
                        icon: Icon(Icons.arrow_back, size: 40, color: kmColors),
                      ),
                      DropdownButton(
                        value: state.ordersState.limitedOrdersPage,
                        items: Services.dropdownIntList(inputList: dropdownValues),
                        onChanged: (value) {
                          store.dispatch(SetOrdersPage(page: value));
                          store.dispatch(SetLimitedOrdersPage(page: value));
                          store.dispatch(GetOrdersAction(context: context));
                        },
                      ),
                      IconButton(
                        onPressed: () {
                          if (state.ordersState.ordersPage > 1) {
                            store.dispatch(SetOrdersPage(page: state.ordersState.ordersPage - 1));
                            if (state.ordersState.ordersPage <= 15) {
                              store.dispatch(SetLimitedOrdersPage(page: state.ordersState.limitedOrdersPage - 1));
                            }
                          }
                          store.dispatch(GetOrdersAction(context: context));
                        },
                        icon: Icon(Icons.arrow_forward, size: 40, color: kmColors),
                      ),
                    ],
                  ),
                  if (Services.hasRole(context, agentRole))
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        DropdownButton(
                          value: state.ordersState.warehouseFilter,
                          items: warehouses
                              .map((warehouse) => DropdownMenuItem<int>(
                                  child: Center(child: Text(warehouse.name, style: dropdownItemStyle)),
                                  value: warehouse.id))
                              .toList(),
                          onChanged: (value) {
                            store.dispatch(SetWarehouseFilter(filter: value));
                            store.dispatch(SetOrdersPage(page: 1));
                            store.dispatch(SetLimitedOrdersPage(page: 1));
                            store.dispatch(GetOrdersAction(context: context));
                          },
                        ),
                        SizedBox(
                          height: 30,
                          child: EntryField(
                            edgeInsetsGeometry: EdgeInsets.zero,
                            controller: pageController,
                            onChange: () {},
                            onSubmit: (notEmpty) {
                              if (notEmpty) {
                                if (int.parse(pageController.text) > 0) {
                                  store.dispatch(SetOrdersPage(page: int.parse(pageController.text)));
                                  if (state.ordersState.ordersPage <= 15) {
                                    store.dispatch(SetLimitedOrdersPage(page: int.parse(pageController.text)));
                                  }
                                  store.dispatch(GetOrdersAction(context: context));
                                }
                              }
                            },
                            width:51 ,
                          ),
                        ),
                      ],
                    )
                ],
              ),
            ),
          ],
        );
      },
    );
  }
}
