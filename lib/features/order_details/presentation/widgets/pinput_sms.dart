import 'package:pinput/pinput.dart';

import '../../../../core/core_importer.dart';
import '../redux/order_details_action.dart';

class FilledRoundedPinPut extends StatefulWidget {
  final int orderId;
  final int subWareHouseId;
  const FilledRoundedPinPut({Key key, this.orderId, this.subWareHouseId}) : super(key: key);

  @override
  _FilledRoundedPinPutState createState() => _FilledRoundedPinPutState();

  @override
  String toStringShort() => 'Rounded Filled';
}

class _FilledRoundedPinPutState extends State<FilledRoundedPinPut> {
  final controller = TextEditingController();
  final focusNode = FocusNode();

  @override
  void dispose() {
    controller.dispose();
    focusNode.dispose();
    super.dispose();
  }

  bool showError = false;

  @override
  Widget build(BuildContext context) {
    const length = 5;
    Color borderColor = kmColors;
    const errorColor = Colors.red;
    Color fillColor = Colors.white;

    final defaultPinTheme = PinTheme(
      width: 48,
      height: 60,
      textStyle: labelStyle,
      margin: const EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
        color: fillColor,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: primaryColor, width: 0.3),
      ),
    );

    return SizedBox(
      height: 68,
      child: Pinput(
        length: length,
        controller: controller,
        focusNode: focusNode,
        defaultPinTheme: defaultPinTheme,
        onCompleted: (pin) {
          StoreProvider.of<AppState>(context).dispatch(AuthCodeOrderAction(
              code: controller.text, context: context, orderId: widget.orderId, subWareHouseId: widget.subWareHouseId));
        },
        focusedPinTheme: defaultPinTheme.copyWith(
          height: 68,
          width: 60,
          decoration: defaultPinTheme.decoration.copyWith(border: Border.all(color: borderColor)),
        ),
        errorPinTheme: defaultPinTheme.copyWith(
            decoration: BoxDecoration(color: errorColor, borderRadius: BorderRadius.circular(10))),
      ),
    );
  }
}
