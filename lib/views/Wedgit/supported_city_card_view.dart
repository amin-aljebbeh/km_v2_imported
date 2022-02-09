import 'package:flutter/material.dart';
import 'package:kammun_app/utils/utils_importer.dart';

class SupportedCityCardView extends StatefulWidget {
  final int id;
  final String name;
  final String deliveryPrice;
  final String isActive;
  final String supportPhoneNumber;
  final String maintenanceMessages;

  SupportedCityCardView({
    this.id,
    this.name,
    this.deliveryPrice,
    this.isActive,
    this.supportPhoneNumber,
    this.maintenanceMessages,
  });

  @override
  State<StatefulWidget> createState() {
    return SupportedCityCardViewState();
  }
}

class SupportedCityCardViewState extends State<SupportedCityCardView> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Theme.of(context).primaryColorLight,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(5),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Expanded(
                    child: Container(
                  child: Wrap(
                    children: <Widget>[
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Wrap(
                            children: <Widget>[
                              Center(
                                child: Text(
                                  widget.name,
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      fontWeight: FontWeight.w700,
                                      fontFamily: StringUtils.fontFamilyHKGrotesk,
                                      fontSize: 18),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 8),
                          Center(
                            child: Wrap(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text("إجرة التوصيل:",
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          fontWeight: FontWeight.w700,
                                          color: ColorUtils.primaryColor,
                                          fontFamily: StringUtils.fontFamilyHKGrotesk,
                                          fontSize: 18)),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(widget.deliveryPrice,
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          fontWeight: FontWeight.w700,
                                          color: ColorUtils.primaryColor,
                                          fontFamily: StringUtils.fontFamilyHKGrotesk,
                                          fontSize: 18)),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                )),
              ],
            ),
          ),
          SizedBox(height: 4),
          Divider(
            color: ColorUtils.primaryColor,
            thickness: 2.5,
          )
        ],
      ),
    );
  }
}
