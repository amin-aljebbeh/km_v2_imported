import 'package:kammun_app/features/orders/domain/entities/order_entity.dart';
import 'package:intl/intl.dart';

import '../core_importer.dart';

class AddComplaintWidget extends StatelessWidget {
  final OrderEntity order;
  final Color color;

  const AddComplaintWidget({Key key, this.order, this.color}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      child: Icon(Icons.report_problem_rounded, color: color, size: 30),
      onTap: () {
        // Format the date
        String formattedDate = DateFormat('yyyy-MM-dd').format(order.createdAt);

        // Construct the mobileNumber parameter
        String mobileNumber =
            '&entry.292765560=$formattedDate&entry.1087139110=$formattedDate'
            '&entry.1121629527=${Uri.encodeComponent(order.address.street)}'
            '&entry.472195289=${order.id}'
            '&entry.2068220824=${Uri.encodeComponent(order.user.phone)}';

        // Open the URL
        Services.openUrl('form', context, mobileNumber: mobileNumber);
      },
    );
  }
}
