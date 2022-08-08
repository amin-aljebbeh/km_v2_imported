import 'package:flutter/material.dart';

import 'package:kammun_app/core/core_importer.dart';

class ProductCounter extends StatefulWidget {
  final int productId;
  final Function onAdd;
  final Function(int count) onIncrease;
  final Function(int count) onRemove;
  final Function onDelete;
  final bool fromCart;

  const ProductCounter(
      {Key key, this.onAdd, this.onRemove, this.onDelete, this.fromCart = false, this.onIncrease, this.productId})
      : super(key: key);

  @override
  _ProductCounterState createState() => _ProductCounterState();
}

class _ProductCounterState extends State<ProductCounter> with TickerProviderStateMixin {
  AnimationController sizeAnimationController;
  AnimationController colorAnimationController;
  Animation animation;
  int count;
  final double height = 95;
  final double width = 30;

  @override
  void initState() {
    sizeAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
      lowerBound: width,
      upperBound: height,
    );

    colorAnimationController = AnimationController(vsync: this, duration: const Duration(milliseconds: 350));
    animation = ColorTween(begin: ColorUtils.primaryColor, end: Colors.white).animate(colorAnimationController);
    sizeAnimationController.addListener(() => setState(() {}));
    colorAnimationController.addListener(() => setState(() {}));

    if (widget.fromCart) {
      sizeAnimationController.forward();
      colorAnimationController.forward();
    }
    super.initState();
  }

  @override
  void dispose() {
    colorAnimationController.dispose();
    sizeAnimationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, AppState>(
      converter: (store) => store.state,
      builder: (context, state) {
        count = state.cartState.cartProducts
            .firstWhere((product) => product.id == widget.productId, orElse: () => ProductData(productCount: 0))
            .productCount;
        return SizedBox(
          height: sizeAnimationController.value,
          width: width,
          child: KCard(
            color: animation.value,
            child: ((sizeAnimationController.value == width) && (!widget.fromCart))
                ? state.cartState.cartProducts
                            .firstWhere((product) => product.id == widget.productId,
                                orElse: () => ProductData(productCount: 0))
                            .productCount <=
                        0
                    ? GestureDetector(
                        child: const Icon(Icons.add, size: 25, color: Colors.white),
                        onTap: () {
                          sizeAnimationController.forward();
                          colorAnimationController.forward();
                          count++;
                          widget.onAdd();
                        })
                    : Center(
                        child: Padding(
                          padding: const EdgeInsets.only(top: 5),
                          child: GestureDetector(
                            child: Text(
                              state.cartState.cartProducts
                                  .firstWhere((product) => product.id == widget.productId,
                                      orElse: () => ProductData(productCount: 0))
                                  .productCount
                                  .toString(),
                              style: TextStyle(
                                fontWeight: FontWeight.w800,
                                color: Colors.white,
                                fontFamily: StringUtils.fontFamily,
                                fontSize: 15,
                              ),
                            ),
                            onTap: () {
                              sizeAnimationController.forward();
                              colorAnimationController.forward();
                            },
                          ),
                        ),
                      )
                : Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 5),
                        child: GestureDetector(
                          child: Icon(Icons.add, size: 25, color: ColorUtils.primaryColor),
                          onTap: () {
                            count++;
                            widget.onIncrease(count);
                          },
                        ),
                      ),
                      if (sizeAnimationController.value == height)
                        Padding(
                          padding: const EdgeInsets.only(top: 10),
                          child: GestureDetector(
                            child: Text(
                              state.cartState.cartProducts
                                  .firstWhere((product) => product.id == widget.productId,
                                      orElse: () => ProductData(productCount: 0))
                                  .productCount
                                  .toString(),
                              style: TextStyle(
                                fontWeight: FontWeight.w800,
                                color: Colors.black,
                                fontFamily: StringUtils.fontFamily,
                                fontSize: 15,
                              ),
                            ),
                            onTap: () {
                              if (!widget.fromCart) {
                                sizeAnimationController.reverse();
                                colorAnimationController.reverse();
                              }
                            },
                          ),
                        ),
                      if (sizeAnimationController.value == height)
                        Padding(
                          padding: const EdgeInsets.only(bottom: 5),
                          child: state.cartState.cartProducts
                                      .firstWhere((product) => product.id == widget.productId,
                                          orElse: () => ProductData(productCount: 0))
                                      .productCount >
                                  1
                              ? GestureDetector(
                                  child: Icon(Icons.remove, size: 25, color: ColorUtils.primaryColor),
                                  onTap: () {
                                    count--;
                                    widget.onRemove(count);
                                  },
                                )
                              : GestureDetector(
                                  onTap: () {
                                    if (!widget.fromCart) {
                                      sizeAnimationController.reverse();
                                      colorAnimationController.reverse();
                                    }
                                    if (!widget.fromCart) count--;
                                    widget.onDelete();
                                  },
                                  child: const Icon(Icons.delete, size: 25, color: Colors.grey),
                                ),
                        ),
                    ],
                  ),
            radius: 30,
          ),
        );
      },
    );
  }
}
