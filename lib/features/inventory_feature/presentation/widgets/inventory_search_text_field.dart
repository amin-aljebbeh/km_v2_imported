import '../../../../core/core_importer.dart';

class InventorySearchTextField extends StatelessWidget with PreferredSizeWidget {
  final TextEditingController controller;
  final Function onReload;
  final BuildContext context;

  const InventorySearchTextField({Key key, @required this.controller, @required this.onReload, @required this.context})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: primaryColor,
      title: Container(
        padding: const EdgeInsets.only(bottom: 10.0),
        decoration: BoxDecoration(
            borderRadius: const BorderRadius.all(Radius.circular(10.0)),
            border: Border.all(color: primaryColor, width: 2)),
        child: TextField(
          style: flushBarStyle,
          decoration: InputDecoration(
              suffixIcon: IconButton(
                  icon: const Icon(Icons.close, size: 20, color: Colors.white), onPressed: () => controller.text = ''),
              enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: kmColors)),
              focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: kmColors)),
              border: UnderlineInputBorder(borderSide: BorderSide(color: kmColors))),
          cursorColor: kmColors,
          controller: controller,
        ),
      ),
      actions: [
        Padding(
            padding: const EdgeInsets.only(left: 8.0),
            child: IconButton(onPressed: onReload, icon: const Icon(Icons.refresh, size: 35)))
      ],
    );
  }

  @override
  Size get preferredSize => Size(MediaQuery.of(context).size.width * 0.8, MediaQuery.of(context).size.height * 0.07);
}
