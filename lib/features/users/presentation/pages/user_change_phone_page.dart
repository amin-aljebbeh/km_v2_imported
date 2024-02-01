import 'package:kammun_app/features/transactions/presentation/redux/transactions_action.dart';
import 'package:kammun_app/features/users/presentation/redux/users_action.dart';

import '../../../../core/core_importer.dart';
import '../../../orders/domain/entities/order_entity.dart';
import '../../../profile/widgets/profile_container.dart';
import '../../../transactions/domain/entities/admin_transaction_entity.dart';

class ChangeNamberPhoneUser extends StatefulWidget {
  final OrderEntity order;

  const ChangeNamberPhoneUser({Key key, this.order}) : super(key: key);

  @override
  _ChangeNamberPhoneUserState createState() => _ChangeNamberPhoneUserState();
}

class _ChangeNamberPhoneUserState extends State<ChangeNamberPhoneUser> {
  final formkey = GlobalKey<FormState>();
  bool allow = false;

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, AppState>(
      converter: (store) => store.state,
      distinct: true,
      builder: (context, state) {
        final TextEditingController phoneController =
            TextEditingController(text: widget.order.user.phone);

        return TemporaryLoading(
          child: Scaffold(
            body: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.only(bottom: 10, top: 120),
                    child: ProfileContainer(
                      title: '  تغيير رقم الزبون',
                      child: SizedBox(
                          width: MediaQuery.of(context).size.width,
                          child: Form(
                              key: formkey,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                //mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Directionality(
                                      textDirection: TextDirection.ltr,
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: TextFormField(
                                          maxLength: 10,
                                          enabled: allow,
                                          controller: phoneController,
                                          autofocus: false,
                                          style: const TextStyle(
                                              fontSize: 20,
                                              color:
                                                  Color.fromARGB(255, 0, 0, 0)),
                                          decoration: InputDecoration(
                                            filled: true,
                                            hintText: "Phone Number",
                                            focusedBorder: OutlineInputBorder(
                                              borderSide: const BorderSide(
                                                  color: Colors.white),
                                              borderRadius:
                                                  BorderRadius.circular(12),
                                            ),
                                            enabledBorder: OutlineInputBorder(
                                              borderSide: BorderSide(
                                                  color: (allow ?? false)
                                                      ? kmColors
                                                      : kmColors,
                                                  width: 0.5),
                                              borderRadius:
                                                  BorderRadius.circular(12),
                                            ),
                                            prefixIcon: Icon(Icons.call,
                                                color: kmColors),
                                          ),
                                        ),
                                      )),
                                ],
                              ))),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.only(
                        left: 20.0, right: 20, bottom: 20, top: 10),
                    child: KammunButton(
                        text: (allow ?? false) ? 'حفظ' : 'تغيير رقم الزبون',
                        height: 50,
                        color: (allow ?? false)
                            ? kmColors
                            : Colors.grey.withOpacity(0.5),
                        onTap: () {
                          if (allow ?? false) {
                            if (phoneController.text.isEmpty) {
                              snackBar(
                                  context: context,
                                  message: 'يرجى إدخال رقم الزبون',
                                  success: false);
                              FocusScope.of(context).requestFocus(FocusNode());
                            } else if (phoneController.text.isNotEmpty &&
                                phoneController.text.length == 10) {
                              if (phoneController.text.startsWith("09")) {
                                setState(() {
                                  // Update the phone number directly in the state
                                  widget.order.user.phone =
                                      phoneController.text;
                                });
                                StoreProvider.of<AppState>(context).dispatch(
                                    ChangeNumberPhoneUserAction(
                                        context: context,
                                        phoneNumber: phoneController.text));
                                FocusScope.of(context)
                                    .requestFocus(FocusNode());
                              } else {
                                snackBar(
                                    context: context,
                                    message:
                                        'يرجى التأكد من أن رقم الهاتف يبدأ بـ 09',
                                    success: false);
                                FocusScope.of(context)
                                    .requestFocus(FocusNode());
                              }
                            } else {
                              snackBar(
                                  context: context,
                                  message:
                                      'يرجى التأكد من أن رقم الهاتف 10 أرقام',
                                  success: false);
                              FocusScope.of(context).requestFocus(FocusNode());
                            }
                          } else {
                            setState(() {
                              allow = true;
                            });
                          }
                        }),
                  )
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
