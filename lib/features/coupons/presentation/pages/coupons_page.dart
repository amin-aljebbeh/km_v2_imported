import 'package:kammun_app/features/coupons/presentation/redux/coupon_action.dart';

import '../../../../core/core_importer.dart';
import '../widgets/coupon_widget.dart';

class CouponsPage extends StatefulWidget {
  static String routeName = '/CouponsView';
  final int userId;

  const CouponsPage({Key key, this.userId}) : super(key: key);

  @override
  State<StatefulWidget> createState() => CouponsPageState();
}

class CouponsPageState extends State<CouponsPage> {
  TextEditingController controller = TextEditingController();
  int type = 2;
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
                  SizedBox(
                    width: MediaQuery.of(context).size.width,
                    child: Row(
                      children: [
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: TextFormField(
                                controller: controller,
                                cursorColor: kmColors,
                                style: mainStyle,
                                onFieldSubmitted: (_) {
                                  StoreProvider.of<AppState>(context).dispatch(SetCoupons(coupons: []));
                                  StoreProvider.of<AppState>(context).dispatch(GetCouponsAction(
                                      code: controller.text, isForDelivery: [0, 1].contains(type) ? type : null));
                                },
                                decoration: InputDecoration(
                                    hintStyle: homeIconStyle,
                                    enabled: true,
                                    filled: true,
                                    hintTextDirection: TextDirection.ltr,
                                    prefixIcon: InkWell(
                                        child: const Icon(Icons.close_rounded, color: Colors.grey),
                                        onTap: () => controller.text = ''),
                                    suffixIcon: InkWell(
                                        child: const Icon(Icons.search_rounded, color: Colors.grey),
                                        onTap: () {
                                          StoreProvider.of<AppState>(context).dispatch(SetCoupons(coupons: []));
                                          StoreProvider.of<AppState>(context).dispatch(GetCouponsAction(
                                              code: controller.text,
                                              isForDelivery: [0, 1].contains(type) ? type : null));
                                        }),
                                    border: const OutlineInputBorder(),
                                    enabledBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(6),
                                        borderSide: BorderSide(color: searchGreyColor, width: 2)),
                                    focusedBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(6),
                                        borderSide: BorderSide(color: searchGreyColor, width: 2)))),
                          ),
                        ),
                        DropdownButton(
                            items: Services.reverseDropdownIntList(
                                inputList: ['جميع الأكواد', 'على أجور التوصيل', 'على قيمة المنتجات']),
                            value: type,
                            onChanged: (value) {
                              setState(() => type = value);
                              StoreProvider.of<AppState>(context).dispatch(SetCoupons(coupons: []));
                              StoreProvider.of<AppState>(context).dispatch(GetCouponsAction(
                                  code: controller.text, isForDelivery: [0, 1].contains(type) ? type : null));
                            })
                      ],
                    ),
                  ),
                  state.loadingState.isLoading
                      ? const Center(child: Loader())
                      : state.errorState.isError && state.couponState.coupons.isEmpty
                          ? Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Center(child: Text(state.errorState.errorMessage, style: paragraphStyle)))
                          : state.couponState.coupons.isEmpty && !state.loadingState.isLoading
                              ? Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Center(child: Text('ليس لديك أكواد حسم', style: paragraphStyle)))
                              : Expanded(
                                  child: ListView.builder(
                                      physics: const AlwaysScrollableScrollPhysics(parent: BouncingScrollPhysics()),
                                      primary: false,
                                      scrollDirection: Axis.vertical,
                                      shrinkWrap: true,
                                      itemCount: state.couponState.coupons.length,
                                      itemBuilder: (BuildContext context, int index) => CouponWidget(
                                          couponEntity: state.couponState.coupons[index], userId: widget.userId)),
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
