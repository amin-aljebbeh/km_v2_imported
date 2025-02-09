import '../../core/core_importer.dart';

class ProductEntryField extends StatelessWidget {
  final TextEditingController controller;
  final String hint;
  final TextInputType textInputType;
  final String title;
  final double width;
  final FormFieldValidator<String> validator;

  const ProductEntryField({
    Key key,
    this.controller,
    this.hint,
    @required this.title,
    this.width,
    this.textInputType = TextInputType.text,
    this.validator,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(title, style: blackBold),
        Padding(
          padding: const EdgeInsets.only(bottom: 20, top: 8),
          child: EntryField(
              controller: controller,
              validator: validator,
              width: width,
              onSubmit: (notEmpty) {},
              hint: hint,
              onChange: () {},
              textInputType: textInputType),
        ),
      ],
    );
  }
}
