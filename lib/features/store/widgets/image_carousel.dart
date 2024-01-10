import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_pro/carousel_pro.dart';

import '../../../core/core_importer.dart';
import '../../../core/firebase_init.dart';

class ImageCarousel extends StatelessWidget {
  const ImageCarousel({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, AppState>(
      converter: (store) => store.state,
      distinct: true,
      builder: (context, state) {

        return Container(
            height: MediaQuery.of(context).size.height * 0.30,
            decoration:
                BoxDecoration(color: searchGreyColor, borderRadius: const BorderRadius.all(Radius.circular(20.0))),
            child: FirebaseInitPage(
              child:

              Carousel(
              borderRadius: true,
              boxFit: BoxFit.fill,
              images: [
                CachedNetworkImage(
                  imageUrl: state.generalInformationState.companyInformation.imagePrefixUrl + 'slide3.png',
                  placeholder: (context, url) => const CircularProgressIndicator(),
                  errorWidget: (context, url, error) => Image.asset('assets/kmlogoo.png'),
                ),
              ],
              autoplay: true,
              animationCurve: Curves.fastLinearToSlowEaseIn,
              animationDuration: const Duration(milliseconds: 1000),
              dotSize: 6.0,
              indicatorBgPadding: 2.0,
            ),

        ));
      },
    );
  }
}
