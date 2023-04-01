import 'package:flutter/material.dart';
import 'package:turtle/utils/images.dart';

import '../../utils/image_path.dart';

class TurtleLoadingScreen extends StatefulWidget {
  final Widget nextScreen;

  /// Loading Turtle Screen, has animation
  /// <p>
  /// Params: screen to show after animation
  const TurtleLoadingScreen({super.key, required this.nextScreen});

  @override
  State<TurtleLoadingScreen> createState() => _TurtleLoadingScreenState();
}

class _TurtleLoadingScreenState extends State<TurtleLoadingScreen>
    with TickerProviderStateMixin {
  /// Controller -> this is where you control duration of animation
  late final AnimationController _controller =
      AnimationController(duration: const Duration(seconds: 3), vsync: this)
        ..repeat(reverse: false);

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    repeatOnce();
  }

  /// One animation only
  void repeatOnce() async {
    await _controller.forward();
    _nextScreen();
  }

  /// Go to next screen
  void _nextScreen() {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => widget.nextScreen));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: DecoratedBox(
      decoration: const BoxDecoration(
          image: DecorationImage(
              image: AssetImage(
                ImagePath.seaBackground,
              ),
              fit: BoxFit.cover)),
      child: Stack(
        children: [
          // Left seaweed
          PositionedTransition(
            rect: (RelativeRectTween(
              begin: RelativeRect.fromDirectional(
                  textDirection: TextDirection.rtl,
                  start: 0,
                  top: 0,
                  end: 0,
                  bottom: 0),
              end: RelativeRect.fromDirectional(
                  textDirection: TextDirection.rtl,
                  start: 0,
                  top: 0,
                  end: -1000,
                  bottom: 0),
            ).animate(
                CurvedAnimation(parent: _controller, curve: Curves.bounceOut))),
            child: Container(
              child: AppImages.leftSeaweed,
            ),
          ),

          // Right seaweed
          PositionedTransition(
            rect: (RelativeRectTween(
              begin: RelativeRect.fromDirectional(
                  textDirection: TextDirection.rtl,
                  start: 0,
                  top: 0,
                  end: 0,
                  bottom: 0),
              end: RelativeRect.fromDirectional(
                  textDirection: TextDirection.rtl,
                  start: -1000,
                  top: 0,
                  end: 0,
                  bottom: 0),
            ).animate(
                CurvedAnimation(parent: _controller, curve: Curves.bounceOut))),
            child: Container(
              child: AppImages.rightSeaweed,
            ),
          ),

          // Bubbles
          PositionedTransition(
            rect: (RelativeRectTween(
              begin: const RelativeRect.fromLTRB(0, 0, 0, 0),
              end: const RelativeRect.fromLTRB(0, -2000, 0, 0),
            ).animate(
                CurvedAnimation(parent: _controller, curve: Curves.bounceOut))),
            child: Container(
              child: AppImages.bubbles,
            ),
          ),
        ],
      ),
    ));
  }
}
