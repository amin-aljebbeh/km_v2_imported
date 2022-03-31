import 'package:flutter/material.dart';
import 'package:kammun_app/utils/utils_importer.dart';
import 'package:search_choices/search_choices.dart';

// ignore: must_be_immutable
class KSearchableDropdown extends StatefulWidget {
  final String hint;
  String search;
  final List<DropdownMenuItem> items;
  final Function(String) onChanged;

  KSearchableDropdown({
    Key key,
    @required this.hint,
    @required this.search,
    @required this.items,
    @required this.onChanged,
  }) : super(key: key);

  @override
  _KSearchableDropdownState createState() => _KSearchableDropdownState();
}

class _KSearchableDropdownState extends State<KSearchableDropdown> {
  @override
  Widget build(BuildContext context) {
    return SearchChoices.single(
      displayClearIcon: false,
      rightToLeft: true,
      searchInputDecoration: InputDecoration(
        suffixIcon: Icon(
          Icons.search,
          size: 24,
          color: ColorUtils.primaryColor,
        ),
        contentPadding: const EdgeInsets.symmetric(vertical: 12),
      ),
      iconEnabledColor: ColorUtils.primaryColor,
      closeButton: TextButton(
        child: Text(
          StringUtils.close,
          style: dropdownItemStyle.copyWith(
            color: ColorUtils.primaryColor,
          ),
        ),
        onPressed: () => Navigator.of(context).pop(),
      ),
      disabledHint: Center(
        child: Text(
          'disabled',
          style: disableStyle,
        ),
      ),
      isCaseSensitiveSearch: false,
      underline: Container(),
      isExpanded: true,
      hint: Center(
        child: Text(
          widget.hint,
          style: dropdownItemStyle,
        ),
      ),
      style: dropdownItemStyle,
      value: widget.search,
      items: widget.items,
      onChanged: (String value) {
        if (value != null) widget.onChanged(value);
      },
    );
  }
}
