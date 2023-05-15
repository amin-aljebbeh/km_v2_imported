import '../../../../core/core_importer.dart';
import '../../domain/entities/shopper_report_entity.dart';
import '../redux/transactions_action.dart';

class ShopperReportWidget extends StatelessWidget {
  const ShopperReportWidget({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var store = StoreProvider.of<AppState>(context);
    return StoreConnector<AppState, AppState>(
      converter: (store) => store.state,
      distinct: true,
      builder: (context, state) {
        ShopperReportEntity report = state.transactionsState.shopperReport;
        return state.loadingState.loading.isNotEmpty && report == null
            ? const Loader()
            : Padding(
                padding: const EdgeInsets.only(top: 16),
                child: Row(
                  children: [
                    if (!Services.hasPermission(context, advancedTransactionPermission))
                      IconButton(
                        icon: Icon(Icons.arrow_back, size: 40, color: primaryColor),
                        onPressed: () {
                          if (state.transactionsState.hasNextTransactions) {
                            store.dispatch(NextTransactionsPage());
                            store.dispatch(GetTransactionsAction(adminId: state.adminsState.admin.id));
                          }
                        },
                      ),
                    Expanded(
                      child: Wrap(
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 8),
                            child: LabelRow(
                              rightSideText: 'مرابح الشهر : ',
                              leftSideText: report != null
                                  ? report.monthlyProfits != 'error'
                                      ? StringUtils().oCcy.format(int.parse(report.monthlyProfits).abs())
                                      : 'error'
                                  : 'error',
                              leftSideStyle: report != null
                                  ? report.monthlyProfits != 'error'
                                      ? int.parse(report.monthlyProfits).isNegative
                                          ? paragraphStyle.copyWith(color: Colors.red)
                                          : paragraphStyle.copyWith(color: Colors.green)
                                      : paragraphStyle.copyWith(color: Colors.red)
                                  : paragraphStyle.copyWith(color: Colors.red),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 8),
                            child: LabelRow(
                              rightSideText: 'مرابح اليوم : ',
                              leftSideText: report != null
                                  ? report.dailyProfits != 'error'
                                      ? StringUtils().oCcy.format(int.parse(report.dailyProfits).abs())
                                      : 'error'
                                  : 'error',
                              leftSideStyle: report != null
                                  ? report.dailyProfits != 'error'
                                      ? int.parse(report.dailyProfits).isNegative
                                          ? paragraphStyle.copyWith(color: Colors.red)
                                          : paragraphStyle.copyWith(color: Colors.green)
                                      : paragraphStyle.copyWith(color: Colors.red)
                                  : paragraphStyle.copyWith(color: Colors.red),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 8),
                            child: LabelRow(
                              rightSideText: 'عدد الطلبات : ',
                              leftSideText: report != null ? report.countOrderThisMonth : 'error',
                              leftSideStyle: report != null
                                  ? report.countOrderThisMonth != 'error'
                                      ? paragraphStyle.copyWith(color: Colors.green)
                                      : paragraphStyle.copyWith(color: Colors.red)
                                  : paragraphStyle.copyWith(color: Colors.red),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 8),
                            child: LabelRow(
                              rightSideText: 'ساعات العمل : ',
                              leftSideText: report != null ? report.workingHour : 'error',
                              leftSideStyle: report != null
                                  ? report.workingHour != 'error'
                                      ? paragraphStyle.copyWith(color: Colors.green)
                                      : paragraphStyle.copyWith(color: Colors.red)
                                  : paragraphStyle.copyWith(color: Colors.red),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 8),
                            child: LabelRow(
                              rightSideText: 'التقييم: ',
                              leftSideText: report != null ? report.avgOrderRating : 'error',
                              leftSideStyle: report != null
                                  ? report.avgOrderRating != 'error'
                                      ? paragraphStyle.copyWith(color: Colors.green)
                                      : paragraphStyle.copyWith(color: Colors.red)
                                  : paragraphStyle.copyWith(color: Colors.red),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 8),
                            child: LabelRow(
                              rightSideText: 'سرعة التوصيل: ',
                              leftSideText: report != null ? report.avgDeliveryMinutes : 'error',
                              leftSideStyle: report != null
                                  ? report.avgDeliveryMinutes != 'error'
                                      ? paragraphStyle.copyWith(color: Colors.green)
                                      : paragraphStyle.copyWith(color: Colors.red)
                                  : paragraphStyle.copyWith(color: Colors.red),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 8),
                            child: LabelRow(
                              rightSideText: 'مسافة التوصيل: ',
                              leftSideText: report != null
                                  ? report.deliveryDistance != 'error'
                                      ? (int.parse(report.deliveryDistance) / 1000).toString() + ' كم'
                                      : 'error'
                                  : 'error',
                              leftSideStyle: report != null
                                  ? report.deliveryDistance != 'error'
                                      ? paragraphStyle.copyWith(color: Colors.green)
                                      : paragraphStyle.copyWith(color: Colors.red)
                                  : paragraphStyle.copyWith(color: Colors.red),
                            ),
                          ),
                        ],
                      ),
                    ),
                    if (!Services.hasPermission(context, advancedTransactionPermission))
                      IconButton(
                        icon: Icon(Icons.arrow_forward, size: 40, color: primaryColor),
                        onPressed: () {
                          if (state.transactionsState.transactionsPage > 1) {
                            store.dispatch(PreviousTransactionsPage());
                            store.dispatch(GetTransactionsAction(adminId: state.adminsState.admin.id));
                          }
                        },
                      ),
                  ],
                ),
              );
      },
    );
  }
}
