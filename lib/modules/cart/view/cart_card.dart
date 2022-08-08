import '../../../core/core_importer.dart';

class CartCard extends StatefulWidget {
  final ProductData product;
  final int hero;
  final int count;
  final Function onAdd;
  final Function onRemove;
  final Function onDelete;

  const CartCard({Key key, this.product, this.hero, this.onAdd, this.onRemove, this.onDelete, this.count})
      : super(key: key);
  @override
  _CartCardState createState() => _CartCardState();
}

class _CartCardState extends State<CartCard> {
  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, AppState>(
      converter: (store) => store.state,
      builder: (context, state) {
        return Stack(
          children: [
            Padding(
              padding: const EdgeInsets.all(10),
              child: KCard(
                radius: 10,
                child: Row(
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: KCacheImage(
                        tag: widget.hero,
                        image: widget.product.images.isNotEmpty ? widget.product.images[0].imageFileName : '',
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(3.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              widget.product.name,
                              style: TextStyle(
                                  fontWeight: FontWeight.w700, fontFamily: StringUtils.fontFamily, fontSize: 18),
                            ),
                            const SizedBox(height: 6),
                            Text(
                              widget.product.quantity.toString() + ' ' + widget.product.unit.toString(),
                              style: TextStyle(
                                  fontWeight: FontWeight.w400,
                                  color: ColorUtils.greyColor,
                                  fontFamily: StringUtils.fontFamily,
                                  fontSize: 17),
                            ),
                            const SizedBox(height: 8),
                            Text(
                                '${StringUtils().oCcy.format(int.parse(widget.product.price.split('.')[0]))} ${state.startupState.startModel.company.currency}',
                                style: TextStyle(
                                    fontWeight: FontWeight.w700,
                                    color: ColorUtils.primaryColor,
                                    fontFamily: StringUtils.fontFamily,
                                    fontSize: 18)),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(width: 25),
                  ],
                ),
              ),
            ),
            Positioned(
              top: 5,
              right: 5,
              child: FavoriteIcon(radius: 150, productId: widget.product.id, productName: widget.product.name),
            ),
            Positioned(
              bottom: 2,
              left: 20,
              child: ProductCounter(
                onRemove: (count) => widget.onRemove(),
                onAdd: (count) => widget.onAdd(),
                productId: widget.product.id,
                onIncrease: (count) => widget.onAdd(),
                onDelete: widget.onDelete,
                fromCart: true,
              ),
            )
          ],
        );
      },
    );
  }
}
