import '../core_importer.dart';

class SideBarRow extends StatelessWidget {
  final IconData icon;
  final String text;
  final Function onTap;
  final String pushedRoute;

  const SideBarRow({Key key, @required this.icon, @required this.text, this.onTap, this.pushedRoute}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Padding(padding: const EdgeInsets.only(top: 8.0), child: Icon(icon, color: primaryColor, size: 30)),
      title: Text(text, style: mainStyle),
      onTap: pushedRoute == null ? onTap : () => Navigator.of(context).pushNamed(pushedRoute),
    );
  }
}
