import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../../../../core/themes.dart';
import '../../../../folder.dart';
import '../../../../utils/database.dart';
import '../../../../widgets/dialog.dart';
import '../../cwidgets/list_tile.dart';
import '../../home_controller.dart';

class Folders extends GetView<HomeController> {
  final sColor = Get.context!.theme.colorScheme.secondary;
  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
        valueListenable: folders.listenable(),
        builder: (context, Box folders, widget) {
          final List<String> foldersList = [
            "main",
            ...folders.values.map((e) => e.toString()).toList()
          ];
          return ListView.builder(
            itemCount: folders.length + 1,
            itemBuilder: (context, index) {
              return Obx(
                () {
                  final int? keyValue = index != 0
                      ? folders.keys.toList()[index - 1] as int?
                      : null;
                  final bool isit =
                      controller.folderName.value == foldersList[index];
                  final Color color = Get.isDarkMode
                      ? Colors.white
                      : isit
                          ? Colors.white
                          : sColor;
                  return Focus(
                    focusNode: foldersList[index] != "main"
                        ? controller.focusNodes[2]
                        : null,
                    child: Container(
                        margin: const EdgeInsets.only(top: 15),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                        ),
                        child: ListTile(
                            shape: isit
                                ? RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10.0),
                                  )
                                : RoundedRectangleBorder(
                                    side: BorderSide(
                                        width: 2,
                                        color: Get.isDarkMode
                                            ? Colors.white
                                            : sColor),
                                    borderRadius: BorderRadius.circular(10.0),
                                  ),
                            tileColor: isit
                                ? Get.context!.theme.colorScheme.secondary
                                : null,
                            leading: Icon(Icons.folder, color: color),
                            title: Text(foldersList[index].capitalize!,
                                style: dts.copyWith(color: color)),
                            onTap: () {
                              controller.pageController.value.animateToPage(1,
                                  curve: Curves.ease, duration: .25.seconds);

                              controller.folderName.value = foldersList[index];
                              controller.isMainFolder.value =
                                  // ignore: avoid_bool_literals_in_conditional_expressions
                                  controller.folderName.value == "main"
                                      ? true
                                      : false;
                              controller.nowDB.value =
                                  controller.folderName.value == "main"
                                      ? sounds
                                      : foldersSounds;
                            },
                            onLongPress: () {
                              myDialog(foldersList[index] != "main"
                                  ? [
                                      const SizedBox(height: 15),
                                      Text(
                                        (foldersList[index]).capitalize!,
                                        textAlign: TextAlign.center,
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: dts.copyWith(fontSize: 30),
                                      ),
                                      listViewItem("Delete", Icons.delete, () {
                                        Folder.deleteFolder(keyValue);
                                      })
                                    ]
                                  : [
                                      Container(
                                          alignment: Alignment.center,
                                          height: 50,
                                          child: const Text(
                                              "Sorry This Folder Can't be Deleted",
                                              style: dts))
                                    ]);
                            })),
                  );
                },
              );
            },
          );
        });
  }
}


// TODO: Check for Clean Code
