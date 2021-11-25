import 'package:flutter/material.dart';
import 'package:kammun_app/Services.dart';
import 'package:kammun_app/utils/Styles.dart';
import 'package:searchable_dropdown/searchable_dropdown.dart';

class KSearchableDropdown extends StatefulWidget {
  final String hint;
  SearchableItem search;
  final List<SearchableItem> items;
  final Function onChange;

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
      isCaseSensitiveSearch: false,
      underline: Container(),
      isExpanded: true,
      hint: widget.hint,
      style: dropdownItemStyle,
      value: widget.search,
      items: widget.items.map((item) {
        return new DropdownMenuItem<SearchableItem>(
          child: Center(
            child: Text(
              item.value,
              style: dropdownItemStyle,
            ),
          ),
          value: item,
        );
      }).toList(),
      onChanged: (value) {
        try {
          widget.onChange(value);
        } on NoSuchMethodError catch (e) {
          print(e);
        }
      },
    );
  }
}
