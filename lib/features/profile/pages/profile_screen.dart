import 'package:kammun_app/features/authentication/presentation/redux/authentication_action.dart';

import '../../../core/core_importer.dart';
import '../widgets/profile_container.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key key}) : super(key: key);

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final formkey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, AppState>(
      converter: (store) => store.state,
      distinct: true,
      builder: (context, state) {
        final TextEditingController phoneController = TextEditingController(
            text: state.adminsState.admin.phone ?? 'لا يوجد');

        return Scaffold(
          backgroundColor: Theme.of(context).primaryColorLight,
          appBar: AppBar(
            title: Align(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AutoSizeText(state.adminsState.admin.name ?? '',
                      style: userNameStyle.copyWith(fontSize: 25)),
                  AutoSizeText(state.adminsState.admin.username ?? '',
                      style: userNameStyle),
                ],
                textDirection: TextDirection.ltr,
              ),
              alignment: Alignment.centerLeft,
            ),
            backgroundColor: kmColors,
          ),
          body: SafeArea(
            child: Padding(
              padding: const EdgeInsets.only(
                  left: 10, top: 10, right: 10, bottom: 10),
              child: ListView(
                children: [
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.85,
                    child: ListView(
                      children: [
                        ProfileContainer(
                          title: 'الرقم الشخصي',
                          child: SizedBox(
                              width: MediaQuery.of(context).size.width,
                              child: Form(
                                  key: formkey,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    // mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Directionality(
                                          textDirection: TextDirection.ltr,
                                          child: Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: TextFormField(
                                              enabled:
                                                  false ,
                                              controller: phoneController,
                                              autofocus: false,
                                              style: const TextStyle(
                                                  fontSize: 20,
                                                  color: Color.fromARGB(
                                                      255, 0, 0, 0)),
                                              decoration: InputDecoration(
                                                filled: true,
                                                hintText: "Phone Number",
                                                focusedBorder:
                                                    OutlineInputBorder(
                                                  borderSide: const BorderSide(
                                                      color: Colors.white),
                                                  borderRadius:
                                                      BorderRadius.circular(12),
                                                ),
                                                enabledBorder:
                                                    OutlineInputBorder(
                                                  borderSide: BorderSide(
                                                      color: /*(state.allowUpdate ?? false)
                                            ? Colors.black
                                            :*/
                                                          kmColors,
                                                      width: 0.5),
                                                  borderRadius:
                                                      BorderRadius.circular(12),
                                                ),
                                                prefixIcon: Icon(Icons.call,
                                                    color: kmColors),
                                                //prefixStyle: style14w400Black,
                                              ),
                                            ),
                                          )),
                                      // 30.sh,
                                    ],
                                  ))),
                        ),
                        if (state.adminsState.admin.balance != null)

                        ProfileContainer(
                          title: 'الرصيد',
                          child: Padding(
                            padding: const EdgeInsets.only(top: 8),
                            child: Center(
                              child: LabelRow(
                                  // rightSideText: 'الرصيد: ',
                                  leftSideText: StringUtils()
                                      .oCcy
                                      .format(state.adminsState.admin.balance)
                                      .replaceAll('-', '') +
                                      ' ' +
                                      state.generalInformationState
                                          .companyInformation.currency,
                                  leftSideStyle:
                                  state.adminsState.admin.balance.isNegative ? warningStyle : informationStyle),
                            ),
                          ),
                        ),
                        if (state.adminsState.admin.roles.isNotEmpty)
                          ProfileContainer(
                            title: 'المستودع',
                            child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: state
                                    .generalInformationState.subWarehouses
                                    .map((subWarehouse) => Padding(
                                        padding: const EdgeInsets.all(5),
                                        child: Text(subWarehouse.name,
                                            style: mainStyle.copyWith(
                                                fontSize: 25,
                                                color: Colors.black))))
                                    .toList()),
                          ),
                        ProfileContainer(
                          title: 'الجهة المفضلة لاستخدام الهاتف',
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              IconButton(
                                icon: Icon(Icons.library_add_check_outlined,
                                    color: StaticVariables.preferLeftSide
                                        ? searchGreyColor
                                        : kmColors2),
                                onPressed: () {
                                  print(
                                      'bassssssam${state.generalInformationState.subWarehouses}');
                                  StaticVariables.preferLeftSide
                                      ? Services.setPreferLeftSide(false)
                                      : {};
                                  setState(() {});
                                },
                              ), //right side
                              IconButton(
                                  icon: Icon(Icons.library_add_check_outlined,
                                      color: StaticVariables.preferLeftSide
                                          ? kmColors2
                                          : searchGreyColor),
                                  onPressed: () {
                                    StaticVariables.preferLeftSide
                                        ? {}
                                        : Services.setPreferLeftSide(true);
                                    setState(() {});
                                  })
                            ],
                          ),
                        ),
                        ProfileContainer(
                          title: logout,
                          child: ListTile(
                            leading: Padding(
                                padding: const EdgeInsets.only(top: 8.0),
                                child: IconButton(
                                    onPressed: () =>
                                        StoreProvider.of<AppState>(context)
                                            .dispatch(
                                                LogoutAction(context: context)),
                                    icon: Icon(Icons.logout,
                                        color: kmColors, size: 30))),
                            title: Padding(
                              padding: const EdgeInsets.only(top: 5.0),
                              child: Text(logout,
                                  style: mainStyle.copyWith(
                                      fontSize: 25, color: Colors.black)),
                            ),
                            onTap: () {},
                          ),
                        ),
                      ],
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
