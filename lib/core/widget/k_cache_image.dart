import '../core_importer.dart';

class KCacheImage extends StatelessWidget {
  final Object tag;
  final String image;
  final double radius;

  const KCacheImage({Key key, @required this.tag, @required this.image, this.radius = 8}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width / 4,
      height: MediaQuery.of(context).size.width / 4,
      decoration: const BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(20.0))),
      child: Hero(
        tag: tag,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(radius),
          child: Image(
            fit: BoxFit.cover,
            image: image.isNotEmpty
                ? AdvImageCache(
                    StoreProvider.of<AppState>(context)
                            .state
                            .generalInformationState
                            .companyInformation
                            .imagePrefixUrl +
                        image,
                    useMemCache: true,
                    diskCacheExpire: const Duration(days: 400))
                : const AssetImage('assets/kmIcon.png'),
            width: MediaQuery.of(context).size.width,
            height: 120,
          ),
        ),
      ),
    );
  }
}
