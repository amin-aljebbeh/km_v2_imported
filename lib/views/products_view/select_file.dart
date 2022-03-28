import 'dart:io';

import 'package:flutter/material.dart';

class SelectedFileToUpload extends StatelessWidget {
  final File image;
  final VoidCallback close;
  final bool closeFromRight;
  final String name;

  const SelectedFileToUpload({Key key, this.image, this.name, this.close, this.closeFromRight = true})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width / 3.9,
      child: Column(
        children: [
          Container(
            width: MediaQuery.of(context).size.width / 4,
            height: MediaQuery.of(context).size.width / 4,
            alignment: Alignment.center,
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                Positioned(
                  top: 10,
                  right: closeFromRight ? 10 : null,
                  left: closeFromRight ? null : 10,
                  child: Container(
                    width: MediaQuery.of(context).size.width / 4 - 10,
                    height: MediaQuery.of(context).size.width / 4 - 10,
                    decoration: BoxDecoration(image: DecorationImage(image: FileImage(image), fit: BoxFit.cover)),
                  ),
                ),
                Positioned(
                  top: 0,
                  right: closeFromRight ? 0 : null,
                  left: closeFromRight ? null : 0,
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      onTap: () {
                        close();
                      },
                      child: Container(
                        width: 30,
                        height: 30,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                            border: Border.all(
                              width: 1,
                              color: Colors.grey[800],
                            )),
                        padding: EdgeInsets.all(4),
                        child: Icon(
                          Icons.close,
                          size: 13,
                          color: Colors.grey[800],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 4, left: 10),
            child: Text(
              '${name ?? ''}',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyText2.apply(fontSizeDelta: -3),
            ),
          )
        ],
      ),
    );
  }
}
