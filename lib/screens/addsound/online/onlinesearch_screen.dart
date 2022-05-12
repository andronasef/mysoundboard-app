import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../../../core/values.dart';
import '../../../sound.dart';
import '../../../utils/online.dart';
import '../../../widgets/snackbar.dart';

class SoundOnlineSearch extends StatefulWidget {
  @override
  _SoundOnlineSearchState createState() => _SoundOnlineSearchState();
}

class _SoundOnlineSearchState extends State<SoundOnlineSearch> {
  RxBool firstSearch = true.obs;
  RxBool loading = false.obs;
  RxList onlineSounds = [].obs;
  TextEditingController textController = TextEditingController();

  Future<void> searchOnline(String searchQuery) async {
    if (await checkInternet()) {
      if (textController.text != "") {
        SystemChannels.textInput.invokeMethod('TextInput.hide');
        textController.text = "";
        firstSearch.value = false;
        loading.value = true;
        final soundsRequest =
            (await GetConnect().get("$api$searchQuery")).body["results"];
        onlineSounds.value = soundsRequest as List;
        loading.value = false;
      } else {
        emptyInput();
      }
    }
  }

  void back() {
    Get.back();
    Sound.mainPlayer.stop();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          floatingActionButton: FloatingActionButton(
            onPressed: () => textController.text.isNotEmpty
                ? searchOnline(textController.value.text)
                : back(),
            child: const Icon(
              Icons.check,
              color: Colors.white,
            ),
          ),
          body: Column(
            children: [
              Container(
                clipBehavior: Clip.antiAlias,
                height: 70,
                decoration: BoxDecoration(
                  color: context.theme.colorScheme.secondary,
                  borderRadius:
                      const BorderRadius.vertical(bottom: Radius.circular(20)),
                ),
                child: Row(
                  // direction: Axis.horizontal,
                  children: [
                    const SizedBox(width: 10),
                    WithTextFieldButton(Icons.arrow_back_rounded, () => back()),
                    const SizedBox(width: 10),
                    Expanded(
                      child: TextField(
                        onEditingComplete: () =>
                            searchOnline(textController.value.text),
                        controller: textController,
                        style: const TextStyle(color: Colors.white),
                        cursorColor: Colors.white,
                        decoration: InputDecoration(
                          focusedBorder: const UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.white)),
                          enabledBorder: const UnderlineInputBorder(
                              borderSide: BorderSide(style: BorderStyle.none)),
                          hintStyle:
                              TextStyle(color: Colors.white.withOpacity(.5)),
                          hintText: "Put Your Wanted Sound Here",
                          // prefixIcon:
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    WithTextFieldButton(Icons.search_rounded,
                        () => searchOnline(textController.value.text)),
                    const SizedBox(width: 10)
                  ],
                ),
              ),
              Obx(
                () => firstSearch.value
                    ? const Expanded(
                        child: Center(
                            child: Text("Please Enter Your Search Query")),
                      )
                    : loading.value
                        ? Expanded(
                            child: Center(
                                child: CircularProgressIndicator(
                            valueColor: AlwaysStoppedAnimation(Get.isDarkMode
                                ? Colors.white
                                : context.theme.colorScheme.secondary),
                          )))
                        : onlineSounds.isNotEmpty
                            // Online Sounds List Builder
                            ? Expanded(
                                child: ListView.builder(
                                  itemCount: onlineSounds.length,
                                  itemBuilder: (context, index) {
                                    final RxBool isDownloaded = false.obs;
                                    return Row(
                                      children: [
                                        Container(
                                          width: 200,
                                          margin:
                                              const EdgeInsets.only(left: 12.5),
                                          child: Text(
                                              onlineSounds[index]["name"]
                                                      as String? ??
                                                  "Unknown Name",
                                              // maxLines: 1,
                                              overflow: TextOverflow.ellipsis),
                                        ),
                                        const Spacer(),
                                        Row(
                                          children: [
                                            IconButton(
                                                icon: Icon(
                                                    Icons.play_arrow_rounded,
                                                    color: Get.isDarkMode
                                                        ? Colors.white
                                                        : Colors.black),
                                                onPressed: () {
                                                  Sound.mainPlayer.setUrl(
                                                      (onlineSounds[index]
                                                              ["sound"])
                                                          .toString()
                                                          .replaceAll(
                                                              "http", "https"));
                                                  Sound.mainPlayer.play();
                                                }),
                                            Obx(() => IconButton(
                                                icon: Icon(
                                                    !isDownloaded.value
                                                        ? Icons.download
                                                        : Icons.download_done,
                                                    color: Get.isDarkMode
                                                        ? Colors.white
                                                        : Colors.black),
                                                onPressed: !isDownloaded.value
                                                    ? () async {
                                                        if (!isDownloaded
                                                            .value) {
                                                          try {
                                                            Sound.downloadOnlineFile(
                                                                onlineSounds[
                                                                        index]
                                                                    as Map);
                                                          } finally {
                                                            Timer(
                                                                Duration(
                                                                    milliseconds:
                                                                        (Random().nextDouble() *
                                                                                1000)
                                                                            .toInt()),
                                                                () {
                                                              isDownloaded
                                                                  .value = true;
                                                            });
                                                          }
                                                        }
                                                      }
                                                    : null))
                                          ],
                                        ),
                                      ],
                                    );
                                  },
                                ),
                              )
                            // When Empty Sound List
                            : Expanded(
                                child: Container(
                                    padding: const EdgeInsets.all(10),
                                    alignment: Alignment.center,
                                    child: const Text(
                                      "Sorry! We Couldn't Find That One",
                                      style: TextStyle(fontSize: 20),
                                    )),
                              ),
              ),
            ],
          )),
    );
  }
}

class WithTextFieldButton extends StatelessWidget {
  final IconData icon;
  final Function action;

  const WithTextFieldButton(this.icon, this.action);
  @override
  Widget build(BuildContext context) {
    return Container(
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(999)),
      child: Material(
        color: context.theme.colorScheme.secondary,
        clipBehavior: Clip.antiAlias,
        child: IconButton(
          onPressed: () => action(),
          icon: Icon(icon, color: Colors.white),
        ),
      ),
    );
  }
}
