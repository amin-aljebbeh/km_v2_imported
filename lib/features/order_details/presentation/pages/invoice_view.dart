import 'package:kammun_app/features/orders/domain/entities/show_data_entity.dart';

import '../../../../core/core_importer.dart';
import '../../../orders/domain/entities/key_value_info_entity.dart';
import '../widgets/invoice_info_widget.dart';
import '../widgets/invoice_row.dart';

class InvoiceView extends StatelessWidget {
  const InvoiceView({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, AppState>(
      converter: (store) => store.state,
      distinct: true,
      builder: (context, state) {
        List<KeyValueInfoEntity> invoiceInfo = [];
        List<KeyValueInfoEntity> paymentInfo = [];
        KeyValueInfoEntity lastOne;
        ShowDataEntity invoice = state.orderDetailsState.invoice;
        if (invoice != null) {
          invoiceInfo.addAll(invoice.invoiceInfo);
          invoiceInfo.removeLast();
          lastOne = invoice.invoiceInfo.last;
          paymentInfo.addAll(invoice.paymentInfo);
        }
        return Scaffold(
          resizeToAvoidBottomInset: true,
          appBar: AppBar(
              backgroundColor: primaryColor,
              title: Text('فاتورة الزبون', style: boldStyle.copyWith(color: Colors.white))),
          body: SafeArea(
            child: SizedBox(
              height: MediaQuery.of(context).size.height,
              child: state.loadingState.loading.isNotEmpty
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
                              if (paymentInfo.isNotEmpty)
                                InvoiceInfoWidget(title: 'تفاصيل الدفع', children: paymentInfo),
                            ],
                          ),
                        ),
                      ],
                    ),
            ),
          ),
        );
      },
    );
  }
}
