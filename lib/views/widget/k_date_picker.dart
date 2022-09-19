import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:intl/intl.dart';
import 'package:kammun_app/utils/utils_importer.dart';

class KDatePicker extends StatefulWidget {
  final Function(String) onConfirmStart;
  final Function(String) onConfirmEnd;

  const KDatePicker({Key key, @required this.onConfirmStart, @required this.onConfirmEnd}) : super(key: key);
  @override
  _KDatePickerState createState() => _KDatePickerState();
}

class _KDatePickerState extends State<KDatePicker> with AutomaticKeepAliveClientMixin<KDatePicker> {
  @override
  bool get wantKeepAlive => true;
  String _fromDateTimeValue = 'يرجى أختيار تاريخ البداية';
  String _toDateTimeValue = 'يرجى إختيار تاريخ النهاية';
  final DateFormat fullDateFormatter = DateFormat('yyyy-MM-dd HH:mm:ss');
  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Text('من تاريخ', style: mainStyle),
            IconButton(
              icon: Icon(Icons.timer, color: primaryColor),
              onPressed: () {
                DatePicker.showDateTimePicker(
                  context,
                  onCancel: () {},
                  theme: DatePickerTheme(
                      backgroundColor: Colors.white,
                      cancelStyle: mainStyle,
                      doneStyle: mainStyle,
                      itemStyle: mainStyle),
                  showTitleActions: true,
                  onChanged: (date) {},
                  onConfirm: (date) => setState(() {
                    _fromDateTimeValue = fullDateFormatter.format(date).toString();
                    widget.onConfirmStart(_fromDateTimeValue);
                  }),
                  currentTime: DateTime.now().toLocal(),
                  locale: LocaleType.en,
                );
              },
            ),
            Text(_fromDateTimeValue, style: mainStyle),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Text('إلى تاريخ', style: mainStyle),
            IconButton(
              icon: Icon(Icons.timeline, color: primaryColor),
              onPressed: () {
                DatePicker.showDateTimePicker(
                  context,
                  onCancel: () {},
                  theme: DatePickerTheme(
                      backgroundColor: Colors.white,
                      cancelStyle: mainStyle,
                      doneStyle: mainStyle,
                      itemStyle: mainStyle),
                  showTitleActions: true,
                  onChanged: (date) {},
                  onConfirm: (date) => setState(() {
                    _toDateTimeValue = fullDateFormatter.format(date).toString();
                    widget.onConfirmEnd(_toDateTimeValue);
                  }),
                  currentTime: DateTime.now(),
                  locale: LocaleType.en,
                );
              },
            ),
            Text(_toDateTimeValue, style: mainStyle)
          ],
        ),
      ],
    );
  }
}
