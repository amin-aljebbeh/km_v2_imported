import 'package:call_log/call_log.dart';
import 'package:flutter/material.dart';
import 'package:kammun_app/utils/utils_importer.dart';
import 'package:kammun_app/views/orders/services/order_services.dart';

import 'widgets_importer.dart';

class SearchOrderByPhoneNumber extends StatefulWidget {
  final TextEditingController controller;
  final Function(String) onChoose;
  final BuildContext context;

  SearchOrderByPhoneNumber({Key key, this.controller, this.onChoose, this.context}) : super(key: key);

  @override
  _SearchOrderByPhoneNumberState createState() => _SearchOrderByPhoneNumberState();
}

class _SearchOrderByPhoneNumberState extends State<SearchOrderByPhoneNumber> {
  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () {
        showMyDialog(
          title: 'طلبات الرقم',
          context: context,
          content: EntryField(
            controller: widget.controller,
            width: MediaQuery.of(context).size.width / 3,
            hint: 'رقم الزبون',
            onSubmit: (notEmpty) {
              Navigator.of(context).pop();
            },
            canBeEmpty: true,
            isPhoneNumber: true,
          ),
          dialogButtons: [
            DialogButton(
              text: StringUtils.close,
              onTap: () {
                Navigator.of(context).pop();
              },
            ),
            DialogButton(
              text: StringUtils.search,
              onTap: () {
                if (widget.controller.text.isNotEmpty) {
                  Navigator.of(context).pop();
                  widget.onChoose(widget.controller.text);
                }
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
                  content: Container(
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
                            widget.onChoose(cLog[index].number);
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
