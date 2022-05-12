import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:in_app_review/in_app_review.dart';
import 'package:rate_my_app/rate_my_app.dart';

import '../../../core/themes.dart';
import '../../../utils/database.dart';

class RateApp extends StatefulWidget {
  @override
  State<RateApp> createState() => _RateAppState();
}

class _RateAppState extends State<RateApp> {
  final RxBool isDismissed = false.obs;
  final RxBool shouldShowReview = false.obs;
  final InAppReview inAppReview = InAppReview.instance;

  RateMyApp rateMyApp = RateMyApp(
    minDays: 5,
    minLaunches: 10,
    remindDays: 3,
    remindLaunches: 5,
  );

  Future<void> reviewLater() async {
    Settings.minLaunchTimesToReviewSet(Settings.minLaunchTimesToReview! + 10);
    isDismissed.value = true;
  }

  Future<void> reviewNow() async {
    if (await inAppReview.isAvailable()) {
      inAppReview.requestReview();
      settings.put(Settings.isRated, true);
      isDismissed.value = true;
    }
  }

  Future<void> canShowAppReview() async {
    rateMyApp.init().then((_) async {
      if (rateMyApp.shouldOpenDialog &&
          !Settings.isRated! &&
          await inAppReview.isAvailable()) {
        shouldShowReview.value = true;
      }
    });
  }

  @override
  void initState() {
    canShowAppReview();
    super.initState();
  }

  // Future<bool> shouldReview() async {
  @override
  Widget build(BuildContext context) {
    return Obx(() => shouldShowReview.value
        ? AnimatedSwitcher(
            duration: .25.seconds,
            transitionBuilder: (child, animation) {
              return FadeTransition(
                  opacity: animation,
                  child: SizeTransition(sizeFactor: animation, child: child));
            },
            child: isDismissed.value
                ? Container()
                : GestureDetector(
                    child: Container(
                      width: double.infinity,
                      height: Get.context!.height * .3,
                      margin: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                          color: context.theme.colorScheme.secondary,
                          borderRadius: BorderRadius.circular(10)),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              "Support our hard work by 5 star review!",
                              style: dts.copyWith(fontSize: 25),
                              textAlign: TextAlign.center,
                            ),
                          ),
                          const SizedBox(height: 15),
                          Row(
                            children: [
                              const SizedBox(width: 10),
                              Expanded(
                                child: OutlinedButton(
                                  onPressed: () async => reviewLater(),
                                  style: OutlinedButton.styleFrom(
                                      padding: const EdgeInsets.all(10),
                                      side: const BorderSide(
                                          color: Colors.white, width: 2)),
                                  child: Text(
                                    "Later",
                                    style: dts.copyWith(fontSize: 15),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: TextButton(
                                    onPressed: () async => reviewNow(),
                                    style: TextButton.styleFrom(
                                      backgroundColor: Colors.white,
                                      padding: const EdgeInsets.all(10),
                                    ),
                                    child: Text(
                                      "Sure, I Will",
                                      style: dts.copyWith(
                                          fontSize: 15,
                                          color: context
                                              .theme.colorScheme.secondary),
                                    )),
                              ),
                              const SizedBox(width: 10),
                            ],
                          )
                        ],
                      ),
                    ),
                  ),
          )
        : Container());
  }
}
