import '../../../core/core_importer.dart';
import '../../../core/widget/management_view.dart';

class ShopperInformationView extends StatelessWidget {
  static const String routeName = '/ShopperInformation';
  const ShopperInformationView({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const ManagementView(
      title: 'إحصائيات عامة',
      children: [
        SideBarRow(icon: Icons.calendar_month, text: 'تقرير شهري', pushedRoute: ShopperMonthReport.routeName),
        SideBarRow(icon: Icons.hourglass_bottom, text: 'ساعات العمل', pushedRoute: ShopperWorkingHoursView.routeName),
        SideBarRow(
            icon: Icons.online_prediction_rounded, text: 'تفعيل التطبيق', pushedRoute: ActivityHoursView.routeName),
      ],
    );
  }
}
