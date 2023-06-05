import '../../../../../core/core_importer.dart';
import '../../../orders/domain/entities/key_value_info_entity.dart';
import 'invoice_row.dart';

class InvoiceInfoWidget extends StatelessWidget {
  final String title;
  final List<KeyValueInfoEntity> children;

  const InvoiceInfoWidget({Key key, this.title, this.children}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 25),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (title != ' ') Text(title, style: informationStyle),
          Padding(
            padding: const EdgeInsets.only(top: 10, bottom: 25),
            child: KCard(
                radius: const BorderRadius.all(Radius.circular(6)),
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
          ),
        ],
      ),
    );
  }
}
