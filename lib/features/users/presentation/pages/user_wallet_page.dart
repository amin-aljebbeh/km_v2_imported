import 'package:kammun_app/features/users/presentation/redux/users_action.dart';

import '../../../../core/core_importer.dart';

class UserWalletPage extends StatefulWidget {
  final int userId;
  final String balance;
  const UserWalletPage({Key key, this.userId, this.balance}) : super(key: key);

  @override
  _UserWalletPageState createState() => _UserWalletPageState();
}

class _UserWalletPageState extends State<UserWalletPage> {
  TextEditingController valueController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  bool negative = false;
  int signFactor = 1;
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
                              leftSideText: StringUtils()
                                      .oCcy
                                      .format(int.parse(widget.balance.replaceAll('-', '').split('.')[0])) +
                                  ' ' +
                                  LoadingScreenServices.companyInformation.currency,
                              leftSideStyle: widget.balance.contains('-')
                                  ? loseStyle
                                  : warehouseStyle.copyWith(color: Colors.black)),
                        ),
                        SizedBox(
                          child: Padding(
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
                                      signFactor = value ? -1 : 1;
                                    },
                                    activeColor: primaryColor),
                                Text('سالب', style: decisionButtonStyle.copyWith(color: Colors.black)),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(
                          child: Padding(
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
                                          text: LoadingScreenServices.companyInformation.currency + ' ',
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
                                      StoreProvider.of<AppState>(context).dispatch(DepositUserWalletAction(
                                          description: descriptionController.text,
                                          context: context,
                                          userId: widget.userId,
                                          value: signFactor * int.parse(valueController.text)));
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
