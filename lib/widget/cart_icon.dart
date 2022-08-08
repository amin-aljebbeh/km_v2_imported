import 'package:flutter/material.dart';

import '../core/core_importer.dart';
import '../modules/cart/view/cart_view.dart';

class CartIcon extends StatelessWidget {
  final Color color;
  const CartIcon({Key key, this.color = Colors.white}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, AppState>(
      converter: (store) => store.state,
      builder: (context, state) {
        return Stack(
          children: [
            InkWell(
              child: Icon(Icons.shopping_cart, size: 35, color: color),
              onTap: () =>
                  Navigator.pushNamedAndRemoveUntil(context, CartView.routeName, (Route<dynamic> route) => false),
            ),
            Positioned(
              top: 0,
              right: 0,
              child: CircleAvatar(
                child: Padding(
                  padding: const EdgeInsets.only(top: 2),
                  child: Text(state.cartState.cartProducts.length.toString(),
                      style: mainStyle.copyWith(fontSize: 13)),
                ),
                radius: 8,
                backgroundColor: ColorUtils.primaryColor,
              ),
            ),
          ],
        );
      },
    );
  }
}
