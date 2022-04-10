import 'package:flutter/material.dart';
import 'package:v_chat_sdk/v_chat_sdk.dart';

import '../../utils/utils_importer.dart';
import '../Widget/widgets_importer.dart';

class ChatView extends StatelessWidget {
  const ChatView({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: const VChatRoomsView(),
      appBar: AppBar(
        backgroundColor: ColorUtils.kmColors,
        flexibleSpace: const SafeArea(
          top: true,
          child: Padding(
            padding: EdgeInsets.only(right: 120),
            child: AppBarKammunImage(),
          ),
        ),
      ),
    );
  }
}
