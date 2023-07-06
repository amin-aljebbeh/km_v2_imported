import 'package:kammun_app/features/shoppers_reports/presentation/redux/shoppers_reports_action.dart';

import '../../../../core/core_importer.dart';
import '../../../../core/widget/management_view.dart';
import 'shopper_activity_hours.dart';
import 'shopper_month_report.dart';
import 'shopper_working_hours_view.dart';

class ShopperInformationView extends StatelessWidget {
  const ShopperInformationView({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ManagementView(
      title: 'إحصائيات عامة',
      children: [
        SideBarRow(
          icon: Icons.calendar_month,
          text: 'تقرير شهري',
          onTap: () {
            StoreProvider.of<AppState>(context).dispatch(InitShoppersReport());
            Navigator.push(context, MaterialPageRoute(builder: (context) => const ShopperMonthReport()));
          },
        ),
        SideBarRow(
          icon: Icons.hourglass_bottom,
          text: 'ساعات العمل',
          onTap: () {
            StoreProvider.of<AppState>(context).dispatch(InitShoppersReport());
            Navigator.push(context, MaterialPageRoute(builder: (context) => const ShopperWorkingHoursView()));
          },
        ),
        SideBarRow(
          icon: Icons.online_prediction_rounded,
          text: 'تفعيل التطبيق',
          onTap: () {
            StoreProvider.of<AppState>(context).dispatch(InitShoppersReport());
            Navigator.push(context, MaterialPageRoute(builder: (context) => const ActivityHoursView()));
          },
        ),
      ],
    );
  }
}
