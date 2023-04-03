import 'package:intl/intl.dart';
import 'package:kammun_app/core/core_importer.dart';

import '../../domain/entities/admin_transaction_entity.dart';

specificDayProfitWidget({BuildContext context, DateTime date, List<AdminTransactionEntity> transactions}) {
  int kammunProfit = transactions
      .where((transaction) => transaction.createdAt.toString().split(' ')[0] == date.toString().split(' ')[0])
      .toList()
      .fold(0, (value, transaction) => value + int.parse(transaction.companyValue));

  int shopperProfit = transactions
      .where((transaction) => transaction.createdAt.toString().split(' ')[0] == date.toString().split(' ')[0])
      .toList()
      .fold(0, (value, transaction) => value + int.parse(transaction.shopperValue));
  showMyDialog(
    context: context,
    title: 'مرابح ${DateFormat('EEEE', 'ar').format(date) + ' ' + DateFormat('dd-MM-yyyy', 'en').format(date)}',
    content: Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        Column(
          children: [
            Text(shopper, style: mainStyle),
            Text(StringUtils().oCcy.format(shopperProfit.abs()).toString(),
                style: shopperProfit.isNegative ? loseStyle : profitStyle),
          ],
        ),
        Column(
          children: [
            Text(kammun, style: mainStyle),
            Text(StringUtils().oCcy.format(kammunProfit.abs()).toString(),
                style: kammunProfit.isNegative ? loseStyle : profitStyle),
          ],
        ),
      ],
    ),
    dialogButtons: [const CloseWidget()],
  );
}
