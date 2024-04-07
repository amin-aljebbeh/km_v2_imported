import 'package:kammun_app/core/core_importer.dart';
import 'package:kammun_app/features/orders/domain/entities/order_entity.dart';

import '../../../order_details/order_details_services.dart';
import '../../../order_details/presentation/redux/order_details_action.dart';
import '../../../orders/domain/entities/order_image_entity.dart';
import '../../../transactions/presentation/pages/add_transaction_page.dart';


class SearchOrderAccounting extends StatefulWidget {
  final OrderEntity order;
  final Function onDelete;

  const SearchOrderAccounting({Key key, @required this.order, this.onDelete}) : super(key: key);

  @override
  _OrderAccountingState createState() => _OrderAccountingState();
}

class _OrderAccountingState extends State<SearchOrderAccounting> {
  List<InkWell> imageWidgets = [];
  List<OrderImageEntity> images = [];

  @override
  void initState() {
    if (widget.order.images != null) if (widget.order.images.isNotEmpty) images.addAll(widget.order.images);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.order.images != null) {
      if (widget.order.images.isNotEmpty) {
        imageWidgets = getImages(
          images: widget.order.images,
          context: context,
          onDelete: (i) {
            widget.order.images.removeWhere((image) => image.id == widget.order.images[i].id);
            images.clear();
            images.addAll(widget.order.images);
            widget.onDelete();
          },
        );
      }
    }
    return StoreConnector<AppState, AppState>(
      converter: (store) => store.state,
      distinct: true,
      builder: (context, state) {
        return Scaffold(
          body: SafeArea(
            child: Stack(
              children: [
                ListView(
                  children: [
                    Column(children: calculate(order: widget.order, context: context)),
                    Container(
                        height: MediaQuery.of(context).size.height * 0.35,
                        margin: EdgeInsets.only(bottom: MediaQuery.of(context).size.height * 0.4),
                        child: GridView(
                            scrollDirection: Axis.vertical,
                            primary: false,
                            shrinkWrap: true,
                            padding: const EdgeInsets.only(left: 0, right: 0, top: 4, bottom: 4),
                            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2, crossAxisSpacing: 8, mainAxisSpacing: 8, childAspectRatio: 2),
                            children: imageWidgets)),
                  ],
                ),
                Positioned(
                  bottom: 25,
                  right: MediaQuery.of(context).size.width * 0.05,
                  child: Column(
                    children: [
                      AddImageWidget(
                        onSubmit: (image) => StoreProvider.of<AppState>(context)
                            .dispatch(AddImageToOrderAction(context: context, orderId: widget.order.id, image: image)),
                      ),
                      if (Services.hasPermission(context, transactionPermission))
                        if(!Services.hasRole(context,productsControllerRole ) || !Services.hasRole(context,operationManagerRole )|| !Services.hasRole(context,superAdminRole)  )
                          KammunButton(
                          color: kmColors,
                          onTap: () {
                            if (widget.order.shopper == null) {
                              Toast.show('هذا الطلب غير مسند لمتسوق', 
                                  duration: Toast.lengthLong, gravity: Toast.center);
                            } else {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => AddTransactionPage(
                                            orderId: widget.order.id,
                                            orderRequired: 1,
                                            userId: int.parse(widget.order.userId),
                                          )));
                            }
                          },
                          text: addTransaction,
                          width: MediaQuery.of(context).size.width * 0.9,
                          height: 50,
                        ),
                      if (!Services.hasRole(context, supplierRole))
                        KammunButton(
                          color: kmColors,
                          onTap: () => StoreProvider.of<AppState>(context)
                              .dispatch(GetOrderInvoice(orderId: widget.order.id, context: context)),
                          text: 'تفاصيل فاتورة الزبون',
                          width: MediaQuery.of(context).size.width * 0.9,
                          height: 50,
                        ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
