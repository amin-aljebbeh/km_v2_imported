import 'package:kammun_app/core/core_importer.dart';
import 'package:kammun_app/features/order_details/invoice_view.dart';
import 'package:kammun_app/features/transactions/presentation/pages/add_transaction_page.dart';

import '../transactions/domain/entities/admin_transaction_entity.dart';
import '../transactions/presentation/redux/transactions_action.dart';
import 'services/order_details_services.dart';

class OrderAccounting extends StatefulWidget {
  final OrdersOriginalData orderData;
  final Function onDelete;

  const OrderAccounting({Key key, @required this.orderData, this.onDelete}) : super(key: key);

  @override
  _OrderAccountingState createState() => _OrderAccountingState();
}

class _OrderAccountingState extends State<OrderAccounting> {
  List<Widget> subWarehouseTotal = [];
  List<InkWell> imageWidgets = [];
  List<OrderImage> images = [];

  @override
  void initState() {
    if (widget.orderData.images.isNotEmpty) images.addAll(widget.orderData.images);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    subWarehouseTotal = OrderDetailsServices.calculate(order: widget.orderData);
    if (widget.orderData.images != null) {
      if (widget.orderData.images.isNotEmpty) {
        imageWidgets = OrderDetailsServices.getImages(
          images: widget.orderData.images,
          context: context,
          onDelete: (i) {
            setState(() {
              widget.orderData.images.removeWhere((image) => image.id == widget.orderData.images[i].id);
              images.clear();
              images.addAll(widget.orderData.images);
              widget.onDelete();
            });
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
                    Column(children: subWarehouseTotal),
                    SizedBox(
                        height: MediaQuery.of(context).size.height * 0.35,
                        child: GridView(
                            scrollDirection: Axis.vertical,
                            primary: false,
                            shrinkWrap: true,
                            padding: const EdgeInsets.only(left: 0, right: 0, top: 4, bottom: 4),
                            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2, crossAxisSpacing: 8, mainAxisSpacing: 8, childAspectRatio: 2),
                            children: imageWidgets)),
                    SizedBox(height: MediaQuery.of(context).size.height * 0.4),
                  ],
                ),
                Positioned(
                  bottom: 25,
                  right: MediaQuery.of(context).size.width * 0.05,
                  child: Column(
                    children: [
                      AddImageWidget(
                        onSubmit: (image) async {
                          bool result = await OrderDetailsServices.addImageToOrderService(
                              image: image, orderId: widget.orderData.id.toString());
                          if (result) {
                            snackBar(success: result, message: 'نجحت عملية إضافة الصورة', context: context);
                          } else {
                            snackBar(success: result, message: 'فشلت عملية إضافة الصورة', context: context);
                          }
                        },
                      ),
                      if (Services.isOperationManager())
                        KammunButton(
                          color: kmColors,
                          onTap: () {
                            if (widget.orderData.shopper == null) {
                              Toast.show('هذا الطلب غير مسند لمتسوق', context,
                                  duration: Toast.LENGTH_LONG, gravity: Toast.CENTER);
                            } else {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          AddTransactionPage(orderId: widget.orderData.id, orderRequired: 1)));
                            }
                          },
                          text: addTransaction,
                          width: MediaQuery.of(context).size.width * 0.9,
                          height: 50,
                        ),
                      if (Services.isShopper())
                        KammunButton(
                          onTap: () {
                            final moneyController = TextEditingController();
                            final descriptionController = TextEditingController();
                            List<Widget> decisionButton = [
                              DialogButton(
                                text: 'نعم',
                                onTap: () async {
                                  Navigator.of(context).pop();
                                  StoreProvider.of<AppState>(context).dispatch(CreateTransactionAction(
                                      context: context,
                                      pop: false,
                                      transactionEntity: AdminTransactionEntity(
                                          transactionCategoryId: state.transactionsState.categories
                                              .firstWhere((category) => category.slug == 'compensation-request')
                                              .id,
                                          userId: int.parse(widget.orderData.userId),
                                          adminId: state.adminsState.admin.id,
                                          value: int.parse(moneyController.text),
                                          description: descriptionController.text,
                                          orderId: widget.orderData.id)));
                                },
                              ),
                              const CloseWidget()
                            ];
                            showMyDialog(
                                title: 'طلب تعويض',
                                context: context,
                                dialogButtons: decisionButton,
                                content: Column(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.all(8),
                                      child: TextFieldRow(
                                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                                        controller: moneyController,
                                        text: 'المبلغ :         ',
                                        inputType: TextInputType.text,
                                        width: 150,
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(horizontal: 8),
                                      child: TextFieldRow(
                                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                                        controller: descriptionController,
                                        text: 'الوصف :',
                                        inputType: TextInputType.text,
                                        width: 150,
                                      ),
                                    ),
                                  ],
                                ));
                          },
                          text: 'طلب تعويض',
                          width: MediaQuery.of(context).size.width * 0.9,
                          color: kmColors,
                          height: 50,
                        ),
                      if (Services.isAgent())
                        KammunButton(
                          color: kmColors,
                          onTap: () => Navigator.push(context,
                              MaterialPageRoute(builder: (context) => AddComplaintPage(orderData: widget.orderData))),
                          text: 'إضافة شكوى',
                          width: MediaQuery.of(context).size.width * 0.9,
                          height: 50,
                        ),
                      if (!Services.isSupplierManager())
                        KammunButton(
                          color: kmColors,
                          onTap: () => Navigator.push(context,
                              MaterialPageRoute(builder: (context) => InvoiceView(orderId: widget.orderData.id))),
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
