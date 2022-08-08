import '../../../core/core_importer.dart';

class CategoryTitle extends StatelessWidget {
  const CategoryTitle({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, AppState>(
        converter: (store) => store.state,
        distinct: true,
        builder: (context, state) {
          return Padding(
            padding: const EdgeInsets.only(top: 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    const Expanded(child: KDivider()),
                    Text('  ' + StringUtils.shopByCategory + '  ', style: paragraphStyle),
                    const Expanded(child: KDivider()),
                  ],
                ),
                const SizedBox(height: 10)
              ],
            ),
          );
        });
  }
}
