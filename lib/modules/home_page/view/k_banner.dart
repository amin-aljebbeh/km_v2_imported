import 'package:carousel_pro/carousel_pro.dart';
import 'package:flutter/material.dart';

import '../../../core/core_importer.dart';
import '../services/home_page_service.dart';

class KBanner extends StatelessWidget {
  const KBanner({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, AppState>(
        converter: (store) => store.state,
        distinct: true,
        builder: (context, state) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                height: MediaQuery.of(context).size.height * 0.20,
                width: MediaQuery.of(context).size.width,
                decoration:
                    const BoxDecoration(color: Colors.white, borderRadius: BorderRadius.all(Radius.circular(20.0))),
                child: Carousel(
                  borderRadius: true,
                  boxFit: BoxFit.cover,
                  images: HomePageService.getBanner(context),
                  autoplay: true,
                  animationCurve: Curves.fastLinearToSlowEaseIn,
                  animationDuration: const Duration(milliseconds: 1000),
                  dotSize: 6.0,
                  indicatorBgPadding: 2.0,
                  dotBgColor: Colors.transparent,
                ),
              ),
              const SizedBox(height: 20)
            ],
          );
        });
  }
}
