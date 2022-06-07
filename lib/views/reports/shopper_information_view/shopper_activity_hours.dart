import 'package:flutter/material.dart';
import 'package:kammun_app/views/reports/shopper_information_view/active_hours_widget.dart';

import '../../../service.dart';
import '../../../utils/utils_importer.dart';
import '../../Widget/widgets_importer.dart';
import '../models/activity_hours_model.dart';
import '../services/reports_services.dart';

class ActivityHoursView extends StatefulWidget {
  static const String routeName = '/ActivityHoursView';
  const ActivityHoursView({Key key}) : super(key: key);

  @override
  _ActivityHoursViewState createState() => _ActivityHoursViewState();
}

class _ActivityHoursViewState extends State<ActivityHoursView> {
  String fromDateTimeValue;
  String toDateTimeValue;
  List<ActivityHoursModel> activityHours = [];
  String shopperName;

  bool newDay(int index) {
    if (index == 0) return true;
    return activityHours[index].startWorkAt.toString().split(' ')[0] !=
        activityHours[index - 1].startWorkAt.toString().split(' ')[0];
  }

  getHours({String shopperId}) async {
    setState(() {
      isError = false;
      isLoading = true;
    });

    var response = await ReportsServices.getShopperActivityHours(
        shopperId: shopperId, fromDate: fromDateTimeValue, toDate: toDateTimeValue);
    if (response != null) {
      activityHours = response.data;

      setState(() => isLoading = false);
    } else {
      setState(() {
        isLoading = false;
        isError = true;
      });
    }
  }

  bool isLoading = false;
  bool isError = false;
  @override
  void initState() {
    fromDateTimeValue = 'يرجى أختيار تاريخ البداية';
    toDateTimeValue = 'يرجى إختيار تاريخ النهاية';
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar:
            AppBar(backgroundColor: ColorUtils.primaryColor, title: Text('أوقات تفعيل التطبيق', style: mainStyle)),
        body: SafeArea(
          child: Container(
            padding: const EdgeInsets.all(10),
            child: ListView(
              padding: const EdgeInsets.only(bottom: 25),
              shrinkWrap: true,
              children: [
                if (!Services.isShopper())
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.75,
                    child: KSearchableDropdown(
                      hint: StringUtils.chooseShopper,
                      search: shopperName,
                      items: Services.shoppersNameList(),
                      onChanged: (value) {
                        setState(() {
                          shopperName = value;
                          if (validDates()) {
                            getHours(shopperId: Services.selectedShopperId(shopperName));
                            isLoading = true;
                          }
                        });
                      },
                    ),
                  ),
                KDatePicker(
                  onConfirmStart: (date) => setState(() => fromDateTimeValue = date),
                  onConfirmEnd: (date) => setState(() => toDateTimeValue = date),
                ),
                KammunButton(
                  text: StringUtils.send,
                  color: validDates() ? Theme.of(context).primaryColor : ColorUtils.searchGreyColor,
                  onTap: () {
                    if (validDates() && (Services.isShopper() || shopperName != null)) {
                      getHours(
                          shopperId: Services.isShopper()
                              ? Services.shopper.id.toString()
                              : Services.selectedShopperId(shopperName));
                    } else {
                      Toast.show('الرجاء إدخال كافة البيانات', context,
                          duration: Toast.LENGTH_LONG, gravity: Toast.CENTER);
                    }
                  },
                  height: 50,
                ),
                const SizedBox(height: 20),
                isError
                    ? AlertMessages(text: StringUtils.errorMessage, messageType: 'internetError')
                    : Container(),
                isLoading
                    ? const Loader()
                    : activityHours.isEmpty
                        ? const Padding(padding: EdgeInsets.all(75), child: ScreenMessage(message: 'لا يوجد حركة'))
                        : SizedBox(
                            height: MediaQuery.of(context).size.height * 0.56,
                            child: ListView.builder(
                              scrollDirection: Axis.vertical,
                              itemCount: activityHours.length,
                              itemBuilder: (BuildContext context, int index) {
                                return ActiveHoursWidget(
                                    activityHour: activityHours[index], newDay: newDay(index));
                              },
                            ))
              ],
            ),
          ),
        ),
      ),
    );
  }

  bool validDates() {
    return fromDateTimeValue != 'يرجى أختيار تاريخ البداية' && toDateTimeValue != 'يرجى إختيار تاريخ النهاية';
  }
}
