import 'package:call_log/call_log.dart';
import '../../../../core/core_importer.dart';
import '../../search_order_services.dart';
import '../redux/search_orders_action.dart';

class SearchOrderByPhoneNumber extends StatelessWidget {
  final Function onChoose;
  final BuildContext context;
  final TextEditingController idController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();

  SearchOrderByPhoneNumber({Key key, this.onChoose, this.context}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var store = StoreProvider.of<AppState>(context);
    return IconButton(
      onPressed: () {
        showMyDialog(
          context: context,
          title: 'طلبات الرقم',
          content: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: Row(
                  children: [
                    IconButton(
                      onPressed: () {
                        if (idController.text.isNotEmpty) {
                          onChoose();
                          Navigator.of(context).pop();
                          store.dispatch(SetId(id: int.parse(idController.text)));
                          store.dispatch(SearchOrderAction(searchOrdersType: SearchOrdersTypes.id, context: context));
                        }
                      },
                      icon: Icon(Icons.search_rounded, size: 40, color: kmColors),
                    ),
                    Expanded(
                      child: EntryField(
                        controller: idController,
                        width: MediaQuery.of(context).size.width,
                        onChange: () {},
                        hint: 'رقم الطلب',
                        onSubmit: (notEmpty) {
                          if (notEmpty) {
                            onChoose();
                            Navigator.of(context).pop();
                            store.dispatch(SetId(id: int.parse(idController.text)));
                            store.dispatch(SearchOrderAction(searchOrdersType: SearchOrdersTypes.id, context: context));
                          }
                        },
                      ),
                    ),
                  ],
                ),
              ),
              Row(
                children: [
                  IconButton(
                    onPressed: () {
                      if (phoneController.text.isNotEmpty) {
                        onChoose();
                        Navigator.of(context).pop();
                        store.dispatch(SetPhoneNumber(phoneNumber: phoneController.text));
                        store.dispatch(
                            SearchOrderAction(searchOrdersType: SearchOrdersTypes.phoneNumber, context: context));
                      }
                    },
                    icon: Icon(Icons.search_rounded, size: 40, color: kmColors),
                  ),
                  Expanded(
                    child: EntryField(
                      controller: phoneController,
                      width: MediaQuery.of(context).size.width,
                      onChange: () {},
                      hint: 'رقم الزبون',
                      onSubmit: (notEmpty) {
                        if (phoneController.text.isNotEmpty) {
                          onChoose();
                          Navigator.of(context).pop();
                          store.dispatch(SetPhoneNumber(phoneNumber: phoneController.text));
                          store.dispatch(
                              SearchOrderAction(searchOrdersType: SearchOrdersTypes.phoneNumber, context: context));
                        }
                      },
                    ),
                  ),
                ],
              ),
            ],
          ),
          dialogButtons: [
            const CloseWidget(),
            DialogButton(
              text: 'اختيار من السجل',
              onTap: () async {
                List<CallLogEntry> cLog = await callbackDispatcher();
                showMyDialog(
                  context: context,
                  title: 'اختيار رقم',
                  dialogButtons: [const CloseWidget()],
                  content: SizedBox(
                    height: 500,
                    width: 500,
                    child: ListView.builder(
                      physics: const AlwaysScrollableScrollPhysics(parent: BouncingScrollPhysics()),
                      primary: false,
                      scrollDirection: Axis.vertical,
                      shrinkWrap: true,
                      itemCount: cLog == null ? 0 : cLog.length,
                      itemBuilder: (BuildContext context1, int index) {
                        return PhoneNumberWidget(
                            phoneNumber: cLog[index].number, userName: cLog[index].name, onChoose: () => onChoose());
                      },
                    ),
                  ),
                );
              },
            ),
          ],
        );
      },
      icon: Icon(Icons.search_rounded, size: 30, color: kmColors),
    );
  }
}
