// ignore_for_file: prefer_const_constructors

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:get/get.dart';
import 'package:mysoundboard/screens/home/widgets/rate_app.dart';
import 'package:upgrader/upgrader.dart';

import 'home_controller.dart';
import 'widgets/appbar.dart';
import 'widgets/folders/folders.dart';
import 'widgets/onborading.dart';
import 'widgets/sound_grid/sound_grid.dart';

class HomeScreen extends GetView<HomeController> {
  @override
  Widget build(BuildContext context) {
    return AppOnboarding(
      controller: controller,
      child: SafeArea(
        child: Scaffold(
            floatingActionButton: Focus(
              focusNode: controller.focusNodes[1],
              child: Obx(() => AnimatedOpacity(
                    duration: 200.milliseconds,
                    opacity: !controller.showFAB.value ? 1.0 : 0.0,
                    child: AnimatedScale(
                      duration: 250.milliseconds,
                      scale: !controller.showFAB.value ? 1.0 : 0.0,
                      child: FloatingActionButton(
                          tooltip:
                              "Add ${controller.pageNumber.value == 0.0 ? "Folder" : "Sound"}",
                          backgroundColor: context.theme.colorScheme.secondary,
                          onPressed: () => !controller.isManyFilesLoading.value
                              ? controller.openAddSoundBottomSheet()
                              : null,
                          child: const Icon(Icons.add, color: Colors.white)),
                    ),
                  )),
            ),
            body: UpgradeAlert(
              debugAlwaysUpgrade: false,
              showReleaseNotes: false,
              child: NestedScrollView(
                floatHeaderSlivers: true,
                body: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      RateApp(),
                      Expanded(
                        child: Obx(
                          () => NotificationListener<UserScrollNotification>(
                              onNotification: (notification) {
                                if (notification.direction ==
                                    ScrollDirection.forward) {
                                  controller.showFAB.value = false;
                                } else if (notification.direction ==
                                    ScrollDirection.reverse) {
                                  controller.showFAB.value = true;
                                }
                                return true;
                              },
                              child: PageView(
                                onPageChanged: (page) =>
                                    controller.changePageNum(page),
                                controller: controller.pageController.value,
                                children: [
                                  Folders(),
                                  Focus(child: Scrollbar(child: SoundGrid())),
                                ],
                              )),
                        ),
                      )
                    ]),
                headerSliverBuilder: (context, innerBoxIsScrolled) =>
                    [MyAppBar()],
              ),
            )),
      ),
    );
  }
}
