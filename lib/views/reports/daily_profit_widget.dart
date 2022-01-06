import 'package:flutter/material.dart';
import 'package:kammun_app/utils/utils_importer.dart';
import 'package:kammun_app/views/Wedgit/widgets_importer.dart';
import 'package:kammun_app/views/reports/services/reports_services.dart';

class DailyProfit extends StatefulWidget {
  final String shopperId;

  const DailyProfit({Key key, @required this.shopperId}) : super(key: key);
  @override
  _DailyProfitState createState() => _DailyProfitState();
}

class _DailyProfitState extends State<DailyProfit> {
  String profit;

  getDailyProfit() async {
    profit = await ReportsServices.getShopperDailyProfit(
        shopperId: widget.shopperId);
    setState(() {});
  }

  @override
  void initState() {
    getDailyProfit();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 25,
        ),
        LabelRow(
          rightSideText: 'مرابح اليوم : ',
          leftSideText:
              StringUtils().oCcy.format(int.parse(profit).abs()).toString(),
          leftSideStyle: int.parse(profit).isNegative ? loseStyle : profitStyle,
        ),
        SizedBox(
          height: 25,
        ),
      ],
    );
  }
}
