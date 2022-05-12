// ignore_for_file: avoid_dynamic_calls

import 'dart:async';
import 'dart:io';

import 'package:badges/badges.dart';
import 'package:flutter/material.dart';
import 'package:fluttericon/entypo_icons.dart';
import 'package:get/get.dart';
import 'package:just_audio/just_audio.dart';
import 'package:mysoundboard/screens/home/home_controller.dart';
import 'package:mysoundboard/widgets/dialog.dart';
import 'package:share_plus/share_plus.dart';

import '../../../../../core/themes.dart';
import '../../../../../sound.dart';
import '../../../../../utils/database.dart';
import '../../../../addsound/edit_add/add_edit.dart';
import '../../../cwidgets/list_tile.dart';

class SoundButton extends StatefulWidget {
  final int? keyValue;
  const SoundButton({Key? key, this.keyValue}) : super(key: key);

  @override
  State<SoundButton> createState() => _SoundButtonState();
}

class _SoundButtonState extends State<SoundButton> {
  final controller = Get.find<HomeController>();

  final RxBool isPlaying = false.obs;
  final AudioPlayer player = AudioPlayer();
  final Rx<Timer> durationTimer = Timer(0.seconds, () {}).obs;

  Future<void> playSound(String? path) async {
    // ignore: cast_nullable_to_non_nullable
    if (Settings.spamySounds as bool) {
      isPlaying.value = true;
      player.stop();
      if (File(path!).existsSync()) {
        try {
          await player.setFilePath(path);
          player.play();
          durationTimer.value.cancel();
          durationTimer.value =
              Timer(player.duration!, () => isPlaying.value = false);
        } finally {}
      }
    } else {
      if (!isPlaying.value) {
        player.setLoopMode(LoopMode.off);
        durationTimer.value.cancel();
        isPlaying.value = true;
        if (File(path!).existsSync()) {
          try {
            await player.setFilePath(path);
            player.play();
            durationTimer.value =
                Timer(player.duration!, () => isPlaying.value = false);
          } finally {}
        }
      } else {
        player.stop();
        isPlaying.value = false;
      }
    }
  }

  Future<void> loopSound(String path) async {
    durationTimer.value.cancel();

    if (!isPlaying.value) {
      isPlaying.value = true;
      if (File(path).existsSync()) {
        try {
          await player.setFilePath(path);
          player.play();
          player.setLoopMode(LoopMode.one);
        } finally {}
      }
    } else {
      isPlaying.value = false;
      player.setLoopMode(LoopMode.off);
      player.stop();
    }
  }

  @override
  void dispose() {
    player.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final sound = controller.nowDB.value.get(widget.keyValue);
    final String? path = sound[1] as String?;
    final String? name = sound[0] as String?;
    return Obx(
      () => Badge(
        showBadge: isPlaying.value,
        badgeColor: Colors.white,
        animationType: BadgeAnimationType.scale,
        badgeContent: Icon(
          Icons.play_arrow_rounded,
          size: 15,
          color: context.theme.colorScheme.secondary,
        ),
        child: Container(
          clipBehavior: Clip.antiAlias,
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(10)),
          child: Material(
            color: context.theme.colorScheme.secondary,
            child: InkWell(
              onTap: () {
                playSound(path);
              },
              child: Center(
                child: Stack(
                  alignment: Alignment.center,
                  fit: StackFit.expand,
                  children: [
                    Center(
                      child: Padding(
                        padding: const EdgeInsets.only(
                            left: 8.0, right: 8, bottom: 16),
                        child: Text(
                          name!,
                          textAlign: TextAlign.center,
                          overflow: TextOverflow.ellipsis,
                          maxLines: 3,
                          style: dts.copyWith(fontSize: 15),
                        ),
                      ),
                    ),
                    Positioned(
                        bottom: -10,
                        child: IconButton(
                          onPressed: () => myDialog([
                            const SizedBox(height: 15),
                            Text(
                              name,
                              textAlign: TextAlign.center,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: dts.copyWith(fontSize: 18),
                            ),
                            listViewItem("Edit", Icons.edit_rounded, () {
                              Get.to(() => AddEdit(id: widget.keyValue));
                            }),
                            listViewItem("Delete", Icons.delete, () {
                              Sound.removeSound(widget.keyValue);
                            }),
                            listViewItem("Share", Icons.share_rounded,
                                () async {
                              await Share.shareFiles(
                                [
                                  controller.nowDB.value.get(widget.keyValue)[1]
                                      as String
                                ],
                              );
                            }),
                            listViewItem(
                                isPlaying.value ? "Stop Sound" : "Loop",
                                isPlaying.value
                                    ? Icons.stop_circle_rounded
                                    : Icons.loop,
                                () => loopSound(path!)),
                            listViewItem(
                                "Cancel", Icons.close, () => Get.back()),
                          ]),
                          icon: const Icon(Entypo.dot_3),
                        ))
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
