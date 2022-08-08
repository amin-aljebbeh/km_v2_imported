import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../../../core/core_importer.dart';
import '../../products/view/products_view.dart';

class ProfileScreen extends StatefulWidget {
  static const String routeName = '/ProfileScreen';
  const ProfileScreen({Key key}) : super(key: key);

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, AppState>(
      converter: (store) => store.state,
      builder: (context, state) {
        return Scaffold(
          backgroundColor: Theme.of(context).primaryColorLight,
          appBar: NormalAppBar(title: StringUtils.profileInfo),
          body: SafeArea(
            child: Padding(
              padding: const EdgeInsets.only(left: 20, top: 10, right: 20, bottom: 10),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Center(
                    child: Padding(
                      padding: const EdgeInsets.only(top: 30.0),
                      child: Center(
                        child: Text(
                          'الرقم الشخصي',
                          style:
                              TextStyle(fontWeight: FontWeight.w700, fontFamily: StringUtils.fontFamily, fontSize: 20),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 0.0, right: 0, bottom: 30, top: 10),
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.white,
                        boxShadow: [BoxShadow(color: ColorUtils.primaryColor, spreadRadius: 3)],
                      ),
                      child: ListTile(
                        leading: Padding(
                          padding: const EdgeInsets.only(top: 8.0),
                          child: Icon(FontAwesomeIcons.phone, color: ColorUtils.kmColors, size: 30),
                        ),
                        title: Padding(
                          padding: const EdgeInsets.only(top: 5.0),
                          child: Text(
                            state.startupState.startModel.user.phone,
                            style: TextStyle(fontFamily: StringUtils.fontFamily, fontSize: 25, color: Colors.black),
                          ),
                        ),
                        onTap: () {},
                      ),
                    ),
                  ),
                  Center(
                    child: KOutlinedButton(
                      height: 50,
                      width: MediaQuery.of(context).size.width,
                      text: StringUtils.addressTitle,
                      color: ColorUtils.kmColors,
                      onTap: () => StoreProvider.of<AppState>(context).dispatch(Push(routeName: MyAddresses.routeName)),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 20),
                    child: Center(
                      child: KOutlinedButton(
                        height: 50,
                        width: MediaQuery.of(context).size.width,
                        text: 'المنتجات التي نفذت',
                        color: ColorUtils.kmColors,
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const ProductsView(productsViewType: ProductsViewTypes.alert)),
                        ),
                      ),
                    ),
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
