import 'package:carousel_slider/carousel_slider.dart';

import '../../../core/core_importer.dart';
import '../../../core/firebase_init.dart';

class KBanner extends StatefulWidget {
  const KBanner({Key key}) : super(key: key);

  @override
  _KBannerState createState() => _KBannerState();
}

class _KBannerState extends State<KBanner> {
  PageController controller = PageController();

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, AppState>(
        converter: (store) => store.state,
        distinct: true,
        builder: (context, state) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: FirebaseInitPage(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  CarouselSlider.builder(
                    options: CarouselOptions(
                      initialPage: 0,
                      enlargeCenterPage: true,
                      clipBehavior: Clip.none,
                      autoPlay: state.homeState.banners.length > 1,
                      height: MediaQuery.of(context).size.height * 0.20,
                      enableInfiniteScroll: state.homeState.banners.length > 1,
                      autoPlayAnimationDuration: const Duration(milliseconds: 1500),
                      scrollPhysics: const AlwaysScrollableScrollPhysics(parent: BouncingScrollPhysics()),
                      onPageChanged: (index, reason) => setState(() => controller = PageController(initialPage: index)),
                    ),
                    itemCount: state.homeState.banners.isNotEmpty ? state.homeState.banners.length : 1,
                    itemBuilder: (context, index, realIndex) {
                      return ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Image(
                          fit: BoxFit.fill,
                          image: state.homeState.banners.isNotEmpty
                              ? AdvImageCache(
                                  state.generalInformationState.companyInformation.imagePrefixUrl +
                                      state.homeState.banners[index].imageFileName,
                                  useMemCache: true,
                                  diskCacheExpire: const Duration(days: 100),
                                )
                              : const AssetImage('assets/180.png'),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          );
        });
  }
}
