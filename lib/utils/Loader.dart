import 'dart:math' as math;
import 'package:flutter/material.dart'; 
import 'package:kammun_app/utils/utils_importer.dart';

class Actor extends StatelessWidget {
  final size;

  const Actor({Key key, this.size = 20.0}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
          shape: BoxShape.circle, color: UtilsImporter().colorUtils.kmColors
          //color: Color.fromARGB(255, 66, 103, 178),
          ),
    );
  }
}

class Loader extends StatefulWidget {
  @override
  _Loader createState() => _Loader();
}

class _Loader extends State<Loader> with SingleTickerProviderStateMixin {
  final int numberOfActors = 3;
  final double initialOffset = 0.0;
  final double finalOffset = 1.0;
  AnimationController _loadingAnimationController;
  @override
  void initState() {
    super.initState();
    _initLoadingAnimationController();
    _loadingAnimationController.forward();
  }

  @override
  void dispose() {
    _loadingAnimationController.dispose();
    super.dispose();
  }

  void _initLoadingAnimationController() {
    _loadingAnimationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 1800),
    )..addStatusListener((AnimationStatus status) {
        if (status == AnimationStatus.completed) {
          _loadingAnimationController.forward(from: 0);
        }
      });
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: 80,
        height: 50,
        child: Column(
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: List.generate(numberOfActors, _generateActors),
            ),
          ],
        ),
      ),
    );
  }

  Widget _generateActors(int index) {
    Animation animation = _initLoadingAnimation(index);
    return AnimatedBuilder(
      animation: animation,
      builder: (BuildContext context, Widget child) {
        return Transform.scale(
          scale: animation.value,
          child: child,
        );
      },
      child: Actor(),
    );
  }

  Animation<double> _initLoadingAnimation(int index) {
    double lastActorStartTime = 0.3;
    double actorAnimationDuration = 0.6;
    double begin = lastActorStartTime * (index / numberOfActors);
    double end = actorAnimationDuration + begin;

    return Sinusoid(min: initialOffset, max: finalOffset).animate(
      CurvedAnimation(
        parent: _loadingAnimationController,
        curve: Interval(begin, end, curve: Curves.easeIn),
      ),
    );
  }
}

class Sinusoid extends Animatable<double> {
  final double min;
  final double max;

  Sinusoid({this.min, this.max});

  @override
  double transform(double t) {
    return min + (max - min) * math.sin(math.pi * t);
  }
}
