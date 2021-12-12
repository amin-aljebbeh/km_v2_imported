import 'package:flutter/material.dart';
import 'package:kammun_app/Services.dart';
import 'package:kammun_app/utils/Styles.dart';
import 'package:kammun_app/utils/utils_importer.dart';
import 'package:searchable_dropdown/searchable_dropdown.dart';

class KSearchableDropdown extends StatefulWidget {
  final String hint;
  String search;
  final List<String> items;
  final Function(String) onChange;

  KSearchableDropdown({
    Key key,
    @required this.hint,
    @required this.search,
    @required this.items,
    @required this.onChange,
  }) : super(key: key);

  @override
  _KSearchableDropdownState createState() => _KSearchableDropdownState();
}

class _KSearchableDropdownState extends State<KSearchableDropdown> {
  @override
  Widget build(BuildContext context) {
    return SearchableDropdown(
      closeButton: FlatButton(
        child: Text(
          'إغلاق',
        ),
        onPressed: () => Navigator.of(context).pop(),
      ),
      disabledHint: 'disabled',
      isCaseSensitiveSearch: false,
      underline: Container(),
      isExpanded: true,
      hint: widget.hint,
      style: dropdownItemStyle,
      value: widget.search,
      items: widget.items.map((item) {
        return new DropdownMenuItem<String>(
          child: Center(
            child: Text(
              item,
              style: dropdownItemStyle,
            ),
          ),
          value: item,
        );
      }).toList(),
      onChanged: (String value) {
        if (value != null) widget.onChange(value);
      },
    );
  }
}
