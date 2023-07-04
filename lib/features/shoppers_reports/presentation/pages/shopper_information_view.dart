import '../../../../core/core_importer.dart';
import '../../../../core/widget/management_view.dart';
import 'shopper_activity_hours.dart';
import 'shopper_month_report.dart';
import 'shopper_working_hours_view.dart';

class ShopperInformationView extends StatelessWidget {
  const ShopperInformationView({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const ManagementView(
      title: 'إحصائيات عامة',
      children: [
        SideBarRow(icon: Icons.calendar_month, text: 'تقرير شهري', pushedRoute: ShopperMonthReport()),
        SideBarRow(icon: Icons.hourglass_bottom, text: 'ساعات العمل', pushedRoute: ShopperWorkingHoursView()),
        SideBarRow(icon: Icons.online_prediction_rounded, text: 'تفعيل التطبيق', pushedRoute: ActivityHoursView()),
      ],
    );
  }
}
