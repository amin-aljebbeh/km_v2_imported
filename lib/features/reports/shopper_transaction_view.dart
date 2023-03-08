import 'package:intl/intl.dart';
import 'package:kammun_app/features/reports/services/reports_services.dart';

import '../../core/core_importer.dart';
import 'models/report_model_importer.dart';

class ShopperTransactionView extends StatefulWidget {
  static const String routeName = '/ShopperTransactionView';
  const ShopperTransactionView({Key key}) : super(key: key);

  @override
  _ShopperTransactionViewState createState() => _ShopperTransactionViewState();
}

class _ShopperTransactionViewState extends State<ShopperTransactionView> {
  bool error;
  bool empty;
  bool loading;
  bool profitLoading;
  List<TransactionModel> transactions = [];
  MonthlyProfit profit;

  @override
  void initState() {
    error = false;
    empty = true;
    loading = false;
    setState(() => profitLoading = true);
    getMonthlyProfit(StaticVariables.shopper.id.toString());
    getTransaction(StaticVariables.shopper.id.toString());
    super.initState();
  }

  getTransaction(String shopperId) async {
    setState(() {
      if (transactions != null) {
        error = false;
        transactions.clear();
      }
    });
    var tempTransactions = await ReportsServices.getShopperTransaction();
    setState(() {
      loading = false;
      if (tempTransactions != null) {
        error = false;
        empty = false;
        transactions = tempTransactions;
        if (transactions.isEmpty) empty = true;
      } else {
        error = true;
      }
    });
  }

  getMonthlyProfit(String shopperId) async {
    MonthlyProfit result = await ReportsServices.getShopperMonthProfitService(shopperId: shopperId);
    setState(() {
      profitLoading = false;
      profit = result;
    });
  }

