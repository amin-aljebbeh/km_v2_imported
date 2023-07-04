import 'package:intl/intl.dart';

import '../../../../core/core_importer.dart';
import '../../data/models/activity_hours_model.dart';

class ActiveHoursWidget extends StatelessWidget {
  final ActivityHoursModel activityHour;
  final bool newDay;
  const ActiveHoursWidget({Key key, this.activityHour, this.newDay}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        if (newDay)
          Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 8),
                child: Text(
                  DateFormat('EEEE', 'ar').format(activityHour.startWorkAt) +
                      ' ' +
                      DateFormat('dd-MM-yyyy', 'en').format(activityHour.startWorkAt),
                  style: disableStyle,
                ),
              ),
              const KTableRow(
                children: [
                  KTableElement(text: 'مدة التفعيل'),
                  KTableElement(text: 'وقت البدء'),
                  KTableElement(text: 'وقت الإغلاق')
                ],
              ),
            ],
          ),
        KTableRow(
          children: [
            KTableElement(
                text: Duration(minutes: activityHour.numberMinutes).toString().split('.')[0], style: mainStyle),
            KTableElement(text: DateFormat('a h:mm ').format(activityHour.startWorkAt), style: mainStyle),
            KTableElement(text: DateFormat('a h:mm ').format(activityHour.endAt), style: mainStyle),
          ],
        ),
      ],
    );
  }
}
