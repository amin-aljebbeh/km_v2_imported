import '../../../../core/core_importer.dart';
import '../redux/inventory_action.dart';

class InventoryFilterWidget extends StatefulWidget {
  const InventoryFilterWidget({Key key}) : super(key: key);

  @override
  _InventoryFilterWidgetState createState() => _InventoryFilterWidgetState();
}

class _InventoryFilterWidgetState extends State<InventoryFilterWidget> {
  int subWarehouseFilter;
  final List<String> activeList = ['بحاجة تفعيل', 'بحاجة إيقاف تفعيل', 'الجميع'];

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      subWarehouseFilter = StoreProvider.of<AppState>(context).state.generalInformationState.subWarehouses.length;
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var store = StoreProvider.of<AppState>(context);
    return StoreConnector<AppState, AppState>(
      converter: (store) => store.state,
      distinct: true,
      builder: (context, state) {
        var inventoryState = state.inventoryState;
        return SizedBox(
          width: MediaQuery.of(context).size.width,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              DropdownButton(
                value: subWarehouseFilter,
                items: Services.inventorySubWarehouseNames(context),
                onChanged: (value) {
                  subWarehouseFilter = value;
                  store.dispatch(SetSubWarehouseId(
                      subWarehouseId: value != state.generalInformationState.subWarehouses.length
                          ? state.generalInformationState.subWarehouses[value].id
                          : -1));
                  store.dispatch(InitialInventory());
                },
              ),
              DropdownButton(
                value: inventoryState.isActive,
                items: Services.dropdownStringList(activeList),
                onChanged: (value) {
                  store.dispatch(SetIsActive(isActive: value));
                  store.dispatch(InitialInventory());
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
