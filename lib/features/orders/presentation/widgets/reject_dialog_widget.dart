import '../../../../core/core_importer.dart';

class RejectDialogWidget extends StatefulWidget {
  final int initialRejectID;
  final String message;
  final ValueChanged<int> onRejectIDChanged;
  final TextEditingController commentController;

  const RejectDialogWidget(
      {Key key, this.initialRejectID, this.onRejectIDChanged, this.message, this.commentController})
      : super(key: key);

  @override
  _RejectDialogWidgetState createState() => _RejectDialogWidgetState();
}

class _RejectDialogWidgetState extends State<RejectDialogWidget> {
  int _selectedID;

  @override
  void initState() {
    super.initState();
    _selectedID = widget.initialRejectID;
  }

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, AppState>(
      converter: (store) => store.state,
      distinct: true,
      builder: (context, state) {
        return Column(
          children: [
            Text(widget.message, style: dialogStyle),
            DropdownButton<int>(
              items: state.ordersState.cancelReasons
                  .map(
                      (reason) => DropdownMenuItem<int>(child: Text(reason.name, style: dialogStyle), value: reason.id))
                  .toList(),
              value: _selectedID,
              onChanged: (value) {
                setState(() => _selectedID = value);
                widget.onRejectIDChanged(value);
              },
            ),
            EntryField(controller: widget.commentController, hint: 'بإمكانك إضافة توضيح', onChange: () {})
          ],
        );
      },
    );
  }
}
