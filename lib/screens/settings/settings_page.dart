import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:fluttericon/elusive_icons.dart';
import 'package:fluttericon/font_awesome5_icons.dart';
import 'package:fluttericon/iconic_icons.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:mysoundboard/core/themes.dart';
import 'package:mysoundboard/screens/home/home_controller.dart';
import 'package:share_plus/share_plus.dart';

import '../../core/routes.dart';
import '../../core/values.dart';
import '../../utils/database.dart';
import '../../utils/online.dart';
import 'cwidgets/settings_tile.dart';
import 'cwidgets/settings_title.dart';

class SettingsScreen extends GetView<HomeController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Settings"),
        leading: const BackButton(),
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(vertical: 16),
        children: [
          const SettingsTitle("Manage"),
          /*App color*/ ListTile(
            enabled: !context.isDarkMode,
            onTap: () {
              Get.dialog(
                AlertDialog(
                  titlePadding: EdgeInsets.zero,
                  contentPadding: EdgeInsets.zero,
                  content: SingleChildScrollView(
                    child: MaterialPicker(
                      pickerColor: Get.theme.primaryColor,
                      onColorChanged: (color) {
                        Settings.appColorSet(color.value);
                        Get.changeTheme(Themes.light.copyWith(
                          colorScheme: const ColorScheme.light().copyWith(
                            primary: color,
                            secondary: color,
                            surface: color,
                          ),
                          primaryColor: color,
                          canvasColor: color,
                        ));
                      },
                    ),
                  ),
                ),
              );
            },
            title: const Text("App Color "),
            trailing: Container(
              transform: Matrix4.translationValues(-10, 0, 0),
              height: 25,
              width: 40,
              decoration: BoxDecoration(
                  color: context.isDarkMode
                      ? Colors.white.withOpacity(.2)
                      : context.theme.primaryColor,
                  borderRadius: BorderRadius.circular(25)),
            ),
            leading: const Icon(Icons.color_lens_rounded),
          ),
          /*Darkmode*/ SwitchListTile(
            secondary: const Icon(Iconic.moon_inv),
            value: context.isDarkMode,
            onChanged: (val) {
              // box.put("isDark", !(box.get("isDark") as bool));
              Settings.isDarkSet(value: val);
              context.isDarkMode
                  ? Get.changeThemeMode(ThemeMode.light)
                  : Get.changeThemeMode(ThemeMode.dark);
            },
            title: const Text('Dark Mode'),
          ),
          /*Spamy Sounds*/ ValueListenableBuilder(
            valueListenable: settings.listenable(),
            builder: (context, settings, child) {
              return SwitchListTile(
                secondary: const Icon(Icons.storm_rounded),
                // ignore: cast_nullable_to_non_nullable
                value: Settings.spamySounds as bool,
                onChanged: (val) {
                  Settings.spamySoundsSet(value: val);
                },
                title: const Text('Spammy Sounds'),
              );
            },
          ),
          /*Change Tiles Number*/ SettingsListTile(
              title: "Change Tiles Number",
              icon: Icons.grid_view_sharp,
              action: () {
                final RxInt theNum = (Settings.soundGridCount ?? 3).obs;
                Get.to(() => Scaffold(
                        body: Obx(
                      () => Center(
                        child: ListView(
                          shrinkWrap: true,
                          children: [
                            const SizedBox(height: 15),
                            Obx(() => Text(
                                  "Change The Sound Size \n${theNum.value.toString()}",
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(fontSize: 23),
                                )),
                            Slider.adaptive(
                              value: theNum.value.toDouble(),
                              onChanged: (val) {
                                theNum.value = val.toInt();
                                Settings.soundGridCountSet(val.toInt());
                              },
                              min: 1,
                              max: 10,
                            ),
                            SizedBox(
                              height: 250,
                              child: GridView.count(
                                padding: const EdgeInsets.all(12),
                                mainAxisSpacing: 10,
                                crossAxisSpacing: 10,
                                crossAxisCount: theNum.value,
                                children: List.generate(
                                    50,
                                    (index) => Container(
                                          clipBehavior: Clip.antiAlias,
                                          decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(10)),
                                          child: Material(
                                              color: context
                                                  .theme.colorScheme.secondary,
                                              child: InkWell(
                                                  onTap: () {},
                                                  child: Center(
                                                      child: Text(
                                                    index.toString(),
                                                    style: dts,
                                                  )))),
                                        )),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(12),
                              child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                      primary:
                                          context.theme.colorScheme.secondary),
                                  onPressed: () {
                                    controller.pageController.value
                                        .jumpToPage(0);
                                    Get.back();
                                  },
                                  child: const Text(
                                    "Done",
                                    style: TextStyle(color: Colors.white),
                                  )),
                            ),
                          ],
                        ),
                      ),
                    )));
              }),
          const SettingsTitle("Help us"),
          /*Rate 5 stars*/ SettingsListTile(
            title: "Rate 5 stars",
            icon: Icons.star,
            action: () => openUrl(AppUrls.rate),
          ),
          /*More Apps*/ SettingsListTile(
            title: "More Apps",
            icon: Icons.apps_rounded,
            action: () => openUrl(AppUrls.moreapps),
          ),
          /*Share the app*/ SettingsListTile(
            title: "Share the app",
            icon: Icons.share,
            action: () => Share.share(
                "Would you check this amazing soundboard app: ${AppUrls.googleplaylink}"),
          ),
          /*Become a supporter*/ SettingsListTile(
              title: "Become a supporter",
              icon: FontAwesome5.heart,
              action: () => openUrl(AppUrls.patreon)),
          /*Request a feuture*/ SettingsListTile(
            title: "Request a feuture",
            icon: Elusive.lightbulb,
            action: () => openUrlWebView(AppUrls.support),
          ),
          /*Report  a bug*/ SettingsListTile(
            title: "Report a bug",
            icon: FontAwesome5.bug,
            action: () => openUrlWebView(AppUrls.support),
          ),
          const SettingsTitle("Other"),
          /*Changelog*/ SettingsListTile(
            title: "Changelog",
            icon: Icons.published_with_changes_rounded,
            action: () => Get.toNamed(Routes.changeLog),
          ),
          /*Privacy Policy*/ SettingsListTile(
            title: "Privacy Policy",
            icon: Icons.privacy_tip,
            action: () => Get.toNamed(Routes.privacyPolicy),
          ),
          /*Contact us*/ SettingsListTile(
            title: "Contact us",
            icon: Icons.phone,
            action: () => openUrl(AppUrls.contact),
          ),
          /*About us*/ SettingsListTile(
            title: "About us",
            icon: Icons.info,
            action: () => openUrlWebView(AppUrls.about),
          ),
        ],
      ),
    );
  }
}
