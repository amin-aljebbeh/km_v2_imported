import 'package:kammun_app/features/cart/presentation/redux/cart_action.dart';
import 'package:kammun_app/features/cart/presentation/widgets/cart_product_counter.dart';
import 'package:kammun_app/features/order_details/presentation/redux/order_details_action.dart';

import '../../../../core/core_importer.dart';
import '../../../products/domain/entities/product_entity.dart';

class CartProductWidget extends StatelessWidget {
  final int index;
  final bool editPrice;
  final TextEditingController priceController = TextEditingController();

  CartProductWidget({Key key, this.index, this.editPrice = false}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var store = StoreProvider.of<AppState>(context);
    return StoreConnector<AppState, AppState>(
      converter: (store) => store.state,
      distinct: true,
      builder: (context, state) {
        ProductEntity product = state.cartState.cartProducts[index];
        int editIndex = state.cartState.indexToEdit;
        return Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(left: 10),
                  child: KCacheImage(
                    tag: index + 100,
                    image: product.images.isNotEmpty
                        ? StaticVariables.imagePrefixUrl + product.images[0].imageFileName
                        : '',
                  ),
                ),
                Expanded(
                  child: Wrap(
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.all(3.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(product.name, style: mainStyle.copyWith(fontWeight: FontWeight.w700, fontSize: 18)),
                            Padding(
                              padding: const EdgeInsets.only(top: 6, bottom: 8),
                              child: Text(product.quantity + ' ' + product.unit,
                                  style: mainStyle.copyWith(
                                      fontWeight: FontWeight.w400, color: primaryColor, fontSize: 17)),
                            ),
                            Row(
                              children: [
                                index == editIndex && editPrice
                                    ? Expanded(
                                        flex: 2,
                                        child: SizedBox(
                                          height: 50,
                                          width: 50,
                                          child: TextFormField(
                                            controller: priceController,
                                            textAlign: TextAlign.center,
                                            keyboardType: TextInputType.number,
                                            decoration: InputDecoration(
                                                hintText: 'السعر الجديد',
                                                fillColor: Colors.white,
                                                border: OutlineInputBorder(
                                                    borderRadius: BorderRadius.circular(10.0),
                                                    borderSide: const BorderSide())),
                                          ),
                                        ),
                                      )
                                    : Text(
                                        StringUtils().oCcy.format(int.parse(product.price.split('.')[0])) +
                                            state.generalInformationState.companyInformation.currency,
                                        style: mainStyle.copyWith(
                                            fontWeight: FontWeight.w700, color: primaryColor, fontSize: 18)),
                                if (editPrice)
                                  index == editIndex
                                      ? IconButton(
                                          icon: const Icon(Icons.save_rounded),
                                          color: Colors.green,
                                          onPressed: () {
                                            store.dispatch(SetEditIndex(index: -1));

                                            if (priceController.text.isNotEmpty) {
                                              double priceFactor =
                                                  double.parse(product.quantity) / double.parse(product.price);
                                              state.cartState.cartProducts
                                                      .firstWhere((editProduct) => product.id == editProduct.id)
                                                      .quantity =
                                                  (priceFactor * double.parse(priceController.text)).toStringAsFixed(2);
                                              state.cartState.cartProducts
                                                  .firstWhere((editProduct) => product.id == editProduct.id)
                                                  .price = priceController.text.split('.')[0];

                                              store.dispatch(SetCartProducts(products: state.cartState.cartProducts));
                                              store.dispatch(UpdateOrderProductAction(
                                                  context: context,
                                                  orderId: state.cartState.orderUnderUpdateId,
                                                  updateKey: 'product_quantity',
                                                  updateValue: (priceFactor * double.parse(priceController.text))
                                                      .toStringAsFixed(2),
                                                  productId: product.id));
                                            }
                                            priceController.text = '';
                                          },
                                          iconSize: 30)
                                      : IconButton(
                                          icon: const Icon(Icons.edit),
                                          color: Colors.green,
                                          onPressed: () => store.dispatch(SetEditIndex(index: index)),
                                          iconSize: 30),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                CartProductCounter(index: index),
              ],
            ),
            const Padding(padding: EdgeInsets.only(top: 4), child: Divider(thickness: 3))
          ],
        );
      },
    );
  }
}
