import 'package:flutter/material.dart';
import 'package:kammun_app/utils/Loader.dart';
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
  bool loading;
  bool error;

  getDailyProfit() async {
    profit = await ReportsServices.getShopperDailyProfit(
        shopperId: widget.shopperId);
    setState(() {
      if (profit == null) error = true;
      loading = false;
    });
  }

  @override
  void initState() {
    loading = true;
    error = false;
    getDailyProfit();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return loading
        ? Loader()
        : Column(
            children: [
              LabelRow(
                rightSideText: 'مرابح اليوم : ',
                leftSideText: profit != null
                    ? StringUtils()
                        .oCcy
                        .format(int.parse(profit).abs())
                        .toString()
                    : 'error',
                leftSideStyle: profit != null
                    ? int.parse(profit).isNegative
                        ? loseStyle
                        : profitStyle
                    : loseStyle,
              ),
            ],
          );
  }
}
