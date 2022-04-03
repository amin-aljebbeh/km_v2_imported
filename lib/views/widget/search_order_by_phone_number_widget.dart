import 'package:call_log/call_log.dart';
import 'package:flutter/material.dart';
import 'package:kammun_app/utils/utils_importer.dart';
import 'package:kammun_app/views/orders/order_by_id.dart';
import 'package:kammun_app/views/orders/services/order_services.dart';

import '../orders/phone_number_order.dart';
import 'widgets_importer.dart';

class SearchOrderByPhoneNumber extends StatefulWidget {
  final TextEditingController idController;
  final TextEditingController phoneController;
  final Function onChoose;
  final BuildContext context;

  SearchOrderByPhoneNumber({
    Key key,
    this.onChoose,
    this.context,
    this.idController,
    this.phoneController,
  }) : super(key: key);

  @override
  _SearchOrderByPhoneNumberState createState() => _SearchOrderByPhoneNumberState();
}

class _SearchOrderByPhoneNumberState extends State<SearchOrderByPhoneNumber> {
  // GlobalKey<FormState> idFormKey = GlobalKey<FormState>();
  // GlobalKey<FormState> phoneFormKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () {
        showMyDialog(
          title: 'طلبات الرقم',
          context: context,
          content: Column(
            children: [
              Padding(
                padding: EdgeInsets.only(bottom: 8.0),
                child: Row(
                  children: [
                    IconButton(
                      onPressed: () {
                        if (widget.idController.text.isNotEmpty) {
                          // widget.idController.clear();
                          widget.onChoose();
                          Navigator.of(context).pop();
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => OrderByID(
                                id: widget.idController.text,
                              ),
                            ),
                          );
                        }
                      },
                      icon: Icon(
                        Icons.search_rounded,
                        size: 40,
                        color: ColorUtils.kmColors,
                      ),
                    ),
                    Expanded(
                      child: EntryField(
                        controller: widget.idController,
                        width: MediaQuery.of(context).size.width,
                        hint: 'رقم الطلب',
                        onSubmit: (notEmpty) {
                          if (notEmpty) {
                            // widget.idController.clear();
                            Tools.logToConsole(widget.idController.text);

                            widget.onChoose();
                            Navigator.of(context).pop();

                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => OrderByID(
                                  id: widget.idController.text,
                                ),
                              ),
                            );
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
                      Tools.logToConsole('tap out');
                      if (widget.phoneController.text.isNotEmpty) {
                        Tools.logToConsole('tap');
                        // widget.idController.clear();
                        widget.onChoose();
                        Navigator.of(context).pop();
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => PhoneNumberOrdersView(
                              phoneNumber: widget.phoneController.text,
                            ),
                          ),
                        );
                      }
                    },
                    icon: Icon(
                      Icons.search_rounded,
                      size: 40,
                      color: ColorUtils.kmColors,
                    ),
                  ),
                  Expanded(
                    child: EntryField(
                      controller: widget.phoneController,
                      width: MediaQuery.of(context).size.width,
                      hint: 'رقم الزبون',
                      onSubmit: (notEmpty) {
                        if (notEmpty) {
                          Tools.logToConsole('sasa');
                          // widget.idController.clear();
                          widget.onChoose();
                          Navigator.of(context).pop();
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => PhoneNumberOrdersView(
                                phoneNumber: widget.phoneController.text,
                              ),
                            ),
                          );
                        }
                      },
                    ),
                  ),
                ],
              ),
            ],
          ),
          dialogButtons: [
            DialogButton(
              text: StringUtils.close,
              onTap: () {
                Navigator.of(context).pop();
              },
            ),
            DialogButton(
              text: 'اختيار من السجل',
              onTap: () async {
                List<CallLogEntry> cLog = await OrderServices.callbackDispatcher();
                showMyDialog(
                  title: 'اختيار رقم',
                  context: context,
                  dialogButtons: [
                    DialogButton(
                      text: StringUtils.close,
                      onTap: () {
                        Navigator.of(context).pop();
                      },
                    ),
                  ],
                  content: SizedBox(
                    height: 500,
                    width: 500,
                    child: ListView.builder(
                      physics: AlwaysScrollableScrollPhysics(parent: BouncingScrollPhysics()),
                      primary: false,
                      scrollDirection: Axis.vertical,
                      shrinkWrap: true,
                      itemCount: cLog == null ? 0 : cLog.length,
                      itemBuilder: (BuildContext context1, int index) {
                        return GestureDetector(
                          onTap: () {
                            Navigator.of(context).pop();
                            Navigator.of(context).pop();
                            widget.onChoose();
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => PhoneNumberOrdersView(
                                  phoneNumber: cLog[index].number,
                                ),
                              ),
                            );
                          },
                          child: PhoneNumberWidget(
                            phoneNumber: cLog[index].number,
                            userName: cLog[index].name,
                          ),
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
      icon: Icon(
        Icons.search_rounded,
        size: 40,
        color: ColorUtils.kmColors,
      ),
    );
  }
}
