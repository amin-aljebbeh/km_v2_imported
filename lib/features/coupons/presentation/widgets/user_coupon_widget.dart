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
      child: Row(
        children: [
          const SizedBox(width: 1),
          Expanded(
            child: InkWell(
              onTap: () {
                Clipboard.setData(ClipboardData(text: widget.couponEntity.code));
                snackBar(message: 'تم نسخ الكود', context: context, success: true);
              },
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.all(Radius.circular(6)),
                  border: Border.all(
                      color: (widget.couponEntity.pivot.availability == widget.couponEntity.pivot.nUsage) ||
                              widget.couponEntity.pivot.usageExpiration.isBefore(DateTime.now())
                          ? Colors.grey
                          : Colors.green,
                      width: 3),
                  boxShadow: [BoxShadow(color: searchGreyColor, spreadRadius: 1, blurRadius: 15)],
                ),
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
                            child: Text(widget.couponEntity.code, style: informationStyle),
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
                                      (widget.couponEntity.pivot.availability - widget.couponEntity.pivot.nUsage)
                                          .toString(),
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
            ),
          ),
        ],
      ),
    );
  }
}
