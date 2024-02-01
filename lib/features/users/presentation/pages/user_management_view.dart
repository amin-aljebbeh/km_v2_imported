import 'package:kammun_app/features/users/presentation/pages/user_change_phone_page.dart';
import 'package:kammun_app/features/users/presentation/pages/user_wallet_page.dart';

import '../../../../core/core_importer.dart';
import '../../../orders/domain/entities/order_entity.dart';

class UserManagement extends StatefulWidget {
  final OrderEntity order;

  const UserManagement({Key key, this.order}) : super(key: key);

  @override
  _UserManagementState createState() => _UserManagementState();
}

class _UserManagementState extends State<UserManagement> with SingleTickerProviderStateMixin {
  TabController controller;

  @override
  void initState() {
    controller = TabController(vsync: this, length: 4);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, AppState>(
      converter: (store) => store.state,
      distinct: true,
      builder: (context, state) {
        return Scaffold(
          appBar: PreferredSize(
            preferredSize: const Size.fromHeight(kToolbarHeight),
            child: Container(
                color: kmColors,
                child: SafeArea(
                    child: Row(
                  children: [
                    IconButton(
                        onPressed: () => Navigator.pop(context),
                        icon: const Icon(Icons.arrow_back_ios_rounded, color: Colors.white)),
                    Expanded(
                      child: TabBar(
                        isScrollable: true,
                        controller: controller,
                        indicatorColor: Colors.white,
                        labelColor: Colors.white,
                        tabs: [
                          Tab(
                              child: Center(
                                  child: Text('أكواد المستخدم', style: tabStyle, textAlign: TextAlign.center))),
                          Tab(
                              child:
                                  Center(child: Text('أكواد الحسم', style: tabStyle, textAlign: TextAlign.center))),
                          Tab(child: Center(child: Text('المحفظة', style: tabStyle, textAlign: TextAlign.center))),
                          if (Services.hasRole(context, agentRole) && Services.hasPermission(context, 'change-user-phone-number'))
                          Tab(
                              child: Center(
                                  child: Text('تغيير رقم هاتف الزبون', style: tabStyle, textAlign: TextAlign.center))),
                        ],
                      ),
                    ),
                  ],
                ))),
          ),
          body: TabBarView(
              controller: controller,
              children: [UserCouponsPage(), const CouponsPage(), UserWalletPage(order: widget.order) , ChangeNamberPhoneUser(order: widget.order)],
              physics: const AlwaysScrollableScrollPhysics(parent: BouncingScrollPhysics())),
        );
      },
    );
  }
}
