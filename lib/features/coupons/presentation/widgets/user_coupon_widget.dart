import 'package:intl/intl.dart' as intl;

import '../../../../core/core_importer.dart';
import '../../domain/entities/coupon_entity.dart';

class UserCouponWidget extends StatefulWidget {
  final CouponEntity couponEntity;

  const UserCouponWidget({Key key, this.couponEntity}) : super(key: key);

  @override
  _UserCouponWidgetState createState() => _UserCouponWidgetState();
}

class _UserCouponWidgetState extends State<UserCouponWidget> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: KCard(
        onTap: () {
          Clipboard.setData(ClipboardData(text: widget.couponEntity.code));
          snackBar(message: 'تم نسخ الكود', context: context, success: true);
        },
        radius: const BorderRadius.all(Radius.circular(6)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: RichText(
                        textDirection: TextDirection.rtl,
                        text: TextSpan(children: [
                          TextSpan(text: widget.couponEntity.code, style: informationStyle),
                          TextSpan(text: ' ', style: informationStyle),
                          TextSpan(text: '(', style: informationStyle),
                          if ((widget.couponEntity.pivot.availability == widget.couponEntity.pivot.nUsage) ||
                              widget.couponEntity.pivot.usageExpiration.isBefore(DateTime.now()))
                            TextSpan(text: 'غير ', style: informationStyle),
                          TextSpan(text: 'فعال', style: informationStyle),
                          TextSpan(text: ')', style: informationStyle),
                        ])),
                  ),
                  Wrap(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 20),
                        child: LabelRow(
                            rightSideText: 'مرات الاستخدام: ',
                            leftSideText: widget.couponEntity.pivot.nUsage.toString(),
                            leftSideStyle: informationStyle),
                      ),
                      LabelRow(
                          rightSideText: 'المتبقي: ',
                          leftSideText:
                              (widget.couponEntity.pivot.availability - widget.couponEntity.pivot.nUsage).toString(),
                          leftSideStyle: informationStyle),
                    ],
                  ),
                  AutoSizeText(
                      'صالح لغاية    ${intl.DateFormat('a h:mm - dd-MM-yyyy').format(widget.couponEntity.pivot.usageExpiration)}',
                      style: informationStyle,
                      maxLines: 1),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
