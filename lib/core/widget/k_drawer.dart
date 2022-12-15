import '../../features/store/drawer_children.dart';
import '../core_importer.dart';

class KDrawer extends StatelessWidget {
  const KDrawer({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
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
                                  alignment: Alignment.centerRight, child: Icon(Icons.arrow_back_ios, color: kmColors)),
                              Text(LoadingScreenServices.admin.username ?? '', style: TextStyle(color: kmColors)),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                Container(child: Image.asset('assets/kmlogoo.png', width: 250, height: 200), color: Colors.white),
                Divider(color: kmColors),
                SizedBox(
                  height: 550,
                  child: ListView(
                      primary: false,
                      children: <Widget>[Column(children: getDrawerChildren(context)), const SizedBox(height: 100)]),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
