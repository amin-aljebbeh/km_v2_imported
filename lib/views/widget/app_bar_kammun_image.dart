import 'package:flutter/material.dart';

class AppBarKammunImage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 5.0),
          child: Transform.scale(
            scale: 2,
            child: InkWell(
              onTap: () {
                Navigator.pushNamedAndRemoveUntil(
                  context,
                  '/home',
                  (Route<dynamic> route) => false,
                );
              },
              child: Image.asset(
                "assets/logobw.png",
                width: 150,
                height: 50,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
