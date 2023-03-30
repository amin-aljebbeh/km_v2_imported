import '../../core/core_importer.dart';

class TextFieldRow extends StatefulWidget {
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
  _TextFieldRowState createState() => _TextFieldRowState();
}

class _TextFieldRowState extends State<TextFieldRow> {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: widget.mainAxisAlignment,
      children: [
        Text(widget.text, overflow: TextOverflow.clip, style: paragraphStyle),
        EntryField(
          controller: widget.controller,
          hint: widget.hint,
          onChange: () => widget.onChange(),
          width: widget.width,
          onSubmit: (result) {},
          textInputType: widget.inputType,
        ),
      ],
    );
  }
}
