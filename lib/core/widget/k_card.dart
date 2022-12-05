import '../../core/core_importer.dart';

class KCard extends StatelessWidget {
  final Widget child;
  final double radius;
  final Color color;
  const KCard({Key key, this.child, this.radius, this.color = Colors.white}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: child,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.all(Radius.circular(radius)),
        boxShadow: [BoxShadow(color: searchGreyColor, spreadRadius: 1, blurRadius: 15)],
      ),
    );
  }
}
