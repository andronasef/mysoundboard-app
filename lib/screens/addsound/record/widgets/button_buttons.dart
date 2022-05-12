import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:record/record.dart';

import '../../../../sound.dart';
import '../../../../widgets/snackbar.dart';
import '../../edit_add/add_edit.dart';
import '../models/bottom_button.dart';
import '../record_controller.dart';

class ButtomButtons extends StatelessWidget {
  final AnimationController? animationController;

  const ButtomButtons({Key? key, this.animationController}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final SoundRecordingController controller = Get.find();

    return Container(
      height: 100,
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
          color: context.theme.colorScheme.secondary,
          borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(20), topRight: Radius.circular(20))),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          BottomButton("Cancel", Icons.close_rounded, () {
            // player.stop();
            Sound.deleteTempRecord();
            Get.back();
          }),
          BottomButton(
            "Play",
            Icons.play_arrow_rounded,
            () async {
              controller.recordTimer.cancel();
              await Record().stop();
              animationController!.forward();

              final String filepath = await Sound.getTempRecord();
              if (await File(filepath).exists()) {
                Sound.playSound(await Sound.getTempRecord());
              } else {
                noRecordSnackBar();
              }
            },
          ),
          BottomButton(
            "Done",
            Icons.check_rounded,
            () async {
              await Record().stop();
              final String filepath = await Sound.getTempRecord();
              if (await File(filepath).exists()) {
                Get.off(() => AddEdit(filePath: filepath));
              } else {
                noRecordSnackBar();
              }
            },
          ),
        ],
      ),
    );
  }
}
