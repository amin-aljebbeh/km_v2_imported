import '../../../../core/core_importer.dart';
import '../widgets/user_coupon_widget.dart';

class UserCouponsPage extends StatefulWidget {
  static String routeName = '/UserCouponsPage';

  const UserCouponsPage({Key key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => UserCouponsPageState();
}

class UserCouponsPageState extends State<UserCouponsPage> {
  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, AppState>(
      converter: (store) => store.state,
      builder: (context, state) {
        return TemporaryLoading(
          child: Scaffold(
            body: SafeArea(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  state.loadingState.isLoading
                      ? const Center(child: Loader())
                      : state.errorState.isError && state.couponState.userCoupons.isEmpty
                          ? Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Center(child: Text(state.errorState.errorMessage, style: paragraphStyle)))
                          : state.couponState.userCoupons.isEmpty && !state.loadingState.isLoading
                              ? Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Center(child: Text('لا يوجد أكواد حسم', style: paragraphStyle)))
                              : Expanded(
                                  child: ListView.builder(
                                      physics: const AlwaysScrollableScrollPhysics(parent: BouncingScrollPhysics()),
                                      primary: false,
                                      scrollDirection: Axis.vertical,
                                      shrinkWrap: true,
                                      itemCount: state.couponState.userCoupons.length,
                                      itemBuilder: (BuildContext context, int index) =>
                                          UserCouponWidget(couponEntity: state.couponState.userCoupons[index])),
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
