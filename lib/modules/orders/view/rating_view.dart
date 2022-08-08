import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import '../../../core/core_importer.dart';
import '../redux/orders_action.dart';

class RatingView extends StatefulWidget {
  final String orderId;
  const RatingView({Key key, this.orderId}) : super(key: key);
  @override
  _RatingViewState createState() => _RatingViewState();
}

class _RatingViewState extends State<RatingView> {
  @override
  void initState() {
    rateValue = 0;
    super.initState();
  }

  void _requestFocus() {
    setState(() {
      FocusScope.of(context).requestFocus(_focusNode);
    });
  }

  double rateValue;

  final FocusNode _focusNode = FocusNode();
  final TextEditingController _textFieldController = TextEditingController();

  final ScrollController _scroll = ScrollController();

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, AppState>(
      converter: (store) => store.state,
      builder: (context, state) {
        return TemporaryLoading(
          child: Scaffold(
            resizeToAvoidBottomInset: false,
            body: SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: SingleChildScrollView(
                  reverse: true,
                  controller: _scroll,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(bottom: 10),
                        child: Row(
                          children: [
                            Icon(Icons.star, color: ColorUtils.kmColors2),
                            Padding(
                              padding: const EdgeInsets.only(right: 10),
                              child: Text('تقييم الطلب',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: ColorUtils.kmColors2,
                                    fontFamily: StringUtils.fontFamily,
                                    fontSize: 18.0,
                                  )),
                            ),
                          ],
                        ),
                      ),
                      Text('كيف كانت تجربة طلبك في كمون؟', style: informationStyle),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 10),
                        child: Text('( تقييمك وملاحظاتك تساعدنا في تطوير خدمة كمون )',
                            style: disableStyle.copyWith(fontSize: 15)),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                          alignment: Alignment.center,
                          child: RatingBar.builder(
                            initialRating: 0,
                            minRating: 1,
                            direction: Axis.horizontal,
                            allowHalfRating: false,
                            itemCount: 5,
                            itemPadding: const EdgeInsets.symmetric(horizontal: 4.0),
                            itemBuilder: (context, _) => Icon(Icons.star, color: ColorUtils.kmColors2),
                            onRatingUpdate: (rating) => setState(() => rateValue = rating),
                          ),
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.fromLTRB(17, 0, 17, MediaQuery.of(context).size.height * 0.03),
                        child: TextField(
                          textAlign: TextAlign.start,
                          textAlignVertical: TextAlignVertical.top,
                          controller: _textFieldController,
                          maxLines: 4,
                          onTap: _requestFocus,
                          focusNode: _focusNode,
                          showCursor: true,
                          decoration: InputDecoration(
                            hintStyle: const TextStyle(color: Colors.black45),
                            border: OutlineInputBorder(
                                borderSide: const BorderSide(), borderRadius: BorderRadius.circular(5.0)),
                            focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: ColorUtils.kmColors2),
                                borderRadius: BorderRadius.circular(5.0)),
                            labelStyle: TextStyle(
                                fontFamily: StringUtils.fontFamily,
                                color: _focusNode.hasFocus ? ColorUtils.kmColors2 : Colors.grey),
                            alignLabelWithHint: true,
                            labelText: 'شاركنا بأفكارك (إختياري)',
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(right: 17, left: 17),
                        child: KButton(
                          color: ColorUtils.kmColors2,
                          height: 50,
                          onTap: () {
                            if (rateValue > 0) {
                              StoreProvider.of<AppState>(context).dispatch(
                                RateOrder(
                                  orderId: widget.orderId,
                                  userFeedback: _textFieldController.text + '.',
                                  rating: rateValue,
                                ),
                              );
                            } else {
                              StoreProvider.of<AppState>(context)
                                  .dispatch(CatchError(errorMessage: 'يرجى اختيار وجه مناسب مع مدى رضاكم عن الخدمة'));
                            }
                          },
                          width: MediaQuery.of(context).size.width * 0.95,
                          text: StringUtils.submitFeedback,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

settingModalBottomSheet(BuildContext context, int index) {
  showMaterialModalBottomSheet(
      context: context,
      builder: (context) => Container(
          padding: const EdgeInsets.all(5),
          height: MediaQuery.of(context).size.height * 0.8,
          child:
              RatingView(orderId: StoreProvider.of<AppState>(context).state.ordersState.orders[index].id.toString())));
}
