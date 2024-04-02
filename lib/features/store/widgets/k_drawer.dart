// import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

// import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'package:kammun_app/features/users/presentation/redux/users_action.dart';

import '../../../core/core_importer.dart';
import '../../users/data/models/balance_model.dart';
import 'drawer_children.dart';

class KDrawer extends StatelessWidget {
  const KDrawer({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, AppState>(
      converter: (store) => store.state,
      distinct: true,
      builder: (context, state) {
        return SafeArea(
          child: Container(
            color: Colors.white,
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width / 1.5,
            child: Drawer(
              child: Column(
                children: [
                  SizedBox(
                    width: MediaQuery.of(context).size.width / 1.5,
                    height: 60,
                    child: Align(
                      alignment: Alignment.topRight,
                      child: DrawerHeader(
                        decoration: BoxDecoration(color: Colors.white, border: Border.all(color: kmColors)),
                        child: InkWell(
                          onTap: () => Navigator.of(context).pop(),
                          child: SizedBox(
                            width: MediaQuery.of(context).size.width / 1.5,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Align(
                                    alignment: Alignment.centerRight,
                                    child: Icon(Icons.arrow_back_ios, color: kmColors)),
                                Text(state.adminsState.admin.username ?? '',
                                    style: mainStyle.copyWith(color: kmColors)),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Container(child: Image.asset('assets/kmlogoo.png', width: 250, height: 150), color: Colors.white),
                  if (state.usersState.balance != null)
                    if (state.usersState.balance.shopperSum != null && !Services.hasRole(context, shopperRole))
                      Padding(
                        padding: const EdgeInsets.only(top: 8, right: 8),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            LabelRow(
                                rightSideText: 'الرصيد: ',
                                leftSideText:
                                    StringUtils().oCcy.format(state.usersState.balance.shopperSum).replaceAll('-', '') +
                                        ' ' +
                                        state.generalInformationState.companyInformation.currency,
                                leftSideStyle:
                                    state.adminsState.admin.balance.isNegative ? warningStyle : informationStyle),
                            IconButton(
                              onPressed: () async {
                                final BalanceModel balance = await GeneralApis.getBalanceRefresh(context: context);
                                StoreProvider.of<AppState>(context).dispatch(SetBalance(balance: balance));
                              },
                              icon: const Icon(
                                Icons.refresh,
                              ),
                              color: kmColors,
                            )
                          ],
                        ),
                      ),
                  Divider(color: kmColors),
                  Expanded(child: ListView(primary: false, children: getDrawerChildren(context))),
                  Divider(color: kmColors, height: 20),
                  Padding(
                    padding: const EdgeInsets.only(top: 20.0, bottom: 20),
                    child: Center(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: const <Widget>[
                          MediaIcon(icon: Icons.facebook, url: 'facebook'),
                          MediaIcon(icon: Icons.facebook, url: 'instagram'),
                          MediaIcon(icon: Icons.messenger, url: 'messenger'),
                          MediaIcon(icon: Icons.whatsapp, url: 'whatsapp'),
                        ],
                      ),
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
