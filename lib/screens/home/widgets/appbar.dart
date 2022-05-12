import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mysoundboard/core/routes.dart';
import 'package:mysoundboard/screens/home/home_controller.dart';
import '../../../core/values.dart';

class MyAppBar extends GetView<HomeController> {
  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      title: Text(
        kAppName.toUpperCase(),
        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
      ),
      actions: [
        Obx(() => Focus(
              focusNode: controller.focusNodes[4],
              child: IconButton(
                  tooltip:
                      controller.pageNumber.value != 0 ? "Folders" : "Sounds",
                  icon: controller.pageNumber.value != 0
                      ? const Icon(Icons.folder)
                      : const Icon(Icons.music_note),
                  onPressed: () => controller.toggler()),
            )),
        const SizedBox(width: 5),
        Focus(
            focusNode: controller.focusNodes[3],
            child: IconButton(
                tooltip: "Settings",
                icon: const Icon(Icons.settings),
                onPressed: () {
                  Get.toNamed(Routes.settings);
                })),
        const SizedBox(width: 5),
      ],
      shape: const ContinuousRectangleBorder(
        borderRadius: BorderRadius.only(
          bottomRight: Radius.circular(25),
          bottomLeft: Radius.circular(25),
        ),
      ),
    );
  }
}
