import '../../../core/core_importer.dart';

class CategoriesTitle extends StatelessWidget {
  const CategoriesTitle({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10, top: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          const Expanded(child: KDivider()),
          Text('  ' + shopByCategory + '  ',
              style: mainStyle.copyWith(color: primaryColor, fontWeight: FontWeight.w900, fontSize: 22)),
          const Expanded(child: KDivider()),
        ],
      ),
    );
  }
}
