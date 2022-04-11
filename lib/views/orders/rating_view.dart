import 'package:auto_size_text_field/auto_size_text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:kammun_app/utils/utils_importer.dart';
import 'package:kammun_app/views/widget/widgets_importer.dart';

import 'services/order_services.dart';

class RatingView extends StatefulWidget {
  final String orderId;
  final Function() onRequestDone;
  const RatingView({Key key, this.orderId, this.onRequestDone}) : super(key: key);
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

  final FocusNode _focusNode = FocusNode();
  final TextEditingController _textFieldController = TextEditingController();

  final ScrollController _scroll = ScrollController();

  @override
  Widget build(BuildContext context) {
    final double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          reverse: true,
          controller: _scroll,
          child: isLoading
              ? SizedBox(
                  width: double.infinity,
                  height: MediaQuery.of(context).size.height - 200,
                  child: const Center(child: Loader()),
                )
              : Column(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Container(
                      width: double.infinity,
                      padding: EdgeInsets.fromLTRB(0, screenHeight * 0.02, 0, screenHeight * 0.02),
                      decoration: const BoxDecoration(
                        border: Border(bottom: BorderSide()),
                      ),
                      child: Text('تقييم الخدمة',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontFamily: StringUtils.fontFamilyHKGrotesk,
                              color: ColorUtils.primaryColor,
                              fontSize: 25)),
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
                      margin: EdgeInsets.fromLTRB(17, screenHeight * 0.03, 17, 0),
                      child: Text(
                        "كيف كانت تجربة طلبك في كمّون؟ ( تقييمك وملاحظاتك تساعدنا في تطوير خدمة كمّون )",
                        style: TextStyle(
                            fontFamily: StringUtils.fontFamilyHKGrotesk, fontSize: 18, color: Colors.black),
                      ),
                    ),
                    Container(
                      alignment: Alignment.center,
                      margin: EdgeInsets.fromLTRB(0, screenHeight * 0.07, 17, screenHeight * 0.07),
                      child: RatingBar.builder(
                        initialRating: 0,
                        minRating: 1,
                        direction: Axis.horizontal,
                        allowHalfRating: false,
                        itemCount: 5,
                        itemPadding: const EdgeInsets.symmetric(horizontal: 4.0),
                        itemBuilder: (context, _) => const Icon(
                          Icons.star,
                          color: Colors.amber,
                        ),
                        onRatingUpdate: (rating) {
                          setState(() {
                            rateValue = rating;
                          });
                        },
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.fromLTRB(17, 0, 17, screenHeight * 0.03),
                      child: AutoSizeTextField(
                        textAlign: TextAlign.start,
                        textAlignVertical: TextAlignVertical.top,
                        controller: _textFieldController,
                        maxLines: 4,
                        onTap: _requestFocus,
                        focusNode: _focusNode,
                        showCursor: true,
                        cursorColor: const TextSelectionThemeData().cursorColor,
                        decoration: InputDecoration(
                          hintStyle: const TextStyle(color: Colors.black45),
                          border: OutlineInputBorder(
                            borderSide: const BorderSide(),
                            borderRadius: BorderRadius.circular(5.0),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: const BorderSide(
                              color: Colors.orange,
                            ),
                            borderRadius: BorderRadius.circular(5.0),
                          ),
                          labelStyle: TextStyle(
                              fontFamily: StringUtils.fontFamilyHKGrotesk,
                              color: _focusNode.hasFocus ? Colors.orange : Colors.grey),
                          alignLabelWithHint: true,
                          labelText: 'شاركنا بأفكارك (إختياري)',
                        ),
                      ),
                    ),
                    KammunButton(
                      color: Colors.green,
                      onTap: () async {
                        if (rateValue > 0) {
                          setState(() {
                            isLoading = true;
                          });
                          bool response = await OrderServices.rateOrderService(
                              orderId: widget.orderId,
                              userFeedback: _textFieldController.text + ".",
                              rating: rateValue);
                          if (response) {
                            Navigator.of(context).pop();

                            widget.onRequestDone();
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
                      },
                      width: MediaQuery.of(context).size.width * 0.95,
                      text: StringUtils.submitFeedback,
                    ),
                  ],
                ),
        ),
      ),
    );
  }
}
