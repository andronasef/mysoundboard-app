import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:record/record.dart';

import '../../../core/themes.dart';
import '../../../sound.dart';
import 'record_controller.dart';
import 'widgets/button_buttons.dart';

class SoundRecording extends HookWidget {
  final RxInt recordSeconds = 0.obs;
  final RxBool hasRecord = false.obs;
  @override
  Widget build(BuildContext context) {
    final controller = Get.put(SoundRecordingController());

    Record().hasPermission();
    final animationController = useAnimationController(duration: 1.seconds);

    return SafeArea(
      child: Scaffold(
          body: Column(
        children: [
          Container(
            height: context.height * .2,
            decoration: BoxDecoration(
                color: context.theme.colorScheme.secondary,
                borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(20),
                    bottomRight: Radius.circular(20))),
            child: Center(
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text("Record Your Sound",
                        style: dts.copyWith(fontSize: 30),
                        textAlign: TextAlign.center),
                    const SizedBox(height: 10),
                    Obx(
                      () => Text("${recordSeconds.value}" + " Seconds",
                          style: dts.copyWith(fontSize: 30),
                          textAlign: TextAlign.center),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Expanded(
            child: GestureDetector(
                onTap: () async {
                  if (!hasRecord.value) {
                    hasRecord.value = true;
                    recordSeconds.value = 0;
                    if (await Record().hasPermission()) {
                      await Record().start(
                        path: await Sound.getTempRecord(), // required
                      );
                      controller.recordTimer = Timer.periodic(
                          1.seconds, (timer) => recordSeconds.value++);
                      await animationController.repeat();
                    }
                  } else {
                    hasRecord.value = false;
                    animationController.forward();
                    await Record().stop();
                    controller.recordTimer.cancel();
                  }
                },
                child: Center(
                  child: Lottie.asset("assets/animated/record.json",
                      controller: animationController,
                      fit: BoxFit.cover,
                      delegates: LottieDelegates(
                        values: [
                          ValueDelegate.color(
                            const ['Base Layer 3', 'Ellipse 1', 'Fill 1'],
                            value: context.theme.colorScheme.secondary,
                          ),
                          ValueDelegate.color(
                            const ['Base Layer 4', 'Ellipse 1', 'Fill 1'],
                            value: context.theme.colorScheme.secondary,
                          ),
                          ValueDelegate.color(
                            const ['base', 'Ellipse 1', 'Fill 1'],
                            value: context.theme.colorScheme.secondary,
                          ),
                          ValueDelegate.color(
                              const ['Shape 2 Outlines', 'Group 1', 'Fill 1'],
                              value: Colors.white),
                        ],
                      )),
                )),
          ),
          ButtomButtons(
            animationController: animationController,
          ),
        ],
      )),
    );
  }
}
