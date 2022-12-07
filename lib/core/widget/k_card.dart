import '../../core/core_importer.dart';

class KCard extends StatelessWidget {
  final Widget child;
  final BorderRadiusGeometry radius;
  final Function onTap;
  final EdgeInsets padding;
  final Color color;
  final bool shadow;
  const KCard(
      {Key key, this.child, this.radius, this.color = Colors.white, this.padding, this.onTap, this.shadow = true})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap ?? () {},
      child: Container(
        margin: padding ?? const EdgeInsets.all(0),
        child: child,
        decoration: BoxDecoration(
          color: color,
          borderRadius: radius ?? const BorderRadius.all(Radius.circular(0)),
          boxShadow: shadow ? [BoxShadow(color: searchGreyColor, spreadRadius: 1, blurRadius: 15)] : [],
        ),
      ),
    );
  }
}