  @override
  Widget build(BuildContext context) {
    bool newTransaction(int index) {
      if (index == 0) return true;
      return transactions[index].createdAt.toString().split(' ')[0] !=
          transactions[index - 1].createdAt.toString().split(' ')[0];
    }

    return Scaffold(
      backgroundColor: Theme.of(context).primaryColorLight,
      resizeToAvoidBottomInset: false,
      appBar: AppBar(backgroundColor: primaryColor, title: Text('كشف حساب متسوق', style: appBarStyle)),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(left: 20, top: 0, right: 20, bottom: 10),
          child: ListView(
            children: [
              const SizedBox(height: 20),
              profitLoading
                  ? const Loader()
                  : Wrap(
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          child: LabelRow(
                            rightSideText: 'مرابح الشهر : ',
                            leftSideText: profitLoading
                                ? 'جار الاتصال'
                                : profit != null
                                    ? StringUtils().oCcy.format(int.parse(profit.profit).abs()).toString()
                                    : 'error',
                            leftSideStyle: profitLoading
                                ? paragraphStyle
                                : profit != null
                                    ? int.parse(profit.profit).isNegative
                                        ? loseStyle
                                        : profitStyle
                                    : loseStyle,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8),
                          child: LabelRow(
                            rightSideText: 'عدد الطلبات : ',
                            leftSideText: profitLoading
                                ? 'جار الاتصال'
                                : profit != null
                                    ? profit.countOrderThisMonth.toString()
                                    : 'error',
                            leftSideStyle: profitLoading
                                ? paragraphStyle
                                : profit != null
                                    ? profitStyle
                                    : loseStyle,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8),
                          child: LabelRow(
                            rightSideText: 'ساعات العمل : ',
                            leftSideText: profitLoading
                                ? 'جار الاتصال'
                                : profit != null
                                    ? profit.workingHour.toString()
                                    : 'error',
                            leftSideStyle: profitLoading
                                ? paragraphStyle
                                : profit != null
                                    ? profitStyle
                                    : loseStyle,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8),
                          child: LabelRow(
                            rightSideText: 'التقييم: ',
                            leftSideText: profitLoading
                                ? 'جار الاتصال'
                                : profit != null
                                    ? profit.avgOrderRating.toString()
                                    : 'error',
                            leftSideStyle: profitLoading
                                ? paragraphStyle
                                : profit != null
                                    ? profitStyle
                                    : loseStyle,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8),
                          child: LabelRow(
                            rightSideText: 'سرعة التوصيل: ',
                            leftSideText: profitLoading
                                ? 'جار الاتصال'
                                : profit != null
                                    ? profit.avgDeliveryMinutes.toString()
                                    : 'error',
                            leftSideStyle: profitLoading
                                ? paragraphStyle
                                : profit != null
                                    ? profitStyle
                                    : loseStyle,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8),
                          child: LabelRow(
                            rightSideText: 'مسافة التوصيل: ',
                            leftSideText: profitLoading
                                ? 'جار الاتصال'
                                : profit != null
                                    ? (int.parse(profit.deliveryDistance) / 1000).toString() + ' كم'
                                    : 'error',
                            leftSideStyle: profitLoading
                                ? paragraphStyle
                                : profit != null
                                    ? profitStyle
                                    : loseStyle,
                          ),
                        ),
                      ],
                    ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  KammunButton(
                    height: 50,
                    text: '  المستحقات  ',
                    color: primaryColor,
                    onTap: () => ReportsServices.financialDues(
                        context: context, shopperId: StaticVariables.shopper.id.toString()),
                  ),
                  KammunButton(
                    height: 50,
                    text: '  إحصائيات  ',
                    color: primaryColor,
                    onTap: () =>
                        Navigator.push(context, MaterialPageRoute(builder: (context) => const ShopperInformation())),
                  ),
                ],
              ),
              SizedBox(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height * 0.65,
                child: error
                    ? Center(
                        child: AlertMessages(text: errorMessage, messageType: 'internetError', headerText: 'حدث خطأ'))
                    : loading
                        ? const Loader()
                        : empty
                            ? const Padding(padding: EdgeInsets.all(75), child: ScreenMessage(message: 'لا يوجد حركة'))
                            : ListView.builder(
                                scrollDirection: Axis.vertical,
                                itemCount: transactions.length,
                                itemBuilder: (BuildContext context, int index) {
                                  return Transaction(
                                    transaction: transactions[index],
                                    newTransaction: newTransaction(index),
                                    show: (date) {
                                      int kammunProfit = transactions
                                          .where((transaction) =>
                                              transaction.createdAt.toString().split(' ')[0] ==
                                              date.toString().split(' ')[0])
                                          .toList()
                                          .fold(0, (value, transaction) => value + int.parse(transaction.valueCompany));

                                      int shopperProfit = transactions
                                          .where((transaction) =>
                                              transaction.createdAt.toString().split(' ')[0] ==
                                              date.toString().split(' ')[0])
                                          .toList()
                                          .fold(0, (value, transaction) => value + int.parse(transaction.valueShopper));
                                      showMyDialog(
                                        context: context,
                                        title:
                                            'مرابح ${DateFormat('EEEE', 'ar').format(date) + ' ' + DateFormat('dd-MM-yyyy', 'en').format(date)}',
                                        content: Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                                          children: [
                                            Column(
                                              children: [
                                                Text(shopper, style: mainStyle),
                                                Text(StringUtils().oCcy.format(shopperProfit.abs()).toString(),
                                                    style: shopperProfit.isNegative ? loseStyle : profitStyle),
                                              ],
                                            ),
                                            Column(
                                              children: [
                                                Text(kammun, style: mainStyle),
                                                Text(StringUtils().oCcy.format(kammunProfit.abs()).toString(),
                                                    style: kammunProfit.isNegative ? loseStyle : profitStyle),
                                              ],
                                            ),
                                          ],
                                        ),
                                        dialogButtons: [const CloseWidget()],
                                      );
                                    },
                                  );
                                },
                              ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
