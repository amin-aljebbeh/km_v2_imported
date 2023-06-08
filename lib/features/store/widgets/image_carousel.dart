import 'package:carousel_pro/carousel_pro.dart';

import '../../../core/core_importer.dart';
import '../../../core/firebase_init.dart';

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
            images: [
              FadeInImage(
                image: AdvImageCache(StaticVariables.imagePrefixUrl + 'slide3.png',
                    useMemCache: true, diskCacheExpire: const Duration(days: 400)),
                fadeInDuration: const Duration(seconds: 1),
                fadeInCurve: Curves.fastOutSlowIn,
                placeholderErrorBuilder: (ctx, err, trace) => Image.asset('assets/kmlogoo.png'),
                imageErrorBuilder: (ctx, err, trace) => Image.asset('assets/kmlogoo.png'),
                placeholder: const AssetImage('assets/kmlogoo.png'),
                fit: BoxFit.cover,
              )
            ],
            autoplay: true,
            animationCurve: Curves.fastLinearToSlowEaseIn,
            animationDuration: const Duration(milliseconds: 1000),
            dotSize: 6.0,
            indicatorBgPadding: 2.0,
          ),
        ));
  }
}
