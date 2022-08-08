import 'package:flutter/material.dart';

import '../../../core/core_importer.dart';

class ChooseInvoiceDetails extends StatelessWidget {
  final IconData icon;
  final String title;
  final String info;
  final Function onChoose;
  final String details;
  const ChooseInvoiceDetails({Key key, this.onChoose, this.icon, this.title, this.info, this.details = ' '})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, AppState>(
      converter: (store) => store.state,
      builder: (context, state) {
        return InkWell(
          child: Padding(
            padding: const EdgeInsets.all(15.0),
            child: RowCard(icon: icon, title: title, info: info, details: details, isForAddress: true),
          ),
          onTap: () => onChoose(),
        );
      },
    );
  }
}
