import '../../../../../core/core_importer.dart';
import '../../../orders/domain/entities/key_value_info_entity.dart';

class InvoiceRow extends StatefulWidget {
  final String title;
  final String info;
  final TextStyle style;
  final List<KeyValueInfoEntity> children;

  const InvoiceRow({Key key, this.title, this.info, this.style, this.children}) : super(key: key);

  @override
  _InvoiceRowState createState() => _InvoiceRowState();
}

class _InvoiceRowState extends State<InvoiceRow> {
  bool visible = false;

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, AppState>(
      converter: (store) => store.state,
      distinct: true,
      builder: (context, state) {
        return Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: const BorderRadius.all(Radius.circular(6.0)),
            border: Border.all(color: widget.children != null ? primaryColor : Colors.white, width: 1.25),
          ),
          child: Column(
            children: [
              SizedBox(
                width: MediaQuery.of(context).size.width,
                child: Padding(
                  padding: const EdgeInsets.only(top: 16, bottom: 16, left: 8, right: 8),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(widget.title, style: widget.style),
                      if (widget.children != null)
                        InkWell(
                          child: Icon(visible ? Icons.keyboard_arrow_up_rounded : Icons.keyboard_arrow_down_rounded,
                              color: primaryColor, size: 30),
                          onTap: () => setState(() => visible = !visible),
                        ),
                      Text(
                          widget.info.replaceAll('-', '') +
                              ' ' +
                              (widget.info != '' ? state.generalInformationState.companyInformation.currency : ''),
                          style: widget.info.contains('-') ? loseStyle : paragraphStyle)
                    ],
                  ),
                ),
              ),
              if (visible)
                Container(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                        children: widget.children
                            .where((child) => child.value != '0')
                            .map((child) => InvoiceRow(
                                children: child.info,
                                info: StringUtils().oCcy.format(child.value),
                                title: child.key,
                                style: informationStyle))
                            .toList())),
            ],
          ),
        );
      },
    );
  }
}
