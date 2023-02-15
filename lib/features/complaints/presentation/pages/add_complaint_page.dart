import 'package:kammun_app/features/complaints/domain/entities/complaint_entity.dart';
import 'package:kammun_app/features/complaints/presentation/redux/complaints_action.dart';

import '../../../../core/core_importer.dart';

class AddComplaintPage extends StatefulWidget {
  static const String routeName = '/AddComplaintPage';
  final OrdersOriginalData orderData;
  const AddComplaintPage({Key key, this.orderData}) : super(key: key);

  @override
  _AddComplaintPageState createState() => _AddComplaintPageState();
}

class _AddComplaintPageState extends State<AddComplaintPage> {
  TextEditingController description = TextEditingController();
  int fault = 0;
  int admin = 0;
  int supplier = 0;
  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, AppState>(
      converter: (store) => store.state,
      distinct: true,
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(title: Text('إضافة شكوى', style: mainStyle), backgroundColor: kmColors),
          body: TemporaryLoading(
            child: SafeArea(
              child: Column(
                children: [
                  Expanded(
                    child: SingleChildScrollView(
                      physics: const AlwaysScrollableScrollPhysics(parent: BouncingScrollPhysics()),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            DropdownButton(items: const [], onChanged: (value) {}),
                            Padding(padding: const EdgeInsets.all(8.0), child: Text('توصيف', style: informationStyle)),
                            TextFormField(
                              controller: description,
                              textAlign: TextAlign.right,
                              cursorColor: kmColors,
                              decoration: InputDecoration(
                                floatingLabelStyle: mainStyle.copyWith(fontSize: 30, color: kmColors),
                                labelStyle: mainStyle.copyWith(fontSize: 30),
                                hintStyle: mainStyle.copyWith(color: Colors.black45),
                                enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(color: kmColors), borderRadius: BorderRadius.circular(5.0)),
                                border: OutlineInputBorder(
                                    borderSide: BorderSide(color: kmColors), borderRadius: BorderRadius.circular(5.0)),
                                focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(color: kmColors), borderRadius: BorderRadius.circular(5.0)),
                              ),
                              keyboardType: TextInputType.multiline,
                              maxLines: 5,
                              style: mainStyle,
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                children: [
                                  Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text('مسبب المشكلة', style: informationStyle)),
                                  DropdownButton(
                                    items: Services.dropdownStringList(['الكابتن', 'المورد', 'غير']),
                                    onChanged: (value) => setState(() => fault = value),
                                    value: fault,
                                  ),
                                ],
                              ),
                            ),
                            if (fault == 1)
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Row(
                                  children: [
                                    Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Text('المورد', style: informationStyle)),
                                    DropdownButton(
                                      items: Services.dropdownStringList(widget.orderData?.orderAccountingRows
                                              ?.map((row) => row.subWarehouseName)
                                              ?.toList() ??
                                          LoadingScreenServices.subWarehouses
                                              .map((subWarehouse) => subWarehouse.name)
                                              .toList()),
                                      onChanged: (value) => setState(() => supplier = value),
                                      value: supplier,
                                    ),
                                  ],
                                ),
                              ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                children: [
                                  Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text('إسناد ل', style: informationStyle)),
                                  DropdownButton(
                                    items: Services.dropdownStringList(['الكابتن', 'المورد', 'غير']),
                                    onChanged: (value) => setState(() => admin = value),
                                    value: admin,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: KammunButton(
                        color: kmColors,
                        onTap: () => StoreProvider.of<AppState>(context)
                            .dispatch(CreateComplaintAction(complaintEntity: ComplaintEntity())),
                        text: 'إضافة',
                        height: 50),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
