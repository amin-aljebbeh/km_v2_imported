import '../../../core/core_importer.dart';
import 'invoice_row.dart';

class InvoiceInfoWidget extends StatelessWidget {
  final String title;
  final List<KeyValueModel> children;

  const InvoiceInfoWidget({Key key, this.title, this.children}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 25),
        if (title != ' ') Text(title, style: informationStyle),
        const SizedBox(height: 10),
        KCard(
            radius: 6,
            child: Column(
                children: children
                    .where((info) => info.value != '0')
                    .toList()
                    .map((info) => InvoiceRow(
                          style: informationStyle,
                          children: info.info,
                          title: info.key,
                          info: StringUtils().oCcy.format(int.parse(info.value.split('.')[0])),
                        ))
                    .toList())),
        const SizedBox(height: 25),
      ],
    );
  }
}
