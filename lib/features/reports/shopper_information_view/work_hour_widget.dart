import '../../../core/core_importer.dart';
import '../models/shopper_working_hours_model.dart';

class WorkHourWidget extends StatelessWidget {
  final ShopperWorkingHoursData workingHoursData;
  const WorkHourWidget({Key key, this.workingHoursData}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return KTableRow(
      children: [
        KTableElement(text: workingHoursData.date),
        KTableElement(text: workingHoursData.sum),
        KTableElement(text: workingHoursData.countOrders),
        KTableElement(text: (int.parse(workingHoursData.sumDistances) / 1000).toString() + ' كم'),
      ],
    );
  }
}
