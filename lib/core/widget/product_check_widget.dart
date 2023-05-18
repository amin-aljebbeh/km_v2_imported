import '../../core/core_importer.dart';

class ProductCheckWidget extends StatefulWidget {
  final bool preferLeftSide;
  final String productCount;
  final String productName;
  final int index;
  final Function(int) onCheckbox;

  final OrderProduct product;

  const ProductCheckWidget({
    Key key,
    @required this.preferLeftSide,
    @required this.productCount,
    @required this.productName,
    @required this.index,
    @required this.onCheckbox,
    @required this.product,
  }) : super(key: key);

  @override
  _ProductCheckWidgetState createState() => _ProductCheckWidgetState();
}

class _ProductCheckWidgetState extends State<ProductCheckWidget> {
  @override
  Widget build(BuildContext context) {
    return widget.preferLeftSide
        ? Row(
            children: [
              if (Services.hasRole(context, operationManagerRole) || widget.product.pivot.deletedAt != 'null')
                Column(
                  children: [
                    PrimeProductWidget(product: widget.product),
                    RotatedBox(
                      quarterTurns: 1,
                      child: SwitchProductStatusWidget(
                        isForSubWarehouse: true,
                        height: 20,
                        width: 65,
                        preState: widget.product.isActive,
                        subWarehouseId: widget.product.subWarehouseId,
                        productId: widget.product.pivot.productId,
                        onChange: (int active, bool result) {
                          setState(() {
                            if (result) widget.product.isActive = active;
                          });
                        },
                      ),
                    ),
                  ],
                ),
              // if (Services.authorized(context, supplierRol))
              //   KOutlinedButton(
              //       text: 'المنتج غير متوفر',
              //       color: kmColors2,
              //       onTap: () {},
              //       width: MediaQuery.of(context).size.width / 5),
              Column(
                children: [
                  Container(
                    padding: const EdgeInsets.all(3.0),
                    decoration: BoxDecoration(
                        borderRadius: const BorderRadius.all(Radius.circular(10.0)),
                        border: Border.all(color: primaryColor, width: 2)),
                    child: Center(child: Text(widget.productCount, style: mainStyle.copyWith(fontSize: 30))),
                  ),
                  IconButton(
                      icon: const Icon(Icons.library_add_check_outlined, color: Colors.green),
                      onPressed: () {
                        if (widget.productCount != '1') {
                          List<DialogButton> decisionButtons = [
                            DialogButton(
                              text: 'نعم',
                              onTap: () {
                                Navigator.of(context).pop();
                                widget.onCheckbox(widget.index);
                              },
                            ),
                            DialogButton(text: 'لا', onTap: () => Navigator.of(context).pop()),
                          ];
                          showMyDialog(
                              context: context,
                              title: 'تحقق من الكمية',
                              text: 'هل أنت متأكد انك وجدت ${widget.productCount} قطعة من ${widget.productName}',
                              dialogButtons: decisionButtons);
                        } else {
                          widget.onCheckbox(widget.index);
                        }
                      }),
                ],
              ),
            ],
          )
        : Container();
  }
}
