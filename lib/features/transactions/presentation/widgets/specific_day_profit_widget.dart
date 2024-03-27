import 'package:kammun_app/core/core_importer.dart';

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
