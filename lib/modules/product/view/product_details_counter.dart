import 'package:flutter/material.dart';

import '../../../core/core_importer.dart';

class ProductDetailsCounter extends StatefulWidget {
  final int initialCount;
  final int productId;
  final Function(int) onAdd;
  final Function(int) onRemove;
  const ProductDetailsCounter({Key key, this.productId, this.onAdd, this.onRemove, this.initialCount})
      : super(key: key);

  @override
  _ProductDetailsCounterState createState() => _ProductDetailsCounterState();
}

class _ProductDetailsCounterState extends State<ProductDetailsCounter> {
  int count;
  @override
  void initState() {
    count = widget.initialCount;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, AppState>(
      converter: (store) => store.state,
      builder: (context, state) {
        return KCard(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              IconButton(
                icon: Icon(Icons.add, size: 30, color: ColorUtils.primaryColor),
                padding: EdgeInsets.zero,
                onPressed: () {
                  setState(() {
                    count++;
                    widget.onAdd(count);
                  });
                },
              ),
              Padding(
                padding: const EdgeInsets.only(top: 10),
                child: Text(
                  count.toString(),
                  style: TextStyle(
                    fontWeight: FontWeight.w800,
                    color: Colors.black,
                    fontFamily: StringUtils.fontFamily,
                    fontSize: 25,
                  ),
                ),
              ),
              IconButton(
                icon: Icon(Icons.remove, size: 30, color: ColorUtils.primaryColor),
                padding: EdgeInsets.zero,
                onPressed: () {
                  setState(() {
                    if (count > 1) {
                      count--;
                      widget.onRemove(count);
                    }
                  });
                },
              ),
            ],
          ),
          radius: 30,
        );
      },
    );
  }
}
