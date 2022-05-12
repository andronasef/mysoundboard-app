import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';

class AnimatedDownloadButton extends HookWidget {
  @override
  Widget build(BuildContext context) {
    final AnimationController controller =
        useAnimationController(duration: 5.seconds);
    return GestureDetector(
      onTap: () {
        controller.forward();
      },
      child: Expanded(
        child: Lottie.asset("assets/animated/download.json",
            controller: controller,
            fit: BoxFit.fill,
            delegates: const LottieDelegates(
              values: [],
            )),
      ),
    );
  }
}
