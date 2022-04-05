import 'package:flutter/material.dart';
import 'package:kammun_app/utils/utils_importer.dart';
import 'package:kammun_app/views/add_address/add_address_view.dart';
import 'package:kammun_app/views/loading/loading_services.dart';
import 'package:kammun_app/views/widget/dialog_button.dart';
import 'package:kammun_app/views/widget/my_dialog.dart';

class AddressWidget extends StatelessWidget {
  final int index;
  final Function onRemove;

  const AddressWidget({Key key, this.index, this.onRemove}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        showMyDialog(
          title: LoadingScreenServices.userAddress[index].street,
          context: context,
          dialogButtons: [
            DialogButton(
              text: StringUtils.close,
              onTap: () {
                Navigator.of(context).pop();
              },
            ),
            DialogButton(
              text: StringUtils.edit,
              onTap: () {
                Navigator.of(context).pop();
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AddAddressView(
                      isFromDeliveryScreen: false,
                      addressIndex: index,
                    ),
                  ),
                );
              },
            ),
          ],
          content: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  LoadingScreenServices.userAddress[index].supportedCityName,
                  style: TextStyle(
                      fontWeight: FontWeight.w700, fontFamily: StringUtils.fontFamilyHKGrotesk, fontSize: 20),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  LoadingScreenServices.userAddress[index].building,
                  style: TextStyle(
                      fontWeight: FontWeight.w400,
                      color: ColorUtils.greyColor,
                      fontFamily: StringUtils.fontFamilyHKGrotesk,
                      fontSize: 20),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  LoadingScreenServices.userAddress[index].description,
                  style: TextStyle(
                      fontWeight: FontWeight.w400,
                      color: ColorUtils.greyColor,
                      fontFamily: StringUtils.fontFamilyHKGrotesk,
                      fontSize: 20),
                ),
              ),
            ],
          ),
        );
      },
      child: Padding(
        padding: const EdgeInsets.only(left: 20, top: 10),
        child: Container(
          decoration: BoxDecoration(
              borderRadius: const BorderRadius.all(Radius.circular(5.0) //         <--- border radius here
                  ),
              border: Border.all(
                width: 2,
                color: ColorUtils.kmColors,
              )),
          child: Card(
            elevation: 1.0,
            color: Theme.of(context).primaryColorLight,
            child: Column(
              children: [
                Row(
                  children: <Widget>[
                    const SizedBox(width: 10),
                    Expanded(
                      child: Wrap(
                        direction: Axis.horizontal,
                        children: <Widget>[
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  LoadingScreenServices.userAddress[index].supportedCityName,
                                  style: TextStyle(
                                      fontWeight: FontWeight.w700,
                                      fontFamily: StringUtils.fontFamilyHKGrotesk,
                                      fontSize: 20),
                                ),
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(
                                      LoadingScreenServices.userAddress[index].street,
                                      style: TextStyle(
                                          fontWeight: FontWeight.w400,
                                          color: ColorUtils.greyColor,
                                          fontFamily: StringUtils.fontFamilyHKGrotesk,
                                          fontSize: 20),
                                    ),
                                  ),
                                  Row(
                                    children: [
                                      IconButton(
                                        icon: Icon(
                                          Icons.edit,
                                          color: ColorUtils.primaryColor,
                                        ),
                                        onPressed: () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) => AddAddressView(
                                                isFromDeliveryScreen: false,
                                                addressIndex: index,
                                              ),
                                            ),
                                          );
                                        },
                                      ),
                                      IconButton(
                                        icon: Icon(
                                          Icons.delete,
                                          color: ColorUtils.primaryColor,
                                        ),
                                        onPressed: () {
                                          onRemove();
                                        },
                                      ),
                                    ],
                                  )
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
