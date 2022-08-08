import 'package:flutter/material.dart';

import '../../../core/core_importer.dart';

class InvoiceCard extends StatefulWidget {
  final String title;
  final String info;
  final String details;
  final IconData icon;
  final Function onChange;
  final bool viewButton;
  final bool forAddress;
  const InvoiceCard({
    Key key,
    this.title,
    this.info,
    this.details = ' ',
    this.icon,
    this.onChange,
    this.viewButton,
    this.forAddress = false,
  }) : super(key: key);

  @override
  _InvoiceCardState createState() => _InvoiceCardState();
}

class _InvoiceCardState extends State<InvoiceCard> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => widget.onChange(),
      child: Column(
        children: [
          const SizedBox(height: 25),
          KCard(
            radius: 0,
            child: SizedBox(
              width: MediaQuery.of(context).size.width,
              child: Stack(
                children: [
                  if (widget.forAddress)
                    Row(
                      children: [
                        const Expanded(child: SizedBox()),
                        Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Image.asset('assets/map.png')),
                      ],
                    ),
                  Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                            child: RowCard(
                                info: widget.info,
                                title: widget.title,
                                icon: widget.icon,
                                details: widget.details)),
                        if (widget.viewButton)
                          KOutlinedButton(
                            color: ColorUtils.kmColors,
                            text: StringUtils.chang,
                            width: MediaQuery.of(context).size.width * 0.20,
                            onTap: () => widget.onChange(),
                          )
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
