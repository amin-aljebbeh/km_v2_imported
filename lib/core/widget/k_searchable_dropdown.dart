import 'package:search_choices/search_choices.dart';

import '../core_importer.dart';

class KSearchableDropdown extends StatefulWidget {
  final String hint;
  final String disableHint;
  final String search;
  final List<DropdownMenuItem> items;
  final Function(String) onChanged;
  final double padding;

  const KSearchableDropdown({
    Key key,
    @required this.hint,
    @required this.search,
    @required this.items,
    @required this.onChanged,
    this.padding = 10,
    this.disableHint = 'disabled',
  }) : super(key: key);

  @override
  _KSearchableDropdownState createState() => _KSearchableDropdownState();
}

class _KSearchableDropdownState extends State<KSearchableDropdown> {
  String showValue;

  @override
  void initState() {
    showValue = widget.search;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: widget.padding == 0 ? 10 : 0),
      child: SearchChoices.single(
        displayClearIcon: false,
        rightToLeft: true,
        iconEnabledColor: primaryColor,
        closeButton: TextButton(
            child: Text(closeString, style: dropdownItemStyle.copyWith(color: primaryColor)),
            onPressed: () => Navigator.of(context).pop()),
        disabledHint: Center(child: Text(widget.disableHint, style: disableStyle)),
        isCaseSensitiveSearch: false,
        underline: const SizedBox(),
        isExpanded: true,
        hint: Center(child: Text(widget.hint, style: dropdownItemStyle)),
        style: dropdownItemStyle,
        value: showValue,
        items: widget.items,
        onChanged: (String value) {
          if (value != null) {
            setState(() => showValue = value);
            widget.onChanged(value);
          }
        },
      ),
    );
  }
}
