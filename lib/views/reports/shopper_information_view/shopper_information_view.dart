import 'package:flutter/material.dart';
import 'package:kammun_app/views/reports/shopper_information_view/shopper_activity_hours.dart';
import 'package:kammun_app/views/reports/shopper_information_view/shopper_month_report.dart';
import 'package:kammun_app/views/reports/shopper_information_view/shopper_working_hours_view.dart';

import '../../Widget/widgets_importer.dart';
import '../../management_view/management_view.dart';

class ShopperInformation extends StatelessWidget {
  const ShopperInformation({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ManagementView(
      title: 'إحصائيات عامة',
      children: [
        SideBarRow(
          icon: Icons.calendar_month,
          text: 'تقرير شهري',
          onTap: () => Navigator.of(context).pushNamed(ShopperMonthReport.routeName),
        ),
        SideBarRow(
          icon: Icons.hourglass_bottom,
          text: 'ساعات العمل',
          onTap: () => Navigator.of(context).pushNamed(ShopperWorkingHoursView.routeName),
        ),
        SideBarRow(
          icon: Icons.online_prediction_rounded,
          text: 'تفعيل التطبيق',
          onTap: () => Navigator.of(context).pushNamed(ActivityHoursView.routeName),
        ),
      ],
    );
  }
}
