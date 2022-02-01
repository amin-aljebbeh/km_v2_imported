import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:kammun_app/views/products_view/select_file.dart';
import 'widgets_importer.dart';
import 'package:kammun_app/utils/utils_importer.dart';

class AddImageWidget extends StatefulWidget {
  final bool hasImage;
  final Function onSubmit;

  AddImageWidget({Key key, @required this.onSubmit, @required this.hasImage}) : super(key: key);

  @override
  _AddImageWidgetState createState() => _AddImageWidgetState();
}

class _AddImageWidgetState extends State<AddImageWidget> {
  final picker = ImagePicker();
  File image;
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            FlatButton(
              child: Icon(
                Icons.camera,
                color: ColorUtils.kmColors,
                size: 40,
              ),
              onPressed: () {
                getImage(ImageSource.camera);
              },
            ),
            FlatButton(
              child: Icon(
                Icons.image,
                color: ColorUtils.kmColors,
                size: 40,
              ),
              onPressed: () {
                getImage(ImageSource.gallery);
              },
            ),
          ],
        ),
        isLoading
            ? Loader()
            : image != null
                ? Column(
                    children: [
                      Container(
                        alignment: Alignment.center,
                        padding: EdgeInsets.only(top: 10),
                        child: SelectedFileToUpload(
                          image: image,
                          name: '',
                          close: () {
                            setState(() {
                              image = null;
                              // _uploadedFile = null;
                            });
                          },
                        ),
                      ),
                      KammunButton(
                        text: "حفظ الصورة",
                        height: 50,
                        color: ColorUtils.kmColors,
                        onTap: () async {
                          setState(() {
                            isLoading = true;
                          });
                          await widget.onSubmit(image);

                          setState(() {
                            isLoading = false;
                          });
                        },
                      ),
                    ],
                  )
                : Container(),
      ],
    );
  }

  Future getImage(ImageSource imageSource) async {
    final pickedFile =
        await picker.getImage(source: imageSource, imageQuality: 100, maxHeight: 600, maxWidth: 500);

    setState(() {
      if (pickedFile != null) {
        image = File(pickedFile.path);
      }
    });
  }
}
