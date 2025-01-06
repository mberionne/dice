import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'dart:math';
import 'dice_painter.dart';

part 'main_page_controller.dart';

class MainPage extends StatefulWidget {
  final String title = "";

  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends _MainPageController {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () => maybeRollDie(),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            if (_current == 0)
              const Text(
                "Tap to roll",
                style: TextStyle(fontSize: 20, color: Colors.white),
              ),
            if (_current > 0)
              //Text(
              //  '$_previous -> $_current ($_animationProgress)',
              //  style: const TextStyle(color: Colors.white),
              //),
              SizedBox(
              // We reducde the height so that it is centered correctly.
              // Pass the entire width and handle margins in the painter.
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              child:
              ClipRect(
                  child: CustomPaint(
                      painter: DicePainter(
                          _previous, _current, _animationProgress)))),
          ],
        ),
      ),
    ));
  }
}
