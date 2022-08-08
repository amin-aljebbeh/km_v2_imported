import 'package:kammun_app/core/core_importer.dart';

class EndOfPageWidget extends StatelessWidget {
  const EndOfPageWidget({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 8, right: 8),
      child: SizedBox(
        width: MediaQuery.of(context).size.width,
        height: 50,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Expanded(child: KDivider()),
            RotationTransition(
              turns: const AlwaysStoppedAnimation(225 / 360),
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: Container(
                    padding: const EdgeInsets.all(3),
                    decoration: BoxDecoration(border: Border.all(color: ColorUtils.primaryColor, width: 1)),
                    child: Container(color: ColorUtils.primaryColor, height: 10, width: 10)),
              ),
            ),
            const Expanded(child: KDivider())
          ],
        ),
      ),
    );
  }
}
