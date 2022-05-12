import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mysoundboard/core/themes.dart';
import 'package:mysoundboard/screens/addsound/edit_add/add_edit.dart';

import '../../../core/routes.dart';
import '../../../sound.dart';
import '../cwidgets/list_tile.dart';
import '../home_controller.dart';

class AddSoundBottomSheet extends StatelessWidget {
  final List<Widget> addSoundActions = [
    const SizedBox(height: 10),
    listViewItem("From File", Icons.file_copy, () {
      Sound.addSoundFilePicker();
    }),
    listViewItem("From Record", Icons.mic_rounded, () {
      Get.toNamed(Routes.soundRecording);
    }),
    listViewItem("From Online Search", Icons.cloud_rounded, () {
      Get.toNamed(Routes.soundOnlineSearch);
    }),
    listViewItem("Cancel", Icons.close, () {}),
  ];

  final List<Widget> addFolderActions = [
    listViewItem("New empty folder", Icons.create_new_folder, () {
      Get.to(() => const AddEdit(
            isfolder: true,
          ));
    }),
    const SizedBox(height: 10),
    const Text(
      "More options coming soon",
      style: dts,
    ),
    const SizedBox(height: 10),
  ];

  @override
  Widget build(BuildContext context) {
    return BottomSheet(
        clipBehavior: Clip.antiAliasWithSaveLayer,
        onClosing: () {},
        builder: (context) {
          final list = [
            listViewItem("New empty folder", Icons.create_new_folder, () {
              Get.to(() => const AddEdit(
                    isfolder: true,
                  ));
            }),
            const SizedBox(height: 10),
            const Text(
              "More options coming soon",
              style: dts,
            ),
            const SizedBox(height: 10),
          ];
          return SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: Get.find<HomeController>().pageNumber.value == 0
                  ? list
                  : addSoundActions,
            ),
          );
        },
        shape: const ContinuousRectangleBorder(
            borderRadius: BorderRadius.only(
          topRight: Radius.circular(50),
          topLeft: Radius.circular(50),
        )));
  }
}
