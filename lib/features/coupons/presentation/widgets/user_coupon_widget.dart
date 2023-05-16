import 'package:intl/intl.dart' as intl;

import '../../../../core/core_importer.dart';
import '../../domain/entities/coupon_entity.dart';

class UserCouponWidget extends StatelessWidget {
  final CouponEntity couponEntity;

  const UserCouponWidget({Key key, this.couponEntity}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      child: Padding(
        padding: const EdgeInsets.all(15.0),
        child: InkWell(
          onTap: () {
            Clipboard.setData(ClipboardData(text: couponEntity.code));
            snackBar(message: 'تم نسخ الكود', context: context, success: true);
          },
          child: Container(
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.all(Radius.circular(6)),
              border: Border.all(
                color: (couponEntity.pivot.availability == couponEntity.pivot.nUsage) ||
                        couponEntity.pivot.usageExpiration.isBefore(DateTime.now())
                    ? Colors.grey
                    : Colors.green,
                width: 3,
              ),
              boxShadow: [BoxShadow(color: searchGreyColor, spreadRadius: 1, blurRadius: 15)],
            ),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(couponEntity.code, style: informationStyle),
                  Wrap(
                    children: [
                      LabelRow(
                        rightSideText: 'مرات الاستخدام: ',
                        leftSideText: couponEntity.pivot.nUsage.toString() + ' ',
                        leftSideStyle: informationStyle,
                      ),
                      LabelRow(
                        rightSideText: 'المتبقي: ',
                        leftSideText: (couponEntity.pivot.availability - couponEntity.pivot.nUsage).toString(),
                        leftSideStyle: informationStyle,
                      ),
                    ],
                  ),
                  AutoSizeText(
                    'صالح لغاية ${intl.DateFormat('a h:mm - dd-MM-yyyy').format(couponEntity.pivot.usageExpiration)}',
                    style: informationStyle,
                    maxLines: 1,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
