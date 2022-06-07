import 'package:flutter/material.dart';

import '../../../utils/utils_importer.dart';
import '../../Widget/widgets_importer.dart';
import '../models/shopper_monthly_report_model.dart';

class MonthReportWidget extends StatelessWidget {
  final ShopperMonthlyReport monthData;
  const MonthReportWidget({Key key, this.monthData}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return KTableRow(
      children: [
        KTableElement(text: monthData.date, style: mainStyle),
        KTableElement(text: monthData.countOrder.toString(), style: mainStyle),
        KTableElement(text: monthData.monthlyProfit, style: mainStyle),
      ],
    );
  }
}
