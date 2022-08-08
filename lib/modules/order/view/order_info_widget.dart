import '../../../core/core_importer.dart';

class OrderInfoWidget extends StatelessWidget {
  final String title;
  final List<KeyValueModel> children;
  const OrderInfoWidget({Key key, this.title, this.children}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, AppState>(
      converter: (store) => store.state,
      distinct: true,
      builder: (context, state) {
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (title != ' ') Text(title, style: informationStyle),
              const SizedBox(height: 5),
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
            ],
          ),
        );
      },
    );
  }
}
