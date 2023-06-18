import 'package:file_picker/file_picker.dart';
import 'package:kammun_app/features/general_information/domain/entities/sub_warehouse_entity.dart';
import 'package:kammun_app/features/general_information/presentation/redux/general_information_action.dart';
import 'package:kammun_app/features/inventory_feature/presentation/redux/inventory_action.dart';

import '../../../core/core_importer.dart';
import '../../excel_inventory/presentation/pages/excel_inventory_page.dart';
import '../../excel_inventory/presentation/redux/excel_inventory_action.dart';
import '../../login/Services/login_services.dart';

class GetSubWarehouse extends StatefulWidget {
  const GetSubWarehouse({Key key}) : super(key: key);

  @override
  _GetSubWarehouseState createState() => _GetSubWarehouseState();
}

class _GetSubWarehouseState extends State<GetSubWarehouse> {
  bool isLoading = false;
  bool isError = false;

  _getSubWarehouse({BuildContext context}) async {
    setState(() {
      isLoading = true;
      isError = false;
    });

// todo ask for permission to delete this request
    String adminId = StoreProvider.of<AppState>(context).state.adminsState.admin.id.toString();
    List<SubWarehouseEntity> response = await LoginServices.getAdmin(adminId: adminId, context: context);
    StoreProvider.of<AppState>(context).dispatch(SetSubWarehouses(subWarehouses: response));
    if (response != null) {
      setState(() {
        isLoading = false;
        isError = false;
      });
    } else {
      setState(() {
        isLoading = false;
        isError = true;
      });
    }
  }

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _getSubWarehouse(context: context);
      StoreProvider.of<AppState>(context).dispatch(InitExcelInventory());
    });

    super.initState();
  }

  bool selected = false;

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
              child: isLoading
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
                                            setState(() {
                                              selected = true;
                                              StoreProvider.of<AppState>(context)
                                                  .dispatch(SetSubWarehouseId(subWarehouseId: data.id));
                                            });
                                          },
                                        ),
                                      ))
                                  .toList(),
                            ),
                          ),
                          KammunButton(
                            height: 50,
                            text: 'استعراض المستودع',
                            color: selected ? Theme.of(context).primaryColor : searchGreyColor,
                            onTap: () {
                              if (selected) {
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
                              text: 'رفع ملف الجرد',
                              color: selected ? Theme.of(context).primaryColor : searchGreyColor,
                              onTap: () async {
                                if (selected) {
                                  File file = await pickFile();
                                  StoreProvider.of<AppState>(context).dispatch(SetFile(file: file));
                                  if (file != null) {
                                    Navigator.push(
                                        context, MaterialPageRoute(builder: (context) => const ExcelInventoryPage()));
                                  }
                                } else {
                                  Toast.show('يرجى اختيار المستودع', context,
                                      duration: Toast.LENGTH_LONG, gravity: Toast.CENTER);
                                }
                              },
                            ),
                          if (Services.hasPermission(context, targetInventoryPermission))
                            KammunButton(
                              height: 50,
                              text: 'رفع جرد تارغت',
                              color: primaryColor,
                              onTap: () =>
                                  StoreProvider.of<AppState>(context).dispatch(TargetInventoryAction(context: context)),
                            ),
                          if (Services.hasRole(context, superAdminRole))
                            KammunButton(
                              height: 50,
                              text: 'جرد عام لتقييم الجرد',
                              color: primaryColor,
                              onTap: () => StoreProvider.of<AppState>(context)
                                  .dispatch(KeepingInventoriesRecordAction(context: context)),
                            ),
                          const SizedBox(height: 10),
                          if (Services.hasRole(context, adminRole))
                            const UpdateProductInfoWidget(
                              isForPriceRate: true,
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

  Future<File> pickFile() async {
    FilePickerResult result = await FilePicker.platform.pickFiles(
      allowedExtensions: ['xlsx', 'xlsm', 'xlsb', 'xltx', 'xltm', 'xls', 'xlt', 'xls', 'xlw', 'xlr'],
      type: FileType.custom,
    );
    if (result == null) return null;
    return File(result.files[0].path);
  }
}
