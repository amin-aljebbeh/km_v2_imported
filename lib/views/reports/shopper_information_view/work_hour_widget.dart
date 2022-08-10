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
        KTableElement(text: workingHoursData.sum.toString(), style: mainStyle),
      ],
    );
  }
}
