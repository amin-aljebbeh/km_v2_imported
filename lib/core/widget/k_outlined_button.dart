import '../../core/core_importer.dart';

class KOutlinedButton extends StatelessWidget {
  final String text;
  final double width;
  final double height;
  final Color color;
  final Function onTap;
  final Widget child;
  const KOutlinedButton({Key key, this.text, this.width, this.height, this.color, this.onTap, this.child})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: height ?? 40,
        width: width,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: const BorderRadius.all(Radius.circular(6.0)),
          border: Border.all(color: color, width: 1.25),
        ),
        child: Center(
          child: child ??
              AutoSizeText(text,
                  style: decisionButtonStyle.copyWith(color: color, fontSize: 15),
                  maxLines: 2,
                  textAlign: TextAlign.center),
        ),
      ),
    );
  }
}
