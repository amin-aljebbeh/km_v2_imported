import 'dart:ui';

import 'package:adv_image_cache/adv_image_cache.dart';
import 'package:flutter/material.dart';
import 'package:kammun_app/core/core_importer.dart';

class KCacheImage extends StatelessWidget {
  final Object tag;
  final String image;
  final bool blur;
  final bool fromFavorite;
  final BoxFit fit;

  const KCacheImage({
    Key key,
    @required this.tag,
    @required this.image,
    this.blur = false,
    this.fromFavorite = false,
    this.fit = BoxFit.cover,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, AppState>(
      converter: (store) => store.state,
      distinct: true,
      builder: (context, state) {
        return ClipRRect(
          borderRadius: const BorderRadius.all(Radius.circular(20)),
          child: SizedBox(
            width: 100.0,
            height: 100.0,
            child: Stack(
              children: [
                Hero(
                  tag: tag,
                  child: FadeInImage(
                    image: AdvImageCache(state.startupState.startModel.company.imageBaseUrl + image,
                        useMemCache: true,
                        diskCacheExpire: fromFavorite ? const Duration(days: 1) : const Duration(minutes: 30)),
                    width: MediaQuery.of(context).size.width,
                    fadeInDuration: const Duration(seconds: 1),
                    height: MediaQuery.of(context).size.height,
                    imageErrorBuilder: (ctx, err, _) => Center(child: Image.asset('assets/kmIcon.png')),
                    fadeInCurve: Curves.fastOutSlowIn,
                    placeholder: const AssetImage('assets/kmIcon.png'),
                    fit: fit,
                  ),
                ),
                if (blur)
                  ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 2, sigmaY: 2.0),
                      child: Container(
                          child: Center(
                            child: Text(
                              'نفذ من المستودع',
                              style: decisionButtonStyle.copyWith(color: Colors.black),
                              textAlign: TextAlign.center,
                            ),
                          ),
                          decoration: BoxDecoration(color: Colors.white.withOpacity(0.0))),
                    ),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }
}
