import '../../core/core_importer.dart';
import '../orders/model/get_order_model.dart';
import '../orders/services/order_services.dart';
import 'invoice_info_widget.dart';
import 'invoice_row.dart';

class InvoiceView extends StatefulWidget {
  final int orderId;
  const InvoiceView({Key key, this.orderId}) : super(key: key);

  @override
  _InvoiceViewState createState() => _InvoiceViewState();
}

class _InvoiceViewState extends State<InvoiceView> {
  List<KeyValueModel> invoiceInfo = [];
  List<KeyValueModel> paymentInfo = [];
  KeyValueModel lastOne;
  bool loading;
  Future future;
  @override
  void initState() {
    future = getInvoice();
    super.initState();
  }

  getInvoice() async {
    setState(() => loading = true);
    ShowData showData = (await OrderServices.getOrder(orderId: widget.orderId.toString())).showData;
    invoiceInfo.addAll(showData.invoiceInfo);
    invoiceInfo.removeLast();
    lastOne = showData.invoiceInfo.last;
    paymentInfo.addAll(showData.paymentInfo);
    setState(() => loading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
          backgroundColor: primaryColor,
          title: Text('فاتورة الزبون', style: TextStyle(fontFamily: fontFamily, fontWeight: FontWeight.bold))),
      body: SafeArea(
        child: SizedBox(
          height: MediaQuery.of(context).size.height,
          child: loading
              ? const Center(child: Loader())
              : ListView(
                  physics: const AlwaysScrollableScrollPhysics(parent: BouncingScrollPhysics()),
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 20, right: 20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          InvoiceInfoWidget(title: 'تفاصيل الفاتورة', children: invoiceInfo),
                          KCard(
                            radius: const BorderRadius.all(Radius.circular(6)),
                            child: InvoiceRow(
                              style: informationStyle.copyWith(color: kmColors),
                              children: lastOne.info,
                              title: lastOne.key,
                              info: StringUtils().oCcy.format(int.parse(lastOne.value.split('.')[0])),
                            ),
                          ),
                          paymentInfo.isNotEmpty
                              ? InvoiceInfoWidget(title: 'تفاصيل الدفع', children: paymentInfo)
                              : const SizedBox(height: 25),
                        ],
                      ),
                    ),
                  ],
                ),
        ),
      ),
    );
  }
}
