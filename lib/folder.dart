import 'package:get/get.dart';
import 'package:mysoundboard/screens/home/home_controller.dart';
import 'package:mysoundboard/sound.dart';
import 'package:mysoundboard/utils/database.dart';

// ignore: avoid_classes_with_only_static_members
class Folder {
  static void addFolder(String name) {
    folders.add(name);
  }

  static void deleteFolder(int? key) {
    final controller = Get.find<HomeController>();
    final name = folders.get(key) as String?;
    final List delete = [];

    try {
      foldersSounds.values.toList().asMap().forEach((int index, thesound) {
        // ignore: avoid_dynamic_calls
        if (thesound[2] == name) {
          delete.add(foldersSounds.keyAt(index) as int?);
        }
      });
      // ignore: avoid_function_literals_in_foreach_calls
      delete.forEach((soundKey) {
        Sound.removeSound(soundKey as int?);
      });
    } finally {
      folders.delete(key);

      if (controller.folderName.value == name) {
        controller.folderName.value = "main";
        controller.nowDB.value = sounds;
      }
    }
  }
}
