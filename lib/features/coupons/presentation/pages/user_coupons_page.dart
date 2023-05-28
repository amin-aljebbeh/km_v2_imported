import '../../../../core/core_importer.dart';
import '../../domain/entities/coupon_entity.dart';
import '../widgets/user_coupon_widget.dart';

class UserCouponsPage extends StatelessWidget {
  static String routeName = '/UserCouponsPage';

  UserCouponsPage({Key key}) : super(key: key);

  final FocusNode focusNode = FocusNode();

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, AppState>(
      converter: (store) => store.state,
      builder: (context, state) {
        List<Widget> active = [];
        List<Widget> nonActive = [];
        List<CouponEntity> coupons = [];
        coupons.addAll(state.couponState.userCoupons);
        for (int i = 0; i < coupons.length; i++) {
          if ((coupons[i].pivot.availability == coupons[i].pivot.nUsage) ||
              coupons[i].pivot.usageExpiration.isBefore(DateTime.now())) {
            if (nonActive.isEmpty) {
              nonActive.add(Padding(
                  padding: const EdgeInsets.only(top: 15),
                  child: Text('الأكواد الغير الفعالة', style: informationStyle)));
            }
            nonActive.add(UserCouponWidget(couponEntity: coupons[i]));
          } else {
            if (active.isEmpty) {
              active.add(Padding(
                  padding: const EdgeInsets.only(top: 15), child: Text('الأكواد الفعالة', style: informationStyle)));
            }
            active.add(UserCouponWidget(couponEntity: coupons[i]));
          }
        }
        return TemporaryLoading(
          child: Scaffold(
            body: SafeArea(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  state.loadingState.loading.isNotEmpty
                      ? const Center(child: Loader())
                      : state.errorState.isError && coupons.isEmpty
                          ? Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Center(child: Text(state.errorState.errorMessage, style: paragraphStyle)))
                          : coupons.isEmpty && state.loadingState.loading.isEmpty
                              ? Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Center(child: Text('لا يوجد أكواد حسم', style: paragraphStyle)))
                              : Expanded(
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: SingleChildScrollView(
                                      physics: const AlwaysScrollableScrollPhysics(parent: BouncingScrollPhysics()),
                                      child: Column(
                                        children: [
                                          if (active.isNotEmpty)
                                            Container(
                                                margin: const EdgeInsets.only(top: 15),
                                                decoration: const BoxDecoration(
                                                    borderRadius: BorderRadius.all(Radius.circular(15))),
                                                child: Column(children: active)),
                                          if (nonActive.isNotEmpty)
                                            Container(
                                              margin: const EdgeInsets.only(top: 15),
                                              decoration: const BoxDecoration(
                                                  borderRadius: BorderRadius.all(Radius.circular(15))),
                                              child: Column(children: nonActive),
                                            ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
