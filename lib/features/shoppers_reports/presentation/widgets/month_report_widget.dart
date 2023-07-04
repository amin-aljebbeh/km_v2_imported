import '../../../../core/core_importer.dart';
import '../../data/models/shopper_monthly_report_model.dart';

class MonthReportWidget extends StatelessWidget {
  final ShopperMonthlyReportModel monthData;
  const MonthReportWidget({Key key, this.monthData}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return KTableRow(
      children: [
        KTableElement(text: monthData.date, style: mainStyle),
        KTableElement(text: StringUtils().oCcy.format(int.parse(monthData.countOrder)), style: mainStyle),
        KTableElement(
            text: StringUtils().oCcy.format(int.parse(monthData.monthlyProfit.split('.')[0])), style: mainStyle),
        KTableElement(text: (int.parse(monthData.sumDistances) / 1000).toString() + ' كم', style: mainStyle),
      ],
    );
  }
}
