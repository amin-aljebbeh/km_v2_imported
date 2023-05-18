import 'package:call_log/call_log.dart';
import 'package:kammun_app/features/orders/order_by_id.dart';
import 'package:kammun_app/features/orders/services/order_services.dart';

import '../../core/core_importer.dart';
import '../../features/orders/orders_view_importer.dart';

class SearchOrderByPhoneNumber extends StatelessWidget {
  final Function onChoose;
  final BuildContext context;
  final TextEditingController idController;
  final TextEditingController phoneController;

  const SearchOrderByPhoneNumber({Key key, this.onChoose, this.context, this.idController, this.phoneController})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
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
                          Navigator.push(
                              context, MaterialPageRoute(builder: (context) => OrderByID(id: idController.text)));
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
                            Navigator.push(
                                context, MaterialPageRoute(builder: (context) => OrderByID(id: idController.text)));
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
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => PhoneNumberOrdersView(phoneNumber: phoneController.text)));
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
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => PhoneNumberOrdersView(phoneNumber: phoneController.text)));
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
                List<CallLogEntry> cLog = await OrderServices.callbackDispatcher();
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
                        return GestureDetector(
                          onTap: () {
                            Navigator.of(context).pop();
                            Navigator.of(context).pop();
                            onChoose();
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => PhoneNumberOrdersView(phoneNumber: cLog[index].number)));
                          },
                          child: PhoneNumberWidget(phoneNumber: cLog[index].number, userName: cLog[index].name),
                        );
                      },
                    ),
                  ),
                );
              },
            ),
          ],
        );
      },
      icon: Icon(Icons.search_rounded, size: 40, color: kmColors),
    );
  }
}
