import 'package:auto_size_text_field/auto_size_text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:kammun_app/utils/Loader.dart';
import 'package:kammun_app/utils/utils_importer.dart';
import 'package:kammun_app/views/Wedgit/AlertMessagess.dart';

import 'services/order_services.dart';

class RatingView extends StatefulWidget {
  final String orderId;
  final Function() onReqestDone;
  RatingView({this.orderId, this.onReqestDone});
  @override
  _RatingViewState createState() => _RatingViewState();
}

class _RatingViewState extends State<RatingView> {
  @override
  void initState() {
    rateValue = 0;
    error = false;
    errorMessage = "";

    super.initState();
  }

  void _requestFocus() {
    setState(() {
      FocusScope.of(context).requestFocus(_focusNode);
    });
  }

  double rateValue;
  bool isLoading = false;
  bool error;
  String errorMessage;

  FocusNode _focusNode = new FocusNode();
  TextEditingController _textFieldController = new TextEditingController();

  Widget _submitRating() {
    final GestureDetector showConfirmButtonWithGesture = new GestureDetector(
      onTap: () async {
        if (rateValue > 0) {
          setState(() {
            isLoading = true;
          });
          bool response = await OrderServices.rateOrder(
              orderId: widget.orderId,
              userFeedback: _textFieldController.text + ".",
              rating: rateValue);
          if (response) {
            Navigator.of(context).pop();

            widget.onReqestDone();
          } else {
            setState(() {
              error = true;
              errorMessage =
                  "حدث خطأ أثناء محاولة إرسال التقييم يرجى التحقق من إتصالك بالإنترنت و المحاولة مجدداً";
            });
          }
        } else {
          setState(() {
            error = true;
            errorMessage = "يرجى اختيار وجه مناسب مع مدى رضاكم عن الخدمة";
          });
        }

        /// Should Be Added ///
        // orderDataList[index].userDeliveryRating = rateValue.toString();
        // _getOrder();

        // KammunRestart.restartApp(context);
      },
      child: new Container(
        height: 40.0,
        decoration: new BoxDecoration(
            color: Colors.green,
            borderRadius: new BorderRadius.all(Radius.circular(6.0))),
        child: new Center(
          child: new Text(
            UtilsImporter().stringUtils.submit_feedback.toUpperCase(),
            style: new TextStyle(
                color: Colors.white,
                fontSize: 20.0,
                fontWeight: FontWeight.w500,
                fontFamily: UtilsImporter().stringUtils.HKGrotesk),
          ),
        ),
      ),
    );

    return new Padding(
        padding: EdgeInsets.only(left: 10.0, right: 10.0, top: 5.0, bottom: 20),
        child: showConfirmButtonWithGesture);
  }

  ScrollController _scroll = new ScrollController();

