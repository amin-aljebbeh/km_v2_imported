import 'package:kammun_app/core/core_importer.dart';

class AddAddressTextField extends StatefulWidget {
  final TextEditingController controller;
  final int maxLines;
  final FocusNode focusNode;
  final Function onSubmitted;
  final Function onChanged;
  final String hintText;
  final String labelText;
  final bool autoFocus;
  final bool enabled;

  const AddAddressTextField({
    Key key,
    @required this.controller,
    this.maxLines = 1,
    this.focusNode,
    @required this.onSubmitted,
    @required this.hintText,
    @required this.labelText,
    this.autoFocus = true,
    this.enabled = true,
    this.onChanged,
  }) : super(key: key);

  @override
  _AddAddressTextFieldState createState() => _AddAddressTextFieldState();
}

class _AddAddressTextFieldState extends State<AddAddressTextField> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0.0, 25.0, 0.0, 0.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(widget.labelText, style: informationStyle.copyWith(fontSize: 20)),
          KTextField(
            autoFocus: widget.autoFocus,
            enabled: widget.enabled,
            maxLines: widget.maxLines,
            controller: widget.controller,
            focusNode: widget.focusNode,
            onSubmitted: () => widget.onSubmitted(),
            hintText: widget.hintText,
            onChanged: () => widget.onChanged(),
          ),
        ],
      ),
    );
  }
}
