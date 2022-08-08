import 'package:flutter/material.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import '../../../core/core_importer.dart';
import '../redux/product_action.dart';

enum SingingCharacter { oneTime, always }

class ChooseAlertTypeView extends StatefulWidget {
  final int productId;
  const ChooseAlertTypeView({Key key, this.productId}) : super(key: key);

  @override
  State<ChooseAlertTypeView> createState() => _ChooseAlertTypeViewState();
}

class _ChooseAlertTypeViewState extends State<ChooseAlertTypeView> {
  SingingCharacter character;
  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, AppState>(
      converter: (store) => store.state,
      distinct: true,
      builder: (context, state) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 20, left: 10, bottom: 0, right: 25),
              child: Text('نوع الإشعار', style: paragraphStyle.copyWith(color: ColorUtils.kmColors)),
            ),
            Column(
              children: <Widget>[
                ListTile(
                  title: Text('إشعار لمرة واحدة', style: informationStyle),
                  leading: Radio<SingingCharacter>(
                    value: SingingCharacter.oneTime,
                    groupValue: character,
                    onChanged: (SingingCharacter value) {
                      setState(() => character = value);
                      Navigator.of(navigatorKey.currentContext).pop();
                      StoreProvider.of<AppState>(navigatorKey.currentContext).dispatch(StartLoading());
                      StoreProvider.of<AppState>(navigatorKey.currentContext)
                          .dispatch(NotifyMe(productId: widget.productId, isAlways: 0));
                    },
                    activeColor: ColorUtils.kmColors,
                  ),
                ),
                ListTile(
                  title: Text('إشعار دائم', style: informationStyle),
                  leading: Radio<SingingCharacter>(
                    value: SingingCharacter.always,
                    groupValue: character,
                    activeColor: ColorUtils.kmColors,
                    onChanged: (SingingCharacter value) {
                      setState(() => character = value);
                      Navigator.of(navigatorKey.currentContext).pop();
                      StoreProvider.of<AppState>(navigatorKey.currentContext).dispatch(StartLoading());
                      StoreProvider.of<AppState>(navigatorKey.currentContext)
                          .dispatch(NotifyMe(productId: widget.productId, isAlways: 1));
                    },
                  ),
                ),
              ],
            )
          ],
        );
      },
    );
  }
}

chooseAlertType({BuildContext context, int productId}) {
  showMaterialModalBottomSheet(
    context: context,
    builder: (context) => Container(
      padding: const EdgeInsets.all(5),
      height: MediaQuery.of(context).size.height * 0.25,
      child: ChooseAlertTypeView(productId: productId),
    ),
  );
}
