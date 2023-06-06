import 'package:kammun_app/features/cart/presentation/pages/final_cart_page.dart';
import 'package:kammun_app/features/cart/presentation/widgets/cart_product_widget.dart';

import '../../../../core/core_importer.dart';

class CartPage extends StatelessWidget {
  static const String routeName = '/CartPage';
  const CartPage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, AppState>(
      converter: (store) => store.state,
      distinct: true,
      builder: (context, state) {
        return Scaffold(
          backgroundColor: Colors.white,
          body: SafeArea(
            child: Padding(
              padding: const EdgeInsets.only(left: 20, top: 10, right: 20, bottom: 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(bottom: 8.0),
                    child: Text(shoppingCart, style: mainStyle.copyWith(fontWeight: FontWeight.w700, fontSize: 30)),
                  ),
                  state.cartState.cartProducts.isEmpty
                      ? Padding(
                          padding: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.3),
                          child: const Center(child: ScreenMessage(message: 'سلة المشتريات فارغة')))
                      : Container(padding: EdgeInsets.zero),
                  Expanded(
                    child: ListView.builder(
                      primary: false,
                      shrinkWrap: true,
                      itemCount: state.cartState.cartProducts.length,
                      itemBuilder: (BuildContext context, int index) {
                        return CartProductWidget(index: index, editPrice: true);
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 30, bottom: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text(subtotalString, style: mainStyle.copyWith(fontWeight: FontWeight.w700, fontSize: 19.0)),
                        Text(
                          '${StringUtils().oCcy.format(state.cartState.cartProducts.fold(0, (sum, order) => sum + ((int.parse(order.price.split('.')[0])) * order.productCount)))} ${StaticVariables.companyInformation.currency}',
                          style: mainStyle.copyWith(fontWeight: FontWeight.w700, fontSize: 19),
                        ),
                      ],
                    ),
                  ),
                  SafeArea(
                    child: KammunButton(
                      padding: const EdgeInsets.only(bottom: 10),
                      width: MediaQuery.of(context).size.width,
                      color: state.cartState.cartProducts.isNotEmpty ? primaryColor : Colors.grey[400],
                      text: confirmOrder,
                      onTap: () {
                        if (state.cartState.cartProducts.isNotEmpty) {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      FinalCartPage(userNotes: TextEditingController(text: state.cartState.userNote))));
                        } else {
                          Toast.show('يرجى إضافة منتج واحد على الأقل', context,
                              duration: Toast.LENGTH_LONG, gravity: Toast.CENTER);
                        }
                      },
                      height: 50,
                    ),
                    top: false,
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
