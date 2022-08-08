import 'package:flutter/material.dart';
import 'package:kammun_app/modules/product/view/product_app_bar.dart';
import '../../../core/core_importer.dart';
import '../../authentication/view/login_view.dart';
import '../../cart/redux/cart_action.dart';
import '../redux/product_action.dart';
import 'product_details_counter.dart';

class ProductDetailView extends StatefulWidget {
  final ProductData product;
  final int initialCount;
  const ProductDetailView({Key key, this.product, this.initialCount}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return ProductDetailViewState();
  }
}

class ProductDetailViewState extends State<ProductDetailView> {
  int numberOfOrders;
  @override
  void initState() {
    super.initState();
    numberOfOrders = widget.initialCount;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      StoreProvider.of<AppState>(context).dispatch(UserVisitProduct(product: widget.product));
    });
  }

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, AppState>(
      converter: (store) => store.state,
      builder: (context, state) {
        return TemporaryLoading(
          child: Scaffold(
            body: NestedScrollView(
              physics: const AlwaysScrollableScrollPhysics(parent: BouncingScrollPhysics()),
              body: SafeArea(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: ListView(
                          physics: const AlwaysScrollableScrollPhysics(parent: BouncingScrollPhysics()),
                          children: [
                            SizedBox(
                              height: 50,
                              child: AutoSizeText(
                                widget.product.name,
                                style: TextStyle(
                                  fontWeight: FontWeight.w700,
                                  color: Colors.black,
                                  fontFamily: StringUtils.fontFamily,
                                  fontSize: 22,
                                ),
                              ),
                            ),
                            SizedBox(height: MediaQuery.of(context).size.height * 0.015),
                            Text(
                              widget.product.unit.toString() != 'null'
                                  ? widget.product.quantity.toString() + ' ' + widget.product.unit.toString()
                                  : widget.product.quantity.toString(),
                              style: TextStyle(
                                  fontWeight: FontWeight.w400,
                                  color: ColorUtils.primaryColor,
                                  fontFamily: StringUtils.fontFamily,
                                  fontSize: 20),
                            ),
                            SizedBox(height: MediaQuery.of(context).size.height * 0.003),
                            Text(
                                '${StringUtils().oCcy.format(int.parse(widget.product.price.toString().split('.')[0]))} ${state.startupState.startModel.company.currency}',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: ColorUtils.primaryColor,
                                    fontFamily: StringUtils.fontFamily,
                                    fontSize: 20)),
                            SizedBox(height: MediaQuery.of(context).size.height * 0.003),
                            if (state.startupState.startModel.subWarehouse
                                    .firstWhere((subWarehouse) => subWarehouse.id == widget.product.subWarehouseId)
                                    .displayName !=
                                'null')
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const KDivider(),
                                  Container(
                                    padding: const EdgeInsets.all(8),
                                    width: MediaQuery.of(context).size.width,
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          'الشركة',
                                          style: TextStyle(
                                            fontWeight: FontWeight.w700,
                                            color: Colors.black,
                                            fontFamily: StringUtils.fontFamily,
                                            fontSize: 22,
                                          ),
                                        ),
                                        Center(
                                            child: AutoSizeText(
                                          state.startupState.startModel.subWarehouse
                                              .firstWhere(
                                                  (subWarehouse) => subWarehouse.id == widget.product.subWarehouseId)
                                              .displayName,
                                          style: TextStyle(
                                            color: Colors.black,
                                            fontFamily: StringUtils.fontFamily,
                                            fontSize: 20,
                                          ),
                                        )),
                                        CircleAvatar(
                                          child: Image.asset('assets/logobw.png'),
                                          radius: 25,
                                          backgroundColor: ColorUtils.kmColors2,
                                        ),
                                      ],
                                    ),
                                  ),
                                  const KDivider(),
                                ],
                              ),
                            SizedBox(height: MediaQuery.of(context).size.height * 0.015),
                            AutoSizeText(
                              widget.product.description.split('@')[0],
                              style: TextStyle(
                                  fontWeight: FontWeight.w400,
                                  color: Theme.of(context).primaryColorDark,
                                  fontFamily: StringUtils.fontFamily,
                                  fontSize: 20),
                            ),
                          ],
                        ),
                      ),
                    ),
                    KCard(
                      color: ColorUtils.silverColor,
                      radius: 0,
                      child: Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Column(
                          children: [
                            SizedBox(
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'الكمية المضافة',
                                    style: TextStyle(
                                      fontWeight: FontWeight.w700,
                                      color: Colors.black,
                                      fontFamily: StringUtils.fontFamily,
                                      fontSize: 22,
                                    ),
                                  ),
                                  ProductDetailsCounter(
                                    initialCount: state.cartState.cartProducts
                                        .firstWhere((product) => product.id == widget.product.id,
                                            orElse: () => ProductData(productCount: 1))
                                        .productCount,
                                    productId: widget.product.id,
                                    onAdd: (count) => setState(() => numberOfOrders = count),
                                    onRemove: (count) => setState(() => numberOfOrders = count),
                                  )
                                ],
                              ),
                              width: MediaQuery.of(context).size.width,
                            ),
                            const SizedBox(height: 25),
                            SizedBox(
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  KButton(
                                    width: MediaQuery.of(context).size.width * 0.7,
                                    text: StringUtils.addToCart +
                                        ' ' +
                                        '(${StringUtils().oCcy.format(numberOfOrders * int.parse(widget.product.price.toString().split('.')[0]))})',
                                    height: 50,
                                    color: ColorUtils.primaryColor,
                                    onTap: () {
                                      if (!(widget.product.maxCount.contains('-') || widget.product.maxCount == '0') &&
                                          int.parse(widget.product.maxCount.replaceAll('-', '').split('.')[0]) <
                                              numberOfOrders) {
                                        flushbar(
                                            message:
                                                'لا يمكن إضافة $numberOfOrders من ${widget.product.name} لعدم وجود كمية كافية الرجاء تخفيض الكمية',
                                            color: Colors.red,
                                            icon: Icons.error);
                                      } else {
                                        if (state.authenticationState.token.length > 5) {
                                          ProductData product = widget.product.copyWith(
                                              productCount: numberOfOrders != 1
                                                  ? widget.initialCount == 1
                                                      ? numberOfOrders
                                                      : numberOfOrders - widget.initialCount
                                                  : widget.initialCount == 1 ? 1 : -(widget.initialCount - 1));
                                          StoreProvider.of<AppState>(context).dispatch(AddProductToCart(
                                              product: product, context: context, pop: true, sync: true));
                                          flushbar(
                                              message: 'تم إضافة ${widget.product.name} لسلة المشتريات',
                                              color: Colors.green,
                                              icon: Icons.shopping_cart);
                                          StoreProvider.of<AppState>(context).dispatch(CalculateSubTotal());
                                          StoreProvider.of<AppState>(context).dispatch(CheckLimitTotalCost(pop: true));
                                        } else {
                                          StoreProvider.of<AppState>(context)
                                              .dispatch(PushAndReplace(routeName: LoginScreen.routeName));
                                        }
                                      }
                                    },
                                  ),
                                  FavoriteIcon(
                                      radius: 10, productName: widget.product.name, productId: widget.product.id),
                                ],
                              ),
                              width: MediaQuery.of(context).size.width,
                            ),
                            const SizedBox(height: 15),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              headerSliverBuilder: (context, isScrolled) => [ProductAppBar(productImages: widget.product.images)],
            ),
          ),
        );
      },
    );
  }
}
