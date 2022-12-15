import 'package:carousel_pro/carousel_pro.dart';

import '../../core/core_importer.dart';
import '../../core/firebase_init.dart';

class ImageCarousel extends StatelessWidget {
  const ImageCarousel({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        height: MediaQuery.of(context).size.height * 0.30,
        decoration: BoxDecoration(color: searchGreyColor, borderRadius: const BorderRadius.all(Radius.circular(20.0))),
        child: FirebaseInitPage(
          child: Carousel(
            borderRadius: true,
            boxFit: BoxFit.fill,
            images: LoadingScreenServices.bannerListNetwork,
            autoplay: true,
            animationCurve: Curves.fastLinearToSlowEaseIn,
            animationDuration: const Duration(milliseconds: 1000),
            dotSize: 6.0,
            indicatorBgPadding: 2.0,
          ),
        ));
  }
}
