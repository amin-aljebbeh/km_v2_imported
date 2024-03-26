import 'package:kammun_app/features/orders/presentation/pages/orders_page.dart';

import '../../../../core/core_importer.dart';
import '../redux/search_orders_action.dart';

class SearchOrdersFilterWidget extends StatelessWidget {
  const SearchOrdersFilterWidget({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var store = StoreProvider.of<AppState>(context);
    return StoreConnector<AppState, AppState>(
      converter: (store) => store.state,
      distinct: true,
      builder: (context, state) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(bottom: 10.0),
              child: IconButton(
                icon: Icon(Icons.arrow_back_ios_rounded, color: kmColors, size: 45),
                onPressed: () {

                  Navigator.push(context, MaterialPageRoute(builder: (screenContext) => const HomePage()));
                  store.dispatch(SetSearchPage(page: 1));
                },
              ),
            ),
            if (state.searchOrdersState.searchOrdersType == SearchOrdersTypes.phoneNumber)
              DropdownButton(
                value: state.searchOrdersState.statusFilter,
                items: Services.dropdownStringList(phoneOrderStatus),
                onChanged: (value) {
                  store.dispatch(SetSearchStatusFilter(filter: value));
                  store.dispatch(
                      SearchOrderAction(searchOrdersType: state.searchOrdersState.searchOrdersType, context: context));
                },
              ),
            SearchOrderByPhoneNumber(context: context, onChoose: () => Navigator.of(context).pop()),
            if (state.searchOrdersState.searchOrdersType == SearchOrdersTypes.phoneNumber)
              Padding(
                padding: const EdgeInsets.only(bottom: 15),
                child: IconButton(
                  onPressed: () {
                    if (state.searchOrdersState.page < 14) {
                      store.dispatch(SetSearchPage(page: state.searchOrdersState.page + 1));
                    }
                    store.dispatch(SearchOrderAction(
                        context: context, searchOrdersType: state.searchOrdersState.searchOrdersType));
                  },
                  icon: Icon(Icons.arrow_back, size: 40, color: kmColors),
                ),
              ),
            if (state.searchOrdersState.searchOrdersType == SearchOrdersTypes.phoneNumber)
              DropdownButton(
                value: state.searchOrdersState.page,
                items: Services.dropdownIntList(inputList: dropdownValues),
                onChanged: (value) {
                  store.dispatch(SetSearchPage(page: value));
                  store.dispatch(
                      SearchOrderAction(context: context, searchOrdersType: state.searchOrdersState.searchOrdersType));
                },
              ),
            if (state.searchOrdersState.searchOrdersType == SearchOrdersTypes.phoneNumber)
              Padding(
                padding: const EdgeInsets.only(bottom: 15),
                child: IconButton(
                  onPressed: () {
                    if (state.searchOrdersState.page > 1) {
                      store.dispatch(SetSearchPage(page: state.searchOrdersState.page - 1));
                    }
                    store.dispatch(SearchOrderAction(
                        context: context, searchOrdersType: state.searchOrdersState.searchOrdersType));
                  },
                  icon: Icon(Icons.arrow_forward, size: 40, color: kmColors),
                ),
              ),
          ],
        );
      },
    );
  }
}
