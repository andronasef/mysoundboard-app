import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:reorderable_grid_view/reorderable_grid_view.dart';

import '../../../../utils/database.dart';
import '../../home_controller.dart';
import 'widgets/sound_button.dart';

class SoundGrid extends GetView<HomeController> {
  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final nowbox =
          controller.folderName.value == "main" ? sounds : foldersSounds;

      return ValueListenableBuilder(
        valueListenable: nowbox.listenable(),
        builder: (context, Box box, child) {
          final keys = controller.isMainFolder.value
              //  Old Pattern (First Version) => (Key = ID & Value & folder = [Name Of Sound, Path Of File, Folder Name])
              ? box.keys
              // New Pattern => (Key = ID & Value & folder = [Name Of Sound, Path Of File,]
              : box.keys.where((keyvalue) {
                  return (box.get(keyvalue) as List)[2] ==
                      controller.folderName.value;
                }).toList();

          return Obx(() => controller.isManyFilesLoading.value
              ? FilesLoading()
              : keys.isNotEmpty
                  ? ReorderableGridView.count(
                      padding: const EdgeInsets.all(12),
                      // longPressToDrag: true,
                      crossAxisCount: Settings.soundGridCount ?? 3,
                      crossAxisSpacing: 10,
                      mainAxisSpacing: 10,
                      onReorder: (int oldIndex, int newIndex) {
                        final tempOldIndex = box.get(box.keyAt(oldIndex));
                        final tempNewIndex = box.get(box.keyAt(newIndex));
                        box.put(box.keyAt(oldIndex), tempNewIndex);
                        box.put(box.keyAt(newIndex), tempOldIndex);
                      },
                      children: List.generate(keys.length, (index) {
                        final int? key = keys.toList()[index] as int?;
                        return Container(
                            key: Key(key.toString()),
                            child: SoundButton(
                              keyValue: key,
                            ));
                      }),
                    )
                  : NoSounds());
        },
      );
    });
  }
}

class NoSounds extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        height: MediaQuery.of(context).size.height - kToolbarHeight,
        alignment: Alignment.center,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Icon(Icons.add_rounded,
                color: Get.isDarkMode
                    ? Colors.white
                    : context.theme.colorScheme.secondary,
                size: 150),
            Container(
              padding: const EdgeInsets.all(20),
              child: const Text(
                "Click On Add Button To Add New Sounds To Your Soundborad",
                softWrap: true,
                style: TextStyle(fontSize: 25),
                textAlign: TextAlign.center,
              ),
            )
          ],
        ),
      ),
    );
  }
}

class FilesLoading extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        height: MediaQuery.of(context).size.height - kToolbarHeight,
        alignment: Alignment.center,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Center(child: CircularProgressIndicator()),
            Container(
              padding: const EdgeInsets.all(20),
              child: const Text(
                "Files are being added. Please wait !!!",
                softWrap: true,
                style: TextStyle(fontSize: 25),
                textAlign: TextAlign.center,
              ),
            )
          ],
        ),
      ),
    );
  }
}
