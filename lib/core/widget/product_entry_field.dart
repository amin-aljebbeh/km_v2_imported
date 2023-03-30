import '../../core/core_importer.dart';

class ProductEntryField extends StatelessWidget {
  final TextEditingController controller;
  final String hint;
  final String title;
  final double width;

  const ProductEntryField({Key key, this.controller, this.hint, @required this.title, this.width}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(title, style: blackBold),
        const SizedBox(height: 8),
        EntryField(controller: controller, width: width, onSubmit: (notEmpty) {}, hint: hint, onChange: () {}),
        const SizedBox(height: 20),
      ],
    );
  }
}
