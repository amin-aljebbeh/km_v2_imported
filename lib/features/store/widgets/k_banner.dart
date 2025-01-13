
import 'package:carousel_slider/carousel_slider.dart';

import '../../../core/core_importer.dart';

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
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                state.homeState.banners.isNotEmpty
                    ? CarouselSlider.builder(
                        options: CarouselOptions(
                            height: MediaQuery.of(context).size.height * 0.20,
                            autoPlay: true,
                            clipBehavior: Clip.none,
                            initialPage: 0,
                            enlargeCenterPage: true,
                            onPageChanged: (index, reason) =>
                                setState(() => controller = PageController(initialPage: index)),
                            autoPlayAnimationDuration: const Duration(milliseconds: 1500)),
                        itemCount: state.homeState.banners.length,
                        itemBuilder: (context, index, realIndex) {
                          return ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: Image(
                              fit: BoxFit.fill,
                              image: AdvImageCache(
                                state.generalInformationState.companyInformation.imagePrefixUrl +
                                    state.homeState.banners[index].imageFileName,
                                useMemCache: true,
                                diskCacheExpire: const Duration(days: 100),
                              ),
                            ),
                          );
                        },
                      )
                    : Image(
                        image: const AssetImage('assets/180.png'),
                        width: MediaQuery.of(context).size.width,
                        height: MediaQuery.of(context).size.height * 0.20,
                      ),
              ],
            ),
          );
        });
  }
}
