import '../../features/store/drawer_children.dart';
import '../core_importer.dart';

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
                                Text(StaticVariables.admin.username ?? '', style: mainStyle.copyWith(color: kmColors)),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Container(child: Image.asset('assets/kmlogoo.png', width: 250, height: 150), color: Colors.white),
                  if (state.adminsState.admin.balance != null)
                    Padding(
                      padding: const EdgeInsets.only(top: 8),
                      child: LabelRow(
                          rightSideText: 'الرصيد: ',
                          leftSideText: StringUtils().oCcy.format(state.adminsState.admin.balance) +
                              ' ' +
                              StaticVariables.companyInformation.currency,
                          leftSideStyle: state.adminsState.admin.balance.isNegative ? warningStyle : informationStyle),
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
                          MediaIcon(icon: FontAwesomeIcons.facebookF, url: 'facebook'),
                          MediaIcon(icon: FontAwesomeIcons.instagram, url: 'instagram'),
                          MediaIcon(icon: FontAwesomeIcons.facebookMessenger, url: 'messenger'),
                          MediaIcon(icon: FontAwesomeIcons.whatsapp, url: 'whatsapp'),
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
