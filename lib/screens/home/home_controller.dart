import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:onboarding_overlay/onboarding_overlay.dart';
import 'package:package_info_plus/package_info_plus.dart';

import '../../core/routes.dart';
import '../../sound.dart';
import '../../utils/database.dart';
import 'widgets/mybottomsheet.dart';

class HomeController extends GetxController {
  Rx<PageController> pageController = PageController().obs;
  RxDouble pageNumber = 0.0.obs;
  RxBool userScroll = false.obs;
  RxBool isManyFilesLoading = false.obs;

  RxString folderName = "main".obs;
  Rx<Box> nowDB = sounds.obs;
  Rx<bool> isMainFolder = true.obs;

  RxBool showFAB = false.obs;

  GlobalKey<OnboardingState> onboardingKey = GlobalKey<OnboardingState>();
  List<FocusNode> focusNodes = List<FocusNode>.generate(
    6,
    (int i) => FocusNode(debugLabel: 'Onboarding Focus Node $i'),
    growable: false,
  );

  // Main Page
  Future<void> checkChangelog() async {
    final String buildNumber = (await PackageInfo.fromPlatform()).buildNumber;
    if (settings.get("version", defaultValue: buildNumber) != buildNumber) {
      Get.toNamed(Routes.changeLog);
      settings.put("version", buildNumber);
    }
  }

  /// Toggle between Sounds and Folders
  void toggler() {
    pageController.value.animateToPage(pageNumber.value == 1 ? 0 : 1,
        curve: Curves.ease, duration: .25.seconds);
  }

  void openAddSoundBottomSheet() {
    Sound.stopSounds();
    Get.bottomSheet(AddSoundBottomSheet());
  }

  void changePageNum(int page) {
    pageNumber.value = page.toDouble();
  }

  @override
  void onInit() {
    WidgetsBinding.instance!.addPostFrameCallback((Duration timeStamp) {
      if (!(settings.get("tutorial", defaultValue: false) as bool)) {
        onboardingKey.currentState!.show();
      }
    });
    super.onInit();
  }

  @override
  void onReady() {
    // ignore: unnecessary_statements
    checkChangelog();
    super.onReady();
  }
}
