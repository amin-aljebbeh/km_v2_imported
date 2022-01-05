import 'package:flutter/material.dart';
import 'package:kammun_app/utils/utils_importer.dart';
import 'package:kammun_app/views/Wedgit/text_field_row.dart';
import 'package:kammun_app/views/Wedgit/widgets_importer.dart';
import 'package:intl/intl.dart';
import 'package:toast/toast.dart';
import '../../Services.dart';

class AddTransactionView extends StatefulWidget {
  @override
  _AddTransactionViewState createState() => _AddTransactionViewState();
}

class _AddTransactionViewState extends State<AddTransactionView> {
  String shopperFilter;
  int transactionType;
  final DateFormat fullDateFormatter = DateFormat('yyyy-MM-dd HH:mm:ss');
  String transactionDate = '';
  final moneyController = TextEditingController();
  final descriptionController = TextEditingController();

  @override
  void initState() {
    transactionDate = fullDateFormatter.format(DateTime.now()).toString();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColorLight,
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text(
          'إضافة مناقلة',
          style: mainStyle,
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.only(left: 20, top: 0, right: 20, bottom: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 20,
              ),
              KSearchableDropdown(
                hint: StringUtils.chooseShopper,
                search: shopperFilter,
                items: Services.shoppersNameList(),
                onChanged: (value) {
                  //TODO: request api
                  setState(
                    () {
                      shopperFilter = value;
                    },
                  );
                },
              ),
              SizedBox(
                height: 20,
              ),
              Container(
                width: MediaQuery.of(context).size.width,
                child: DropdownButton(
                  underline: Container(),
                  isExpanded: true,
                  hint: Center(
                    child: Text(
                      'نوع المناقلة',
                      style: dropdownItemStyle,
                    ),
                  ),
                  value: transactionType,
                  items: Services.dropdownStringList(
                      StringUtils.singleTransactionTypes),
                  onChanged: (value) {
                    setState(() {
                      transactionType = value;
                    });
                  },
                ),
              ),
              // SizedBox(
              //   height: 20,
              // ),
              // Row(
              //   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              //   children: [
              //     Text(
              //       "تاريخ المناقلة",
              //       style:
              //           TextStyle(fontFamily: StringUtils.fontFamilyHKGrotesk),
              //     ),
              //     IconButton(
              //       icon: Icon(Icons.calendar_today_outlined),
              //       onPressed: () {
              //         DatePicker.showDateTimePicker(context,
              //             showTitleActions: true,
              //             onChanged: (date) {}, onConfirm: (date) {
              //           setState(
              //             () {
              //               transactionDate =
              //                   fullDateFormatter.format(date).toString();
              //             },
              //           );
              //         }, currentTime: DateTime.now(), locale: 'en');
              //       },
              //     ),
              //     Text(
              //       transactionDate,
              //       style:
              //           TextStyle(fontFamily: StringUtils.fontFamilyHKGrotesk),
              //     ),
              //   ],
              // ),
              SizedBox(
                height: 30,
              ),
              TextFieldRow(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                controller: moneyController,
                text: 'المبلغ :',
                inputType: TextInputType.number,
                width: 150,
              ),
              SizedBox(
                height: 40,
              ),
              TextFieldRow(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                controller: descriptionController,
                text: 'الوصف :',
                inputType: TextInputType.multiline,
                width: MediaQuery.of(context).size.width * 0.65,
              ),
              SizedBox(
                height: 20,
              ),
              KammunButton(
                height: 50,
                text: 'حفظ المناقلة',
                color: !completeData()
                    ? ColorUtils.searchGreyColor
                    : ColorUtils.primaryColor,
                onTap: () {
                  if (!completeData()) {
                    Toast.show("يرجى إدخال كافة البيانات", context,
                        duration: Toast.LENGTH_LONG, gravity: Toast.CENTER);
                  } else {
                    String description = descriptionController.text.isNotEmpty
                        ? descriptionController.text
                        : ' ';
                    //TODO: request post transaction api instead
                    Toast.show("تمت", context,
                        duration: Toast.LENGTH_LONG, gravity: Toast.CENTER);
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  bool completeData() {
    if (transactionType != null) {
      if (transactionType == 0)
        return shopperFilter != null &&
            moneyController.text.isNotEmpty &&
            descriptionController.text.isNotEmpty;
      else
        return shopperFilter != null && moneyController.text.isNotEmpty;
    } else {
      return false;
    }
  }
}
