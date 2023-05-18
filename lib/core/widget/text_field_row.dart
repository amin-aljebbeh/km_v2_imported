import '../../core/core_importer.dart';

class TextFieldRow extends StatelessWidget {
  final TextEditingController controller;
  final MainAxisAlignment mainAxisAlignment;
  final String text;
  final String hint;
  final TextInputType inputType;
  final double width;
  final Function onChange;

  const TextFieldRow({
    Key key,
    @required this.controller,
    @required this.text,
    this.onChange,
    @required this.inputType,
    @required this.width,
    @required this.mainAxisAlignment,
    this.hint,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: mainAxisAlignment,
      children: [
        Text(text, overflow: TextOverflow.clip, style: paragraphStyle),
        EntryField(
          controller: controller,
          hint: hint,
          onChange: () => onChange(),
          width: width,
          onSubmit: (result) {},
          textInputType: inputType,
        ),
      ],
    );
  }
}
