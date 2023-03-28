import '../../../../core/core_importer.dart';
import '../../domain/entities/shopper_report_entity.dart';

class ShopperReportWidget extends StatelessWidget {
  const ShopperReportWidget({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, AppState>(
      converter: (store) => store.state,
      distinct: true,
      builder: (context, state) {
        ShopperReportEntity report = state.transactionsState.shopperReport;
        return state.loadingState.loading.isNotEmpty
            ? const Loader()
            : Wrap(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    child: LabelRow(
                      rightSideText: 'مرابح الشهر : ',
                      leftSideText:
                          report != null ? StringUtils().oCcy.format(int.parse(report.monthlyProfits).abs()) : 'error',
                      leftSideStyle: report != null
                          ? int.parse(report.monthlyProfits).isNegative
                              ? paragraphStyle.copyWith(color: Colors.red)
                              : paragraphStyle.copyWith(color: Colors.green)
                          : paragraphStyle.copyWith(color: Colors.red),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    child: LabelRow(
                      rightSideText: 'عدد الطلبات : ',
                      leftSideText: report != null ? report.countOrderThisMonth : 'error',
                      leftSideStyle: report != null
                          ? paragraphStyle.copyWith(color: Colors.green)
                          : paragraphStyle.copyWith(color: Colors.red),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    child: LabelRow(
                      rightSideText: 'ساعات العمل : ',
                      leftSideText: report != null ? report.workingHour : 'error',
                      leftSideStyle: report != null
                          ? paragraphStyle.copyWith(color: Colors.green)
                          : paragraphStyle.copyWith(color: Colors.red),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    child: LabelRow(
                      rightSideText: 'التقييم: ',
                      leftSideText: report != null ? report.avgOrderRating : 'error',
                      leftSideStyle: report != null
                          ? paragraphStyle.copyWith(color: Colors.green)
                          : paragraphStyle.copyWith(color: Colors.red),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    child: LabelRow(
                      rightSideText: 'سرعة التوصيل: ',
                      leftSideText: report != null ? report.avgDeliveryMinutes : 'error',
                      leftSideStyle: report != null
                          ? paragraphStyle.copyWith(color: Colors.green)
                          : paragraphStyle.copyWith(color: Colors.red),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    child: LabelRow(
                      rightSideText: 'مسافة التوصيل: ',
                      leftSideText:
                          report != null ? (int.parse(report.deliveryDistance) / 1000).toString() + ' كم' : 'error',
                      leftSideStyle: report != null
                          ? paragraphStyle.copyWith(color: Colors.green)
                          : paragraphStyle.copyWith(color: Colors.red),
                    ),
                  ),
                ],
              );
      },
    );
  }
}
