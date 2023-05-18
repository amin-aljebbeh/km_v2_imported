import '../../../core/core_importer.dart';

class ProfileContainer extends StatelessWidget {
  final String title;
  final Widget child;
  const ProfileContainer({Key key, this.title, this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Center(
            child: Padding(
                padding: const EdgeInsets.only(top: 10.0),
                child:
                    Center(child: Text(title, style: mainStyle.copyWith(fontWeight: FontWeight.w700, fontSize: 20)))),
          ),
          Center(
            child: Container(
              width: MediaQuery.of(context).size.width,
              margin: const EdgeInsets.all(15),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.white,
                  boxShadow: [BoxShadow(color: kmColors, spreadRadius: 3)]),
              child: child,
            ),
          ),
        ],
      ),
    );
  }
}
