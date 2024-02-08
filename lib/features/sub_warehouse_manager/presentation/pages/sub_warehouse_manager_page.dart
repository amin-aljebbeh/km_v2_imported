import 'package:kammun_app/features/inventory/presentation/redux/inventory_action.dart';

import '../../../../core/core_importer.dart';
import '../redux/sub_warehouse_manager_action.dart';

class SubWarehouseManagerPage extends StatelessWidget {
  const SubWarehouseManagerPage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, AppState>(
      converter: (store) => store.state,
      distinct: true,
      builder: (context, state) {
        return TemporaryLoading(
          child: Scaffold(
            backgroundColor: Theme.of(context).scaffoldBackgroundColor,
            appBar: AppBar(
                backgroundColor: primaryColor, title: Text(kammun, style: boldStyle.copyWith(color: Colors.white))),
            body: Container(
              child: state.loadingState.loading.isNotEmpty
                  ? const Loader()
                  : Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: ListView(
                        children: [
                          Text('يرجى إختيار المستودع', style: boldStyle),
                          ListTile(
                            contentPadding: const EdgeInsets.symmetric(horizontal: 10),
                            title: Column(
                              children: state.generalInformationState.subWarehouses
                                  .map((data) => Container(
                                        decoration: BoxDecoration(color: Theme.of(context).scaffoldBackgroundColor),
                                        child: RadioListTile(
                                          controlAffinity: ListTileControlAffinity.trailing,
                                          activeColor: Theme.of(context).primaryColor,
                                          title: Text(data.name, style: mainStyle),
                                          groupValue: state.excelInventoryState.subWarehouseId,
                                          value: data.id,
                                          onChanged: (val) {
                                            StoreProvider.of<AppState>(context)
                                                .dispatch(SetSubWarehouseId(subWarehouseId: data.id));
                                          },
                                        ),
                                      ))
                                  .toList(),
                            ),
                          ),
                          KammunButton(
                            height: 50,
                            padding: const EdgeInsets.only(bottom: 10),
                            text: 'استعراض المستودع',
                            color: state.excelInventoryState.subWarehouseId != null
                                ? Theme.of(context).primaryColor
                                : searchGreyColor,
                            onTap: () {
                              if (state.excelInventoryState.subWarehouseId != null) {
                                StoreProvider.of<AppState>(context).dispatch(GoToInventoryPage(
                                    context: context,
                                    inventoryType: InventoryTypes.subWarehouse,
                                    subWarehouseId: state.excelInventoryState.subWarehouseId));
                              } else {
                                Toast.show('يرجى اختيار المستودع', context,
                                    duration: Toast.LENGTH_LONG, gravity: Toast.CENTER);
                              }
                            },
                          ),
                          if (!Services.hasRole(context, supplierRole))
                            KammunButton(
                              height: 50,
                              padding: const EdgeInsets.only(bottom: 10),
                              text: 'رفع ملف الجرد',
                              color: state.excelInventoryState.subWarehouseId != null
                                  ? Theme.of(context).primaryColor
                                  : searchGreyColor,
                              onTap: () {
                                if (state.excelInventoryState.subWarehouseId != null) {
                                  StoreProvider.of<AppState>(context).dispatch(PickFileAction(context: context));
                                } else {
                                  Toast.show('يرجى اختيار المستودع', context,
                                      duration: Toast.LENGTH_LONG, gravity: Toast.CENTER);
                                }
                              },
                            ),
                          if (Services.hasPermission(context, targetInventoryPermission))
                            KammunButton(
                              padding: const EdgeInsets.only(bottom: 10),
                              height: 50,
                              text: 'رفع جرد تارغت',
                              color: primaryColor,
                              onTap: () =>
                                  StoreProvider.of<AppState>(context).dispatch(TargetInventoryAction(context: context)),
                            ),
                          if (Services.hasRole(context, superAdminRole))
                            KammunButton(
                              height: 50,
                              padding: const EdgeInsets.only(bottom: 10),
                              text: 'جرد عام لتقييم الجرد',
                              color: primaryColor,
                              onTap: () => StoreProvider.of<AppState>(context)
                                  .dispatch(KeepingInventoriesRecordAction(context: context)),
                            ),
                          if (Services.hasRole(context, adminRole))
                            UpdateProductInfoWidget(
                              isForPriceRate: true,
                              ctx: context,
                              title: ' عتبة التقييم:',
                              textHint: 'تقييم الأسعار',
                              inputType: TextInputType.number,
                              bodyKey: 'rate',
                              productId: 0,
                              isForSubWarehouse: false,
                              initialText: '50',
                            )
                        ],
                      ),
                    ),
            ),
          ),
        );
      },
    );
  }
}
