import 'package:kammun_app/core/core_importer.dart';

import '../../domain/entities/admin_balance_entity.dart';

adminBalanceWidget({BuildContext context, AdminBalanceEntity balance}) {
  showMyDialog(
      title: 'المستحقات المالية',
      context: context,
      dialogButtons: [const CloseWidget()],
      content: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Column(
            children: [
              Text(shopper, style: mainStyle),
              Text(StringUtils().oCcy.format(int.parse(balance.totalShopperProfits).abs()),
                  style: int.parse(balance.totalShopperProfits).isNegative ? loseStyle : profitStyle),
            ],
          ),
          Column(
            children: [
              Text(kammun, style: mainStyle),
              Text(StringUtils().oCcy.format(int.parse(balance.companyDues).abs()).toString(),
                  style: int.parse(balance.companyDues).isNegative ? loseStyle : profitStyle),
            ],
          ),
        ],
      ));
}
