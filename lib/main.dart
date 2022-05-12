import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
// import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:mysoundboard/binding.dart';

import 'controller.dart';
import 'core/routes.dart';
import 'core/themes.dart';
import 'utils/database.dart';
import 'utils/online.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterError;
  // MobileAds.instance.initialize();

  await openBoxes();
  runApp(MyApp());
}

class MyApp extends GetView<AppController> {
  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: settings.listenable(),
      builder: (context, dynamic value, child) => GetMaterialApp(
        initialBinding: InitialBinding(),
        themeMode: Settings.isDark! ? ThemeMode.dark : ThemeMode.light,
        navigatorObservers: [analyticsObserver],
        defaultTransition: Transition.cupertino,
        theme: Themes.light,
        darkTheme: Themes.dark,
        initialRoute: AppPages.initial,
        getPages: AppPages.routes,
        debugShowCheckedModeBanner: false,
        supportedLocales: const [Locale('en', '')],
        locale: const Locale.fromSubtags(languageCode: "en"),
      ),
    );
  }
}


// TODO: rename folders
// TODO: move file from folder to folder
// TODO: add help page
