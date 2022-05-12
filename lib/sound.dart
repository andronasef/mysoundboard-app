import 'dart:async';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:get/get.dart';
import 'package:just_audio/just_audio.dart';
import 'package:path_provider/path_provider.dart';

// import 'screens/addsound/edit_add/add_edit.dart';
import 'screens/home/home_controller.dart';
import 'utils/database.dart';

// ignore: avoid_classes_with_only_static_members
class Sound {
  static AudioPlayer mainPlayer = AudioPlayer();
  static String? nowPath;

  static Future<void> playSound(String path) async {
    nowPath = path;
    if (File(path).existsSync()) {
      try {
        await mainPlayer.setFilePath(path);
        mainPlayer.play();
      } finally {}
    }
  }

// Database
  static Future<void> addSound(String path, String? name) async {
    final theController = Get.find<HomeController>();

    // Step:0 Create Sounds Folder For The First Time
    final String soundsDocumentsPath =
        "${(await getApplicationDocumentsDirectory()).path}/sounds";
    final String foldersoundsDocumentsPath =
        "${(await getApplicationDocumentsDirectory()).path}/foldersounds";
    if (!(await Directory(soundsDocumentsPath).exists())) {
      await Directory(soundsDocumentsPath).create(recursive: true);
      await Directory(foldersoundsDocumentsPath).create(recursive: true);
    }

    // Step 1: Generate Random Key Value For Database
    final int key = theController.nowDB.value.isEmpty
        ? 1
        : (theController.nowDB.value.keys.last as int) + 1;

    // Step 2: Rename The Sound File To Key
    final File newFile = await File(path).rename(
        "${Get.find<HomeController>().isMainFolder.value ? soundsDocumentsPath : foldersoundsDocumentsPath}/sound$key.${path.split(".").last.length > 3 ? "mp3" : path.split(".").last}");

    // Step 3: Add Sound To Database
    theController.isMainFolder.value
        ? sounds.put(key, [name, newFile.path])
        : foldersSounds
            .put(key, [name, newFile.path, theController.folderName.value]);

    // Step 4: Delete Temp Record File
    Sound.deleteTempRecord();
  }

  static Future<void> removeSound(int? key) async {
    final File deleteFile =
        // ignore: avoid_dynamic_calls
        File((Get.find<HomeController>().nowDB.value).get(key)[1] as String);
    try {
      deleteFile.deleteSync();
    } finally {}
    (Get.find<HomeController>().nowDB.value).delete(key);
  }

  static void editSound(int? id, String newName) {
    final newValue = Get.find<HomeController>().nowDB.value.get(id);
    // ignore: avoid_dynamic_calls
    newValue[0] = newName;
    Get.find<HomeController>().nowDB.value.put(id, newValue);
    // Pattern => (Key = ID & Value & folder = [Name Of Sound, Path Of File, Folder Name])
  }

// Add Sounds

  static Future<void> addSoundFilePicker() async {
    // ignore: avoid_positional_boolean_parameters
    void setIsManyFilesLoading(bool val) =>
        Get.find<HomeController>().isManyFilesLoading.value = val;

    setIsManyFilesLoading(true);

    final FilePickerResult? result = await FilePicker.platform
        .pickFiles(allowMultiple: true, type: FileType.audio);

    if (result != null) {
      try {
        for (final soundPath in result.paths) {
          await Sound.addSound(
              soundPath!, soundPath.split("/").last.split(".")[0]);
          // await print(soundPath);
        }
        setIsManyFilesLoading(false);
      } catch (e) {
        setIsManyFilesLoading(false);
      }
    } else {
      setIsManyFilesLoading(false);
    }
  }

  static Future<void> downloadOnlineFile(Map sound) async {
    final String thefuturefilepath = await Sound.getTempDownload(
        sound["name"] as String?, sound["sound"].toString().split(".")[3]);
    try {
      // Downloading The File
      final request = await HttpClient().getUrl(
          Uri.parse((sound["sound"]).toString().replaceAll("http", "https")));
      final response = await request.close();
      response.pipe(File(thefuturefilepath).openWrite());
    } finally {
      Future.delayed(1.seconds, () async {
        if (await File(thefuturefilepath).exists()) {
          addSound(thefuturefilepath, sound["name"] as String?);
        }
      });
    }
  }

  // Temp Opreations
  static void stopSounds() {
    mainPlayer.stop();
  }

  static Future<void> deleteTempRecord() async {
    if (File(await getTempRecord()).existsSync()) {
      File(await getTempRecord()).deleteSync();
    }
  }

  static Future<String> getTempRecord() async =>
      '${(await getTemporaryDirectory()).path}/record.m4a';

  static Future<String> getTempDownload(
          String? downloadedFileName, String fileExtension) async =>
      '${(await getTemporaryDirectory()).path}${'/$downloadedFileName.$fileExtension'}';
}
