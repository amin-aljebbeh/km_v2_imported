import 'package:kammun_app/features/cart/domain/entities/invoice_product_entity.dart';
import 'package:kammun_app/features/cart/domain/entities/submit_order_entity.dart';
import 'package:kammun_app/features/cart/presentation/redux/cart_action.dart';
import 'package:kammun_app/features/cart/presentation/widgets/cart_product_widget.dart';

import '../../../../core/core_importer.dart';

class FinalCartPage extends StatelessWidget {
  const FinalCartPage({Key key, this.userNotes}) : super(key: key);
  final TextEditingController userNotes;

  @override
  Widget build(BuildContext context) {
    var store = StoreProvider.of<AppState>(context);
    return StoreConnector<AppState, AppState>(
      converter: (store) => store.state,
      distinct: true,
      builder: (context, state) {
        return TemporaryLoading(
          child: Scaffold(
            backgroundColor: Colors.white,
            body: Padding(
              padding: const EdgeInsets.only(left: 20, top: 10, right: 20, bottom: 0),
              child: SafeArea(
                child: state.loadingState.loading.isNotEmpty
                    ? const Center(child: Loader())
                    : Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          state.errorState.isError
                              ? AlertMessages(
                                  text: state.errorState.errorMessage,
                                  messageType: 'internetError',
                                  headerText: ' حدث خطأ اثناء محاولة إرسال طلبك')
                              : Container(padding: EdgeInsets.zero),
                          Padding(
                            padding: const EdgeInsets.only(bottom: 8.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: <Widget>[
                                Padding(
                                  padding: const EdgeInsets.only(bottom: 10.0),
                                  child: IconButton(
                                    icon:
                                        Icon(Icons.arrow_back_ios, color: Theme.of(context).primaryColorDark, size: 45),
                                    onPressed: () {
                                      store.dispatch(NoError());
                                      store.dispatch(SetEditIndex(index: -1));
                                      Navigator.of(context).pop('updatePrice');
                                    },
                                  ),
                                ),
                                InkWell(
                                  onTap: () => Navigator.of(context).pop('updatePrice'),
                                  child: Text(shoppingCart,
                                      style: mainStyle.copyWith(fontWeight: FontWeight.w700, fontSize: 30)),
                                ),
                              ],
                            ),
                          ),
                          Expanded(
                            child: ListView.builder(
                              primary: false,
                              shrinkWrap: true,
                              itemCount: state.cartState.cartProducts.length,
                              itemBuilder: (BuildContext context, int index) {
                                return CartProductWidget(index: index);
                              },
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 30, bottom: 15),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Text(
                                  subtotalString,
                                  style: mainStyle.copyWith(
                                      fontWeight: FontWeight.w400,
                                      color: Theme.of(context).primaryColorDark,
                                      fontSize: 17.0),
                                ),
                                Text(
                                  StringUtils().oCcy.format(state.cartState.cartProducts.fold(
                                          0,
                                          (sum, order) =>
                                              sum + (int.parse(order.price.split('.')[0]) * order.productCount))) +
                                      state.generalInformationState.companyInformation.currency,
                                  style: mainStyle.copyWith(
                                      fontWeight: FontWeight.w500,
                                      color: Theme.of(context).primaryColorDark,
                                      fontSize: 17.0),
                                ),
                              ],
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Text(delivery,
                                  style: mainStyle.copyWith(
                                    fontWeight: FontWeight.w400,
                                    color: Theme.of(context).primaryColorDark,
                                    fontSize: 16.0,
                                  )),
                              Text(
                                StringUtils().oCcy.format(state.cartState.deliveryPrice) +
                                    state.generalInformationState.companyInformation.currency,
                                style: mainStyle.copyWith(
                                    fontWeight: FontWeight.w500,
                                    color: Theme.of(context).primaryColorDark,
                                    fontSize: 16),
                              ),
                            ],
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 15, bottom: 10),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Text(totalString,
                                    style: mainStyle.copyWith(
                                      fontWeight: FontWeight.w700,
                                      color: Theme.of(context).primaryColorDark,
                                      fontSize: 19.0,
                                    )),
                                Text(
                                  StringUtils().oCcy.format(state.cartState.cartProducts.fold(
                                              0,
                                              (sum, order) =>
                                                  sum + (int.parse(order.price.split('.')[0]) * order.productCount)) +
                                          state.cartState.deliveryPrice) +
                                      state.generalInformationState.companyInformation.currency,
                                  style: mainStyle.copyWith(
                                      fontWeight: FontWeight.w700,
                                      color: Theme.of(context).primaryColorDark,
                                      fontSize: 19),
                                ),
                              ],
                            ),
                          ),
                          SafeArea(
                            child: state.loadingState.loading.isNotEmpty
                                ? const Loader()
                                : Column(
                                    children: <Widget>[
                                      if (state.cartState.orderUnderUpdateStatus == 5)
                                        Row(
                                          children: [
                                            Checkbox(
                                                value: state.cartState.refund,
                                                onChanged: (bool value) => store.dispatch(SetRefund(refund: value)),
                                                activeColor: primaryColor),
                                            Text('شحن المحفظة',
                                                style: decisionButtonStyle.copyWith(color: Colors.black)),
                                          ],
                                        ),
                                      if (Services.hasRole(context, agentRole) ||
                                          Services.hasRole(context, superAdminRole))
                                        KammunButton(
                                          color: primaryColor,
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: <Widget>[
                                              Container(
                                                alignment: Alignment.center,
                                                padding: const EdgeInsets.only(top: 0, bottom: 0, right: 15),
                                                child:
                                                    const Icon(Icons.add_box_outlined, color: Colors.white, size: 32),
                                              ),
                                              Expanded(
                                                child: Align(
                                                  alignment: Alignment.center,
                                                  child: Text(
                                                    'إضافة ملاحظة',
                                                    textAlign: TextAlign.start,
                                                    style: mainStyle.copyWith(
                                                        color: Colors.white, fontWeight: FontWeight.bold),
                                                  ),
                                                ),
                                              ),
                                              const Icon(Icons.add, color: Colors.transparent, size: 32),
                                            ],
                                          ),
                                          onTap: () {
                                            showMyDialog(
                                              context: context,
                                              title: 'إضافة ملاحظة',
                                              dialogButtons: [],
                                              content: Stack(
                                                clipBehavior: Clip.none,
                                                children: <Widget>[
                                                  Positioned(
                                                    right: -40.0,
                                                    top: -40.0,
                                                    child: InkResponse(
                                                        onTap: () => Navigator.of(context).pop(),
                                                        child: const CircleAvatar(
                                                            child: Icon(Icons.close), backgroundColor: Colors.red)),
                                                  ),
                                                  Column(
                                                    mainAxisSize: MainAxisSize.min,
                                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                    children: <Widget>[
                                                      Padding(
                                                        padding: const EdgeInsets.all(8.0),
                                                        child: Text('ملاحظات على الطلب',
                                                            style: mainStyle.copyWith(
                                                                fontWeight: FontWeight.w700, fontSize: 18)),
                                                      ),
                                                      Container(
                                                        padding: const EdgeInsets.only(left: 8, right: 8),
                                                        decoration: BoxDecoration(
                                                            borderRadius: const BorderRadius.all(Radius.circular(5.0)),
                                                            border: Border.all(width: 2, color: kmColors)),
                                                        child: TextField(
                                                          controller: userNotes,
                                                          textAlign: TextAlign.right,
                                                          keyboardType: TextInputType.multiline,
                                                          maxLines: 5,
                                                          style: mainStyle,
                                                        ),
                                                      ),
                                                      KammunButton(
                                                        text: save + ' ' + note,
                                                        width: MediaQuery.of(context).size.width / 2.5,
                                                        height: 40,
                                                        color: primaryColor,
                                                        onTap: () {
                                                          store.dispatch(SetUserNote(note: userNotes.text));
                                                          Navigator.of(context).pop();
                                                        },
                                                      ),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                            );
                                          },
                                        ),
                                      KammunButton(
                                        width: MediaQuery.of(context).size.width,
                                        color:
                                            state.cartState.cartProducts.isNotEmpty ? primaryColor : Colors.grey[400],
                                        text: confirmOrder,
                                        padding: const EdgeInsets.only(bottom: 10, top: 10),
                                        onTap: () {
                                          List<InvoiceProductEntity> products = state.cartState.cartProducts
                                              .map((product) => InvoiceProductEntity(
                                                  quantity: product.productCount,
                                                  price: int.parse(product.price.split('.')[0]) +
                                                      (product.pivot == null ? 0 : product.pivot.increaseValue),
                                                  productId: product.id))
                                              .toList();
                                          int purchasePrices = state.cartState.cartProducts.fold(
                                              0,
                                              (value, product) =>
                                                  value +
                                                  (product.productCount *
                                                      (int.parse(product.price.split('.')[0]) +
                                                          (product.pivot == null ? 0 : product.pivot.increaseValue))));
                                          SubmitOrderEntity submitOrderEntity = SubmitOrderEntity(
                                              products: products,
                                              purchasePrices: purchasePrices,
                                              userNote: userNotes.text,
                                              checkChangedPriceProduct: 1,
                                              saveRefund: state.cartState.refund ? 1 : 0);
                                          store.dispatch(NoError());
                                          store.dispatch(UpdateOrderAction(
                                              submitOrderEntity: submitOrderEntity, context: context));
                                        },
                                        height: 50,
                                      ),
                                    ],
                                  ),
                            top: false,
                          ),
                        ],
                      ),
              ),
            ),
          ),
        );
      },
    );
  }
}
