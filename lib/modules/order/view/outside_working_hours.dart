import 'package:flutter/material.dart';
import '../../../core/core_importer.dart';
import '../models/submit_order_model.dart';
import '../redux/order_action.dart';

class OutSideWorkingHours extends StatefulWidget {
  final SubmitOrderModel model;
  final String message;
  final String time;
  const OutSideWorkingHours({Key key, this.model, this.message, this.time}) : super(key: key);
  @override
  State<StatefulWidget> createState() => OutSideWorkingHoursState();
}

class OutSideWorkingHoursState extends State<OutSideWorkingHours> {
  int hour;
  int endHour;
  String time;
  String endTime;
  @override
  void initState() {
    time = '';
    endTime = '';
    hour = int.parse(widget.time.substring(0, 2));
    endHour = hour + 1;
    if (hour > 12) hour -= 12;
    if (endHour > 12) endHour -= 12;
    if (hour < 10) time = '0';
    if (endHour < 10) endTime = '0';
    time += hour.toString() + ':' + widget.time.substring(3, 5);
    endTime += endHour.toString() + ':' + widget.time.substring(3, 5);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, AppState>(
      converter: (store) => store.state,
      builder: (context, state) {
        return TemporaryLoading(
            child: Scaffold(
                body: Padding(
                    padding: const EdgeInsets.only(left: 30, top: 0, right: 30, bottom: 10),
                    child: SizedBox(
                        width: double.infinity,
                        height: double.infinity,
                        child: SafeArea(
                            child: SingleChildScrollView(
                                physics: const AlwaysScrollableScrollPhysics(parent: BouncingScrollPhysics()),
                                child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: <Widget>[
                                      Padding(
                                          padding: const EdgeInsets.only(top: 50),
                                          child: Image.asset('assets/working-hours@3x.png',
                                              width: MediaQuery.of(context).size.width * 0.8)),
                                      const SizedBox(height: 50),
                                      KCard(
                                        radius: 6,
                                        child: Padding(
                                          padding: const EdgeInsets.all(10.0),
                                          child: Column(
                                            children: [
                                              RichText(
                                                text: TextSpan(
                                                  children: <TextSpan>[
                                                    TextSpan(
                                                        text: 'تنبيه ',
                                                        style: paragraphStyle.copyWith(color: Colors.red)),
                                                    TextSpan(text: ' طلبك خارج ساعات عملنا', style: paragraphStyle),
                                                  ],
                                                ),
                                              ),
                                              Padding(
                                                  padding: const EdgeInsets.all(5),
                                                  child: Text(widget.message,
                                                      textAlign: TextAlign.center, style: informationStyle)),
                                              Padding(
                                                  padding: const EdgeInsets.all(5),
                                                  child: Text(time + '  ' + 'و ' + endTime + ' ' + 'صباحاً',
                                                      textAlign: TextAlign.center,
                                                      style: TextStyle(
                                                          fontWeight: FontWeight.bold,
                                                          color: ColorUtils.kmColors,
                                                          fontFamily: StringUtils.fontFamily,
                                                          fontSize: 16.0))),
                                            ],
                                          ),
                                        ),
                                      ),
                                      Padding(
                                          padding: const EdgeInsets.only(top: 15),
                                          child: SizedBox(
                                              width: MediaQuery.of(context).size.width,
                                              child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                                                KButton(
                                                    color: ColorUtils.primaryColor,
                                                    onTap: () => StoreProvider.of<AppState>(context)
                                                        .dispatch(SubmitOrder(submitOrderModel: widget.model)),
                                                    text: 'تثبيت الطلب',
                                                    width: MediaQuery.of(context).size.width * 0.35,
                                                    height: 50),
                                                KOutlinedButton(
                                                    height: 50,
                                                    width: MediaQuery.of(context).size.width * 0.35,
                                                    color: ColorUtils.primaryColor,
                                                    text: StringUtils.cancelOrder,
                                                    onTap: () => RestartWidget.restartApp(context))
                                              ])))
                                    ])))))));
      },
    );
  }
}
