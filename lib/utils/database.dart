import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:path_provider/path_provider.dart';

Future<void> openBoxes() async {
  GetPlatform.isWeb
      // ignore: unnecessary_statements
      ? await Hive.initFlutter()
      : await Hive.initFlutter(
          "${(await getApplicationDocumentsDirectory()).path}/database");

  await Hive.openBox('settings');
  await Hive.openBox('sounds');
  await Hive.openBox('folders');
  await Hive.openBox('foldersounds');
}

Box settings = Hive.box("settings");
Box sounds = Hive.box("sounds");
Box folders = Hive.box("folders");
Box foldersSounds = Hive.box("foldersounds");

// ignore: avoid_classes_with_only_static_members
class Settings {
  static bool? get isDark =>
      settings.get("isDark", defaultValue: false) as bool?;

  static void isDarkSet({bool? value}) => settings.put("isDark", value);

  static bool? get isRated =>
      settings.get("isRated", defaultValue: false) as bool?;

  static void isRatedSet({bool? value}) => settings.put("isRated", value);

  static int? get appColor =>
      settings.get("appColor", defaultValue: 0xFF0E75F5) as int?;

  static void appColorSet(int color) => settings.put("appColor", color);

  static int? get soundGridCount =>
      settings.get("soundGridCount", defaultValue: 3) as int?;

  static void soundGridCountSet(int count) =>
      settings.put("soundGridCount", count);

  static bool? get spamySounds =>
      settings.get("spamySounds", defaultValue: false) as bool?;

  static void spamySoundsSet({bool? value}) =>
      settings.put("spamySounds", value);

  static int? get minLaunchTimesToReview =>
      settings.get("minLaunchTimesToReview", defaultValue: 10) as int?;

  static void minLaunchTimesToReviewSet(int? value) =>
      settings.put("minLaunchTimesToReview", value);
}
