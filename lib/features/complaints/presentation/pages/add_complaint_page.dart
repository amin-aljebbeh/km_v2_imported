import 'package:kammun_app/features/loading_feature/presentation/pages/temporary_loading.dart';

import '../../../../core/core_importer.dart';

class AddComplaintPage extends StatefulWidget {
  static const String routeName = '/AddComplaintPage';
  const AddComplaintPage({Key key}) : super(key: key);

  @override
  _AddComplaintPageState createState() => _AddComplaintPageState();
}

class _AddComplaintPageState extends State<AddComplaintPage> {
  TextEditingController description = TextEditingController();
  int fault = 0;
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
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: ListView(
                  physics: const AlwaysScrollableScrollPhysics(parent: BouncingScrollPhysics()),
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          DropdownButton(items: const [], onChanged: (value) {}),
                          Padding(padding: const EdgeInsets.all(8.0), child: Text('توصيف', style: informationStyle)),
                          Container(
                            padding: const EdgeInsets.only(left: 8, right: 8),
                            decoration: BoxDecoration(
                                borderRadius: const BorderRadius.all(Radius.circular(5.0)),
                                border: Border.all(width: 2, color: kmColors)),
                            child: TextField(
                              controller: description,
                              textAlign: TextAlign.right,
                              cursorColor: kmColors,
                              keyboardType: TextInputType.multiline,
                              maxLines: 5,
                              style: TextStyle(fontFamily: fontFamily),
                            ),
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
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              children: [
                                Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text('إسناد ل', style: informationStyle)),
                                DropdownButton(
                                  items: Services.dropdownStringList(['الكابتن', 'المورد', 'غير']),
                                  onChanged: (value) => setState(() => fault = value),
                                  value: fault,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: KammunButton(color: kmColors, onTap: () {}, text: 'إضافة', height: 50),
                    ),
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
