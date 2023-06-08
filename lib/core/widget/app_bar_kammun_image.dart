import 'package:kammun_app/features/products/presentation/redux/products_action.dart';

import '../../features/home/presentation/redux/home_action.dart';
import '../core_importer.dart';

class AppBarKammunImage extends StatelessWidget {
  const AppBarKammunImage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 5.0),
          child: Transform.scale(
            scale: 2,
            child: InkWell(
              onTap: () {
                StoreProvider.of<AppState>(context).dispatch(SetPageIndex(index: 0));
                StoreProvider.of<AppState>(context).dispatch(InitProducts());
                Navigator.pushNamedAndRemoveUntil(context, StoreView.routeName, (Route<dynamic> route) => false);
              },
              child: Image.asset('assets/logobw.png', width: 150, height: 50),
            ),
          ),
        ),
      ],
    );
  }
}
