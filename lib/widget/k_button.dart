import '../core/core_importer.dart';

class KButton extends StatelessWidget {
  final String text;
  final double width;
  final double height;
  final Color color;
  final Function onTap;
  final Function onLongPress;
  final Widget child;

  const KButton({
    Key key,
    this.text,
    this.width,
    @required this.color,
    @required this.onTap,
    this.height,
    this.child,
    this.onLongPress,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onLongPress: onLongPress,
      onTap: onTap,
      child: Container(
        height: height ?? 40,
        width: width,
        decoration: BoxDecoration(color: color, borderRadius: const BorderRadius.all(Radius.circular(6.0))),
        child: Center(child: child ?? AutoSizeText(text, style: decisionButtonStyle, maxLines: 1)),
      ),
    );
  }
}
