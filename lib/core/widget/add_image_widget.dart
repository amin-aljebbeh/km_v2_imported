// import 'package:image_picker/image_picker.dart';
import 'package:kammun_app/features/products_view/widgets/select_file.dart';

import '../../core/core_importer.dart';

class AddImageWidget extends StatefulWidget {
  final Function onSubmit;

  const AddImageWidget({Key key, @required this.onSubmit}) : super(key: key);

  @override
  _AddImageWidgetState createState() => _AddImageWidgetState();
}

class _AddImageWidgetState extends State<AddImageWidget> {
  // final picker = ImagePicker();
  File image;

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, AppState>(
      converter: (store) => store.state,
      distinct: true,
      builder: (context, state) {
        return Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                // TextButton(
                //     child: Icon(Icons.camera, color: kmColors, size: 40),
                //     onPressed: () => getImage(ImageSource.camera)),
                // TextButton(
                //     child: Icon(Icons.image, color: kmColors, size: 40),
                //     onPressed: () => getImage(ImageSource.gallery)),
              ],
            ),
            state.loadingState.loading.isNotEmpty
                ? const Loader()
                : image != null
                    ? Column(
                        children: [
                          Container(
                            alignment: Alignment.center,
                            padding: const EdgeInsets.only(top: 10),
                            child:
                                SelectedFileToUpload(image: image, name: '', close: () => setState(() => image = null)),
                          ),
                          KammunButton(
                            text: 'حفظ الصورة',
                            height: 50,
                            color: kmColors,
                            onTap: () async {
                              StoreProvider.of<AppState>(context).dispatch(StartLoading());
                              await widget.onSubmit(image);
                              StoreProvider.of<AppState>(context).dispatch(StopLoading());
                            },
                          ),
                        ],
                      )
                    : Container(),
          ],
        );
      },
    );
  }

// Future getImage(ImageSource imageSource) async {
//   final pickedFile = await picker.pickImage(source: imageSource, imageQuality: 25, maxHeight: 1500, maxWidth: 1500);

//   setState(() {
//     if (pickedFile != null) {
//       image = File(pickedFile.path);
//     }
//   });
// }
}
