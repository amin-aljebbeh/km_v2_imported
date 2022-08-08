import 'package:flutter/material.dart';
import 'package:kammun_app/modules/home_page/view/store_view.dart';

class AppBarKammunImage extends StatelessWidget {
  final bool fromPayment;
  const AppBarKammunImage({Key key, this.fromPayment = false}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 5.0),
      child: Transform.scale(
        scale: 2,
        child: InkWell(
          onTap: () {
            if (!fromPayment) {
              Navigator.pushNamedAndRemoveUntil(context, StoreView.routeName, (Route<dynamic> route) => false);
            }
          },
          child: Image.asset('assets/logobw.png', width: 150, height: 50),
        ),
      ),
    );
  }
}
