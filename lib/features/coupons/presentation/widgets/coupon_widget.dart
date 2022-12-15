import 'package:intl/intl.dart';
import 'package:kammun_app/features/users/presentation/redux/users_action.dart';

import '../../../../core/core_importer.dart';
import '../../domain/entities/coupon_entity.dart';

class CouponWidget extends StatefulWidget {
  final CouponEntity couponEntity;
  final int userId;

  const CouponWidget({Key key, this.couponEntity, this.userId}) : super(key: key);

  @override
  _CouponWidgetState createState() => _CouponWidgetState();
}

class _CouponWidgetState extends State<CouponWidget> {
  int availability = 1;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: KCard(
        onTap: () {},
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
                    child: Text(widget.couponEntity.code,
                        style: mainStyle.copyWith(fontWeight: FontWeight.w700, fontSize: 16)),
                  ),
                  RichText(
                    text: TextSpan(
                      children: <TextSpan>[
                        if (widget.couponEntity.description != null)
                          TextSpan(
                              text: widget.couponEntity.description + ' ',
                              style: mainStyle.copyWith(color: Colors.black)),
                        widget.couponEntity.isPercentageCoupon == 1
                            ? TextSpan(
                                text: StringUtils().oCcy.format(widget.couponEntity.amount) + ' %',
                                style: mainStyle.copyWith(color: Colors.black))
                            : TextSpan(
                                text: StringUtils().oCcy.format(widget.couponEntity.amount) +
                                    ' ' +
                                    LoadingScreenServices.companyInformation.currency,
                                style: mainStyle.copyWith(color: Colors.black)),
                      ],
                    ),
                  ),
                  AutoSizeText(
                      'صالح لغاية    ${DateFormat('a h:mm - dd-MM-yyyy').format(widget.couponEntity.expirationDate)}',
                      style: mainStyle,
                      maxLines: 1),
                ],
              ),
            ),
            SizedBox(
              width: MediaQuery.of(context).size.width,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: DropdownButton(
                        items: Services.dropdownIntList(inputList: ['1', '2', '3', '4', '5', '6', '7', '8', '9', '10']),
                        onChanged: (value) => setState(() => availability = value),
                        value: availability,
                      ),
                    ),
                    KammunButton(
                      color: kmColors,
                      height: 50,
                      width: MediaQuery.of(context).size.width / 3,
                      onTap: () {
                        showMyDialog(
                          title: 'تأكيد',
                          context: context,
                          content: Column(
                            children: [
                              RichText(
                                text: TextSpan(
                                  children: <TextSpan>[
                                    TextSpan(
                                        text: 'سيتم إعطاء الكود ', style: dialogStyle.copyWith(color: Colors.black)),
                                    TextSpan(
                                        text: widget.couponEntity.code + ' ',
                                        style: dialogStyle.copyWith(color: Colors.black, fontWeight: FontWeight.bold)),
                                    TextSpan(text: 'للزبون', style: dialogStyle.copyWith(color: Colors.black)),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          dialogButtons: [
                            KammunButton(
                              color: kmColors,
                              onTap: () {
                                Navigator.pop(context);
                                StoreProvider.of<AppState>(context).dispatch(AttachUserToCouponAction(
                                    userId: widget.userId,
                                    context: context,
                                    couponId: widget.couponEntity.id,
                                    availability: availability));
                              },
                              width: 100,
                              text: 'تأكيد',
                            ),
                            KammunButton(
                                color: kmColors, onTap: () => Navigator.pop(context), width: 100, text: 'إلغاء'),
                          ],
                        );
                      },
                      text: 'ربط',
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
