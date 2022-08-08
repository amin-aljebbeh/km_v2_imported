import 'package:flutter/material.dart';
import '../../../core/core_importer.dart';
import '../redux/update_action.dart';

class UpdateScreen extends StatefulWidget {
  static const String routeName = '/UpdateScreen';
  const UpdateScreen({Key key}) : super(key: key);
  @override
  State<StatefulWidget> createState() => UpdateScreenState();
}

class UpdateScreenState extends State<UpdateScreen> {
  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, AppState>(
      converter: (store) => store.state,
      builder: (context, state) {
        return Scaffold(
          body: Padding(
            padding: const EdgeInsets.only(left: 30, top: 0, right: 30, bottom: 10),
            child: SafeArea(
              child: SizedBox(
                width: double.infinity,
                height: double.infinity,
                child: SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(parent: BouncingScrollPhysics()),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.only(top: 50),
                        child: Image.asset('assets/update@3x.png', width: MediaQuery.of(context).size.width * 0.8),
                      ),
                      const SizedBox(height: 50),
                      KCard(
                        radius: 6,
                        child: Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Column(
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text('تحديث مطلوب',
                                    textAlign: TextAlign.center,
                                    style: paragraphStyle.copyWith(color: ColorUtils.kmColors2)),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(5),
                                child: Text(
                                    'لديك نسخة قديمة من التطبيق. يرجى التحديث حتى تتمكن من الاستفادة من خدمات كمون.',
                                    textAlign: TextAlign.center,
                                    style: informationStyle),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 25),
                        child: SizedBox(
                          width: MediaQuery.of(context).size.width,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              if (state.updateState.optionalUpdate)
                                KButton(
                                  color: ColorUtils.primaryColor,
                                  onTap: () => StoreProvider.of<AppState>(context)
                                      .dispatch(PushAndReplace(routeName: StoreView.routeName)),
                                  text: 'التحديث لاحقاً',
                                  width: MediaQuery.of(context).size.width * 0.40,
                                  height: 50,
                                ),
                              state.updateState.optionalUpdate
                                  ? KButton(
                                      height: 50,
                                      width: MediaQuery.of(context).size.width * 0.40,
                                      color: ColorUtils.kmColors2,
                                      text: 'التحديث الآن',
                                      onTap: () => StoreProvider.of<AppState>(context).dispatch(LaunchUpdate()),
                                    )
                                  : Expanded(
                                      child: KButton(
                                        height: 50,
                                        width: MediaQuery.of(context).size.width * 0.35,
                                        color: ColorUtils.kmColors2,
                                        text: 'التحديث الآن',
                                        onTap: () => StoreProvider.of<AppState>(context).dispatch(LaunchUpdate()),
                                      ),
                                    ),
                            ],
                          ),
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
