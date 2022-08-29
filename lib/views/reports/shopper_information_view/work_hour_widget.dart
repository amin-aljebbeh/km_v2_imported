import '../../../core/core_importer.dart';
import '../models/shopper_working_hours_model.dart';

class WorkHourWidget extends StatelessWidget {
  final ShopperWorkingHoursData workingHoursData;
  const WorkHourWidget({Key key, this.workingHoursData}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return KTableRow(
      children: [
        KTableElement(text: workingHoursData.date, style: mainStyle),
        KTableElement(text: workingHoursData.sum, style: mainStyle),
        KTableElement(text: workingHoursData.countOrders, style: mainStyle),
        KTableElement(
            text: StringUtils().oCcy.format(int.parse(workingHoursData.sumDistances.split('.')[0]) / 1000),
            style: mainStyle),
      ],
    );
  }
}
