import 'package:kammun_app/features/transactions/presentation/redux/transactions_action.dart';

import '../../../../core/core_importer.dart';
import '../../../orders/domain/entities/order_entity.dart';
import '../../../orders/presentation/redux/orders_action.dart';
import '../../../transactions/domain/entities/admin_transaction_entity.dart';

class UserWalletPage extends StatefulWidget {
  final OrderEntity order;
  final AdminTransactionEntity adminTransactionEntity ;
  const UserWalletPage({Key key, this.order, this.adminTransactionEntity}) : super(key: key);

  @override
  _UserWalletPageState createState() => _UserWalletPageState();
}

class _UserWalletPageState extends State<UserWalletPage> {
  TextEditingController valueController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  bool negative = false;
  int categoryId;

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      categoryId = StoreProvider.of<AppState>(context)
          .state
          .transactionsState
          .categories
          .firstWhere((category) => category.slug == 'deposit-user')
          .id;
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, AppState>(
      converter: (store) => store.state,
      distinct: true,
      builder: (context, state) {
        return TemporaryLoading(
          child: Scaffold(
            body: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          child: LabelRow(
                              rightSideText: 'رصيد الزبون: ',
                              leftSideText: StringUtils().oCcy.format(int.parse(
                                      state.usersState.userEntity.balance.replaceAll('-', '').split('.')[0])) +
                                  ' ' +
                                  state.generalInformationState.companyInformation.currency,
                              leftSideStyle: state.usersState.userEntity.balance.contains('-')
                                  ? loseStyle
                                  : warehouseStyle.copyWith(color: Colors.black)),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          child: TextFormField(
                              controller: valueController,
                              cursorColor: kmColors,
                              style: mainStyle,
                              keyboardType: TextInputType.number,
                              onFieldSubmitted: (_) {},
                              decoration: InputDecoration(
                                  hintStyle: mainStyle.copyWith(color: Colors.grey),
                                  hintText: 'قيمة الشحن',
                                  enabled: true,
                                  filled: true,
                                  prefixIcon: InkWell(
                                      child: const Icon(Icons.close_rounded, color: Colors.grey),
                                      onTap: () => valueController.text = ''),
                                  border: const OutlineInputBorder(),
                                  enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(6),
                                      borderSide: BorderSide(color: searchGreyColor, width: 2)),
                                  focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(6),
                                      borderSide: BorderSide(color: searchGreyColor, width: 2)))),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          child: SizedBox(
                            width: MediaQuery.of(context).size.width,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Checkbox(
                                    value: negative,
                                    onChanged: (bool value) {
                                      setState(() => negative = value);
                                      categoryId = state.transactionsState.categories
                                          .firstWhere(
                                              (category) => category.slug == (value ? 'deduct-user' : 'deposit-user'))
                                          .id;
                                    },
                                    activeColor: primaryColor),
                                Text('سالب', style: decisionButtonStyle.copyWith(color: Colors.black)),
                              ],
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          child: TextFormField(
                              controller: descriptionController,
                              cursorColor: kmColors,
                              style: mainStyle,
                              maxLines: 5,
                              onFieldSubmitted: (_) {},
                              decoration: InputDecoration(
                                  hintStyle: mainStyle.copyWith(color: Colors.grey),
                                  enabled: true,
                                  hintText: 'سبب الشحن',
                                  filled: true,
                                  border: const OutlineInputBorder(),
                                  enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(6),
                                      borderSide: BorderSide(color: searchGreyColor, width: 2)),
                                  focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(6),
                                      borderSide: BorderSide(color: searchGreyColor, width: 2)))),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8),
                    child: KammunButton(
                        color: kmColors,
                        onTap: () {
                          if (valueController.text.isEmpty) {
                            snackBar(context: context, message: 'أدخل قيمة الشحن', success: false);
                          } else if (descriptionController.text.isEmpty) {
                            snackBar(context: context, message: 'أدخل سبب الشحن', success: false);
                          } else {
                            showMyDialog(
                                title: 'تأكيد',
                                context: context,
                                content: RichText(
                                  text: TextSpan(
                                    children: <TextSpan>[
                                      TextSpan(
                                          text: 'سيتم شحن مبلغ ', style: dialogStyle.copyWith(color: Colors.black)),
                                      TextSpan(
                                          text: StringUtils().oCcy.format(int.parse(valueController.text)) + ' ',
                                          style: negative ? lightLoseStyle : lightProfitStyle),
                                      TextSpan(
                                          text: state.generalInformationState.companyInformation.currency + ' ',
                                          style: negative ? lightLoseStyle : lightProfitStyle),
                                      negative
                                          ? TextSpan(
                                              text: 'من ',
                                              style: dialogStyle.copyWith(
                                                  color: Colors.black, fontWeight: FontWeight.w900))
                                          : TextSpan(
                                              text: 'إلى ',
                                              style: dialogStyle.copyWith(
                                                  color: Colors.black, fontWeight: FontWeight.w900)),
                                      TextSpan(text: 'رصيد الزبون', style: dialogStyle.copyWith(color: Colors.black)),
                                    ],
                                  ),
                                ),
                                dialogButtons: [
                                  KammunButton(
                                    color: kmColors,
                                    onTap: () {

                                      Navigator.pop(context);
                                      StoreProvider.of<AppState>(context).dispatch(CreateTransactionAction(
                                          context: context,
                                          transactionEntity: AdminTransactionEntity(
                                            description: descriptionController.text,
                                            transactionCategoryId: categoryId,
                                            userId: state.usersState.userEntity.id,
                                            value: int.parse(valueController.text).abs(),
                                            orderId: widget.order.id,
                                          )));
                                      StoreProvider.of<AppState>(context).dispatch(GetOrdersAction( context: context));
                                      Navigator.push(context, MaterialPageRoute(builder: (screenContext) =>  const HomePage()));


                                    },
                                    width: 100,
                                    text: 'شحن',
                                  ),
                                  KammunButton(
                                      color: kmColors, onTap: () => Navigator.pop(context), width: 100, text: 'إلغاء'),
                                ]);
                          }
                        },
                        text: 'شحن',
                        width: MediaQuery.of(context).size.width,
                        height: 50),
                  )
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
