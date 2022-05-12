import 'package:get/get.dart';
import '../screens/addsound/online/onlinesearch_screen.dart';

import '../screens/addsound/record/record_screen.dart';
import '../screens/home/home_screen.dart';
import '../screens/markdown/markdown_screen.dart';
import '../screens/settings/settings_page.dart';

// ignore: avoid_classes_with_only_static_members
class AppPages {
  static const initial = Routes.home;

  static final routes = [
    GetPage(name: Routes.home, page: () => HomeScreen()),
    GetPage(name: Routes.soundOnlineSearch, page: () => SoundOnlineSearch()),
    GetPage(name: Routes.soundRecording, page: () => SoundRecording()),
    GetPage(name: Routes.settings, page: () => SettingsScreen()),
    GetPage(
        name: Routes.changeLog,
        page: () => const MarkdownPage("assets/changelog.md")),
    GetPage(
        name: Routes.privacyPolicy,
        page: () => const MarkdownPage("assets/privacypolicy.md")),
    // GetPage(name: Routes.AddEditSound, page: () => AddEditSound()),
  ];
}

abstract class Routes {
  static const home = '/home';
  static const soundRecording = '/soundrecording';
  static const soundOnlineSearch = '/soundonlinesearch';
  static const changeLog = '/changelog';
  static const privacyPolicy = '/privacypolicy';
  static const settings = '/settings';
  // static const AddEditSound = '/addeditsound';
}