  Widget build(BuildContext context) {
    final double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          reverse: true,

          controller: _scroll,
          child: isLoading
              ? Container(
                  width: double.infinity,
                  height: MediaQuery.of(context).size.height - 200,
                  child: Center(child: Loader()),
                )
              : Column(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Container(
                      width: double.infinity,
                      padding: EdgeInsets.fromLTRB(
                          0, screenHeight * 0.02, 0, screenHeight * 0.02),
                      decoration: BoxDecoration(
                        border: Border(bottom: BorderSide()),
                      ),
                      child: Text('تقييم الخدمة',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontFamily: UtilsImporter().stringUtils.HKGrotesk,
                              color: UtilsImporter().colorUtils.primarycolor,
                              fontSize: 25)), //font color is diffrent
                    ),
                    error
                        ? AlertMessages(
                            text: errorMessage,
                            messageType: "internetError",
                            headerText: "حدث خطأ",
                          )
                        : Container(
                            // padding: EdgeInsets.zero,
                            ),
                    Container(
                      margin:
                          EdgeInsets.fromLTRB(17, screenHeight * 0.03, 17, 0),
                      child: Text(
                        "كيف كانت تجربة طلبك في كمّون؟ ( تقييمك وملاحظاتك تساعدنا في تطوير خدمة كمّون )",
                        style: TextStyle(
                            fontFamily: UtilsImporter().stringUtils.HKGrotesk,
                            fontSize: 18,
                            color: Colors.black),
                      ), //font color is diffrent
                    ),
                    Container(
                      alignment: Alignment.center,
                      margin: EdgeInsets.fromLTRB(
                          0, screenHeight * 0.07, 17, screenHeight * 0.07),
                      child: RatingBar.builder(
                        initialRating: 0,
                        minRating: 1,
                        direction: Axis.horizontal,
                        allowHalfRating: false,
                        itemCount: 5,
                        itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
                        itemBuilder: (context, _) => Icon(
                          Icons.star,
                          color: Colors.amber,
                        ),
                        onRatingUpdate: (rating) {
                          setState(() {
                            rateValue = rating;
                            print(rateValue);
                          });
                        },
                      ),
                    ),
                    // Container(
                    //   alignment: Alignment.center,
                    //   margin: EdgeInsets.fromLTRB(
                    //       0, screenHeight * 0.07, 17, screenHeight * 0.07),
                    //   child: Row(
                    //     mainAxisAlignment: MainAxisAlignment.center,
                    //     children: [
                    //       IconButton(
                    //         padding: EdgeInsets.zero,
                    //         iconSize: 40,
                    //         onPressed: () {
                    //           setState(() {
                    //             rateValue = 1;
                    //             // feedbackBloc.add(UpdateRateValue(rateValue: 1));
                    //           });
                    //         },
                    //         icon: Icon(Icons.mood_bad),
                    //         color: rateValue == 1 ? Colors.red : Colors.grey,
                    //       ),
                    //       IconButton(
                    //         padding: EdgeInsets.zero,
                    //         iconSize: 40,
                    //         icon: Icon(Icons.sentiment_dissatisfied,
                    //             color: rateValue == 2
                    //                 ? Colors.redAccent
                    //                 : Colors.grey),
                    //         onPressed: () {
                    //           setState(() {
                    //             rateValue = 2;
                    //             //  feedbackBloc.add(UpdateRateValue(rateValue: 2));
                    //           });
                    //         },
                    //       ),
                    //       IconButton(
                    //         padding: EdgeInsets.zero,
                    //         iconSize: 40,
                    //         icon: Icon(Icons.sentiment_neutral,
                    //             color: rateValue == 3
                    //                 ? Colors.amber
                    //                 : Colors.grey),
                    //         onPressed: () {
                    //           setState(() {
                    //             rateValue = 3;
                    //             //  feedbackBloc.add(UpdateRateValue(rateValue: 3));
                    //           });
                    //         },
                    //       ),
                    //       IconButton(
                    //         padding: EdgeInsets.zero,
                    //         iconSize: 40,
                    //         icon: Icon(Icons.sentiment_satisfied,
                    //             color: rateValue == 4
                    //                 ? Colors.lightGreen
                    //                 : Colors.grey),
                    //         onPressed: () {
                    //           setState(() {
                    //             rateValue = 4;
                    //             //  feedbackBloc.add(UpdateRateValue(rateValue: 4));
                    //           });
                    //         },
                    //       ),
                    //       IconButton(
                    //         padding: EdgeInsets.zero,
                    //         iconSize: 40,
                    //         icon: Icon(Icons.sentiment_very_satisfied,
                    //             color: rateValue == 5
                    //                 ? Colors.green
                    //                 : Colors.grey),
                    //         onPressed: () {
                    //           setState(() {
                    //             rateValue = 5;
                    //             //  feedbackBloc.add(UpdateRateValue(rateValue: 5));
                    //           });
                    //         },
                    //       ),
                    //     ],
                    //   ),
                    // ),
                    Container(
                      margin:
                          EdgeInsets.fromLTRB(17, 0, 17, screenHeight * 0.03),
                      child: AutoSizeTextField(
                        textAlign: TextAlign.start,
                        textAlignVertical: TextAlignVertical.top,
                        controller: _textFieldController,
                        maxLines: 4,
                        onTap: _requestFocus,
                        focusNode: _focusNode,
                        cursorColor: Theme.of(context).cursorColor,
                        decoration: InputDecoration(
                          hintStyle: TextStyle(color: Colors.black45),
                          border: OutlineInputBorder(
                            borderSide: BorderSide(
                                //  color: AppColors.grayBorder,
                                ),
                            borderRadius: BorderRadius.circular(5.0),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Colors.orange,
                            ),
                            borderRadius: BorderRadius.circular(5.0),
                          ),
                          labelStyle: TextStyle(
                              fontFamily: UtilsImporter().stringUtils.HKGrotesk,
                              color: _focusNode.hasFocus
                                  ? Colors.orange
                                  : Colors.grey),
                          alignLabelWithHint: true,
                          labelText: 'شاركنا بأفكارك (إختياري)',
                        ),
                      ),
                    ),
                    _submitRating(),
                  ],
                ),

          // Container(
          //   margin: EdgeInsets.fromLTRB(17, 0, 17, screenHeight * 0.17),
          //   child: CCAppButton(
          //     text: "Submit feedback",
          //     onPressed: rateValue > 0
          //         ? () {
          //             feedbackBloc.add(SubmitRate(
          //                 feedbackSection: widget.feedbackSection,
          //                 clientId: _loadingProvider.clientId,
          //                 comment: _textFieldController.text));
          //           }
          //         : null,
          //   ),
          // )
        ),
      ),
    );
  }
}
