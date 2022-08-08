import 'package:flutter/material.dart';
import '../core/core_importer.dart';
import '../modules/product/redux/product_action.dart';

class FavoriteIcon extends StatefulWidget {
  final int productId;
  final String productName;
  final double radius;
  const FavoriteIcon({Key key, this.productId, this.radius, this.productName}) : super(key: key);

  @override
  _FavoriteIconState createState() => _FavoriteIconState();
}

class _FavoriteIconState extends State<FavoriteIcon> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, AppState>(
      converter: (store) => store.state,
      builder: (context, state) {
        return KCard(
          radius: widget.radius,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: InkWell(
                child: Icon(Icons.favorite,
                    color: state.productsState.favorites.contains(widget.productId) ? Colors.red[900] : Colors.grey,
                    size: 30),
                onTap: () {
                  StoreProvider.of<AppState>(context).dispatch(StartLoading());
                  if (state.productsState.favorites.contains(widget.productId)) {
                    StoreProvider.of<AppState>(context)
                        .dispatch(RemoveProductFromFavorites(productId: widget.productId));
                  } else {
                    StoreProvider.of<AppState>(context).dispatch(AddProductToFavorites(productId: widget.productId));
                  }
                  StoreProvider.of<AppState>(context).dispatch(StopLoading());
                  if (!state.productsState.favorites.contains(widget.productId)) {
                    flushbar(
                        message: ' تم إضافة ${widget.productName}  إلى المفضلة',
                        color: Colors.red[900],
                        icon: Icons.favorite);
                  } else {
                    flushbar(
                        message: 'تم إزالة ${widget.productName}  من المفضلة',
                        color: Colors.red[900],
                        icon: Icons.favorite);
                  }
                }),
          ),
        );
      },
    );
  }
}
