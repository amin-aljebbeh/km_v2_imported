import 'package:full_screen_image/full_screen_image.dart';

import '../../../core/core_importer.dart';

class ProductDetailsViewAppBar extends StatefulWidget {
  final ProductData product;
  final ScrollController scrollController;
  const ProductDetailsViewAppBar({Key key, this.product, this.scrollController}) : super(key: key);

  @override
  _ProductDetailsViewAppBarState createState() => _ProductDetailsViewAppBarState();
}

class _ProductDetailsViewAppBarState extends State<ProductDetailsViewAppBar> with SingleTickerProviderStateMixin {
  bool done = false;
  AnimationController _animationController;
  Animation _animation;
  final _height = 100.0;

  @override
  void initState() {
    if (widget.product.warehouses.isEmpty) widget.product.warehouses.add(Warehouse(name: 'غير مضاف لمستودع', id: 0));
    super.initState();

    Timer(const Duration(milliseconds: 100), () => _animateToIndex(2.5));

    _animationController = AnimationController(duration: const Duration(milliseconds: 1500), vsync: this);
    _animation = Tween(begin: 1.5, end: 0.0).animate(_animationController);

    _animationController.forward();
  }

  _animateToIndex(i) async {
    await widget.scrollController
        .animateTo(_height * i, duration: const Duration(milliseconds: 1500), curve: Curves.easeInOut);
    setState(() => done = true);
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
        automaticallyImplyLeading: false,
        leading: IconButton(
            iconSize: 35,
            icon: const Icon(Icons.home),
            tooltip: 'Back to Store Page',
            onPressed: () =>
                Navigator.of(context).pushNamedAndRemoveUntil(StoreView.routeName, (Route<dynamic> route) => false)),
        actions: <Widget>[
          IconButton(
              onPressed: () => Navigator.of(context).pop(true), icon: const Icon(Icons.arrow_forward_ios, size: 35))
        ],
        backgroundColor: primaryColor,
        expandedHeight: 300.0,
        floating: false,
        pinned: true,
        title: Container(
            alignment: Alignment.bottomCenter,
            child: done ? AutoSizeText(widget.product.name, maxLines: 1, style: mainStyle) : Container()),
        flexibleSpace: Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: FlexibleSpaceBar(
                centerTitle: true,
                background: !done
                    ? FullScreenWidget(
                        backgroundColor: Colors.white,
                        child: ClipRRect(
                            borderRadius: BorderRadius.circular(16),
                            child: FadeTransition(
                                opacity: _animation,
                                child: widget.product.images.isNotEmpty
                                    ? Image(
                                        image: AdvImageCache(
                                            StaticVariables.imagePrefixUrl + widget.product.images[0].imageFileName,
                                            useMemCache: true,
                                            diskCacheExpire: const Duration(days: 400)),
                                        width: MediaQuery.of(context).size.width / 2,
                                        height: 120,
                                        fit: BoxFit.contain)
                                    : Image.asset('assets/logobw.png'))))
                    : widget.product.images.isNotEmpty
                        ? FullScreenWidget(
                            child: ClipRRect(
                                borderRadius: BorderRadius.circular(16),
                                child: Image(
                                    image: AdvImageCache(
                                        StaticVariables.imagePrefixUrl + widget.product.images[0].imageFileName,
                                        useMemCache: true,
                                        diskCacheExpire: const Duration(days: 400)),
                                    width: MediaQuery.of(context).size.width / 2,
                                    height: 120,
                                    fit: BoxFit.contain)))
                        : Image.asset('assets/logobw.png'))));
  }
}
