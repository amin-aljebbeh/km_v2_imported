import 'package:intl/intl.dart';
import 'package:kammun_app/core/core_importer.dart';
import 'package:kammun_app/features/users/data/models/palance_model.dart';
import 'package:kammun_app/features/users/domain/entities/balance_entity.dart';

import '../../domain/entities/admin_transaction_entity.dart';

specificDayProfitWidget({BuildContext context, String date, int company,int shoppers }) {
  int kammunProfit = company;

  int shopperProfit = shoppers;
  showMyDialog(
    context: context,
    title: 'مرابح ${date+ ' ' }',
    content: Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        Column(
          children: [
            Text(shopper, style: mainStyle),
            Text(StringUtils().oCcy.format(shopperProfit.abs()),
                style: shopperProfit.isNegative ? loseStyle : profitStyle),
          ],
        ),
        Column(
          children: [
            Text(kammun, style: mainStyle),
            Text(StringUtils().oCcy.format(kammunProfit.abs()),
                style: kammunProfit.isNegative ? loseStyle : profitStyle),
          ],
        ),
      ],
    ),
    dialogButtons: [const CloseWidget()],
  );
}
