import '../../../../core/core_importer.dart';
import '../../../products/domain/entities/product_entity.dart';
import '../redux/cart_action.dart';

class CartProductCounter extends StatefulWidget {
  final int index;
  const CartProductCounter({Key key, this.index}) : super(key: key);

  @override
  _CartProductCounterState createState() => _CartProductCounterState();
}

class _CartProductCounterState extends State<CartProductCounter> {
  @override
  Widget build(BuildContext context) {
    var store = StoreProvider.of<AppState>(context);
    return StoreConnector<AppState, AppState>(
      converter: (store) => store.state,
      distinct: true,
      builder: (context, state) {
        ProductEntity product = state.cartState.cartProducts[widget.index];
        return Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Container(
              width: 30,
              height: 30,
              decoration: BoxDecoration(shape: BoxShape.circle, color: searchGreyColor.withOpacity(0.2)),
              child: InkWell(
                onTap: () {
                  product.productCount++;
                  store.dispatch(UpdateCartProducts(productId: product.id, quantity: product.productCount));
                  setState(() {});
                },
                child: Image.asset('assets/add.png', width: 60, height: 60),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 5),
              child: Text(product.productCount.toString(),
                  style: mainStyle.copyWith(fontWeight: FontWeight.w500, fontSize: 18)),
            ),
            Container(
              width: 30,
              height: 30,
              decoration: BoxDecoration(shape: BoxShape.circle, color: searchGreyColor.withOpacity(0.2)),
              child: InkWell(
                onTap: () {
                  if (product.productCount > 1) {
                    product.productCount--;
                    store.dispatch(UpdateCartProducts(productId: product.id, quantity: product.productCount));
                    setState(() {});
                  } else if (product.productCount == 1) {
                    store.dispatch(UpdateCartProducts(productId: product.id, quantity: 0));
                  }
                },
                child: product.productCount > 1
                    ? Image.asset('assets/remove.png', width: 60, height: 60)
                    : const Icon(Icons.delete_forever, size: 30, color: Colors.red),
              ),
            ),
          ],
        );
      },
    );
  }
}
