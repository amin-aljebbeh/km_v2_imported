import 'package:kammun_app/features/coupons/presentation/pages/coupons_page.dart';
import 'package:kammun_app/features/users/presentation/pages/user_wallet_page.dart';

import '../../../../core/core_importer.dart';

class UserManagement extends StatefulWidget {
  final int userId;
  final String balance;
  const UserManagement({Key key, this.userId, this.balance}) : super(key: key);

  @override
  _UserManagementState createState() => _UserManagementState();
}

class _UserManagementState extends State<UserManagement> with SingleTickerProviderStateMixin {
  TabController controller;

  @override
  void initState() {
    controller = TabController(vsync: this, length: 2);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(kToolbarHeight),
          child: Container(
              color: kmColors,
              child: SafeArea(
                  child: TabBar(controller: controller, indicatorColor: Colors.white, labelColor: Colors.white, tabs: [
                Tab(child: Center(child: Text('الأكواد', style: tabStyle))),
                Tab(child: Center(child: Text('المحفظة', style: tabStyle))),
              ]))),
        ),
        body: TabBarView(
            controller: controller,
            children: [
              CouponsPage(userId: widget.userId),
              UserWalletPage(userId: widget.userId, balance: widget.balance)
            ],
            physics: const AlwaysScrollableScrollPhysics(parent: BouncingScrollPhysics())),
      ),
    );
  }
}
