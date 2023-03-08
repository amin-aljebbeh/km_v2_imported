import '../../core/core_importer.dart';

class ManagementView extends StatelessWidget {
  final List<Widget> children;
  final String title;

  const ManagementView({Key key, this.children, this.title}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(backgroundColor: primaryColor, title: Text(title, style: appBarStyle)),
      body: SafeArea(child: Column(children: children)),
    );
  }
}
