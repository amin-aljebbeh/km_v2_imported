import '../core_importer.dart';

class EntryField extends StatefulWidget {
  final TextEditingController controller;
  final String hint;
  final TextInputType textInputType;
  final double width;
  final Function(bool) onSubmit;
  final EdgeInsetsGeometry edgeInsetsGeometry;

  const EntryField({
    Key key,
    @required this.controller,
    this.hint,
    this.width,
    this.onSubmit,
    this.edgeInsetsGeometry,
    this.textInputType = TextInputType.text,
  }) : super(key: key);

  @override
  _EntryFieldState createState() => _EntryFieldState();
}

class _EntryFieldState extends State<EntryField> {
  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.centerLeft,
      width: widget.width ?? MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5.0),
        color: Colors.white,
        border: Border.all(width: 1.0, color: kmColors),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.16), offset: const Offset(0, 3.0), blurRadius: 6.0)],
      ),
      child: TextFormField(
        cursorColor: kmColors,
        onChanged: (value) => setState(() {}),
        onFieldSubmitted: (string) => widget.onSubmit(string.isNotEmpty),
        onTap: () {},
        controller: widget.controller,
        keyboardType: widget.textInputType,
        //todo const TextInputType.numberWithOptions(decimal: true, signed: true)
        maxLines: null,
        decoration: InputDecoration(
          contentPadding: widget.edgeInsetsGeometry,
          border: const OutlineInputBorder(),
          hintText: widget.hint,
          hintStyle: mainStyle,
          fillColor: Colors.white,
          filled: true,
          enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(5.0), borderSide: const BorderSide(color: Colors.white, width: 3.0)),
          focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(4.0),
              borderSide: const BorderSide(color: Color(0xFF999999), width: 1.0)),
        ),
      ),
    );
  }
}
