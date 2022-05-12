import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mysoundboard/screens/home/home_controller.dart';
import 'package:onboarding_overlay/onboarding_overlay.dart';

import '../../../utils/database.dart';

class AppOnboarding extends StatelessWidget {
  final Widget child;
  final HomeController controller;

  const AppOnboarding({Key? key, required this.controller, required this.child})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Onboarding(
      key: controller.onboardingKey,
      steps: <OnboardingStep>[
        // Welcome
        OnboardingStep(
          focusNode: controller.focusNodes[0],
          delay: 3.seconds,
          titleText: 'Welcome to Your Soundboad App',
          bodyText:
              '\nThank you for downloaing the app\n\nI hope you have the best experience\n\nNow tap here to start the app tutorial',
          titleTextStyle: const TextStyle(fontSize: 30),
          bodyTextStyle: const TextStyle(fontSize: 16),
          textAlign: TextAlign.center,
          overlayColor: context.theme.primaryColor.withOpacity(0.9),
        ),
        // Folders
        OnboardingStep(
            focusNode: controller.focusNodes[2],
            titleText: '\nFolders',
            bodyText:
                '\nAll of your sound folders will be here as your collections\n',
            bodyTextStyle: const TextStyle(fontSize: 15),
            textAlign: TextAlign.center,
            labelBoxPadding: const EdgeInsets.all(10),
            labelBoxDecoration: BoxDecoration(
              shape: BoxShape.circle,
              borderRadius: const BorderRadius.all(Radius.circular(8.0)),
              color: context.theme.primaryColor,
            ),
            arrowPosition: ArrowPosition.bottomCenter,
            hasLabelBox: true,
            hasArrow: true,
            overlayColor: Colors.transparent),
        // Add Button
        OnboardingStep(
          focusNode: controller.focusNodes[1],
          delay: 2.seconds,
          titleText: 'Add Button',
          showPulseAnimation: true,
          bodyText: 'With this button you can add new Folders / Sounds',
          shape: const CircleBorder(),
          fullscreen: false,
          overlayColor: context.theme.primaryColor.withOpacity(0.9),
          overlayShape: const CircleBorder(),
        ),
        // Settings Icon
        OnboardingStep(
          focusNode: controller.focusNodes[3],
          overlayBehavior: HitTestBehavior.translucent,
          showPulseAnimation: true,
          titleText: 'Settings',
          bodyText: '\nWhere you can find all settings of the app',
          shape: const CircleBorder(),
          fullscreen: false,
          overlayColor: context.theme.primaryColor.withOpacity(0.9),
          overlayShape: const CircleBorder(),
        ),
        // Sounds / Folder Toggle Icon
        OnboardingStep(
          focusNode: controller.focusNodes[4],
          overlayBehavior: HitTestBehavior.translucent,
          showPulseAnimation: true,
          titleText: 'Toggler',
          bodyText:
              '\nSwitch between Folders and Sounds by clicking here or Scrolling horizontally',
          shape: const CircleBorder(),
          // margin: EdgeInsets.only(top: 50),
          fullscreen: false,
          // labelBoxPadding: EdgeInsets.all(-25),
          overlayColor: context.theme.primaryColor.withOpacity(0.9),
          overlayShape: const CircleBorder(),
        ),
        // Sounds page
        OnboardingStep(
          focusNode: controller.focusNodes[5],
          overlayBehavior: HitTestBehavior.translucent,
          titleText: 'Sounds Page\n',
          bodyText:
              'Here where you can find sounds of folder that you selected previously \n\nHere You can add new sound by The Add Button\n\nAlso you can change the sound position by long press and drag and drop it in your preferred place\n\nFinally, you can see sound options menu by click on menu button on the sound that you want',
          bodyTextStyle: const TextStyle(fontSize: 15),
          textAlign: TextAlign.center,
          overlayColor: context.theme.primaryColor.withOpacity(0.9),
        ),
      ],
      onChanged: (index) {
        if (index == 4) {
          controller.pageController.value
              .animateToPage(1, duration: 250.milliseconds, curve: Curves.ease);
          controller.pageNumber.value = 1;
        }
      },
      onEnd: (index) {
        settings.put("tutorial", true);
      },
      child: child,
    );
  }
}
