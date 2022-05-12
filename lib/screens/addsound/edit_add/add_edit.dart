import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mysoundboard/screens/home/home_controller.dart';
import 'package:mysoundboard/widgets/snackbar.dart';
import '../../../core/themes.dart';
import '../../../folder.dart';
import '../../../sound.dart';
// import 'package:hive/hive.dart';

class AddEdit extends StatefulWidget {
  final bool isfolder;
  final String? filePath;
  final int? id;
  const AddEdit({this.filePath, this.id, this.isfolder = false});

  @override
  _AddEditState createState() => _AddEditState();
}

class _AddEditState extends State<AddEdit> {
  TextEditingController inputController = TextEditingController();
  void done() {
    if (inputController.text.isNotEmpty) {
      widget.isfolder
          ? Folder.addFolder(inputController.text)
          : widget.id != null
              ? Sound.editSound(widget.id, inputController.text)
              : Sound.addSound(widget.filePath!, inputController.text);
      Get.back();
    } else {
      showCustomSnackbar("Error", "Name can't be empty!", Icons.error);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (inputController.value.text == "") {
      inputController = TextEditingController(
          text: (widget.isfolder
              ? ""
              : widget.id == null
                  ? widget.filePath!.split("/").last.split(".")[0]
                  : (Get.find<HomeController>().nowDB.value.get(widget.id)
                      as List)[0]) as String?);
    }

    return SafeArea(
      child: Scaffold(
        body: Column(
          children: [
            // Header
            Container(
              height: Get.context!.height * .15,
              decoration: BoxDecoration(
                  color: context.theme.colorScheme.secondary,
                  borderRadius: const BorderRadius.only(
                      bottomLeft: Radius.circular(20),
                      bottomRight: Radius.circular(20))),
              child: Center(
                  child: Text(
                "${widget.isfolder ? "Add/Edit Folder" : "${widget.id == null ? "Add" : "Edit"}Your Sound"} ",
                style: dts.copyWith(fontSize: 30),
              )),
            ),
            // Textbox
            Expanded(
              child: Center(
                  child: AddEditTextFiled(
                inputController: inputController,
                filePath: widget.filePath,
                id: widget.id,
                isfolder: widget.isfolder,
                doneAdd: done,
              )),
            ),
            // Buttons (Cancel - Play - Done)
            Container(
              height: Get.context!.height * .15,
              clipBehavior: Clip.antiAlias,
              decoration: BoxDecoration(
                  color: context.theme.colorScheme.secondary,
                  borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(20),
                      topRight: Radius.circular(20))),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Expanded(
                    child: Material(
                      color: context.theme.colorScheme.secondary,
                      child: InkWell(
                        onTap: () {
                          Get.back();
                          inputController.text = "";
                        },
                        child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text("Cancel", style: dts.copyWith(fontSize: 25)),
                              const SizedBox(
                                width: 15,
                              ),
                              const Icon(Icons.close_rounded,
                                  size: 50, color: Colors.white)
                            ]),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Material(
                      color: context.theme.colorScheme.secondary,
                      child: InkWell(
                        onTap: () => done(),
                        child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text("Done", style: dts.copyWith(fontSize: 25)),
                              const SizedBox(width: 15),
                              const Icon(Icons.check,
                                  size: 50, color: Colors.white)
                            ]),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class AddEditTextFiled extends StatelessWidget {
  final Function? doneAdd;
  final bool isfolder;
  final String? filePath;
  final int? id;
  final TextEditingController? inputController;
  const AddEditTextFiled(
      {this.filePath,
      this.id,
      this.inputController,
      this.isfolder = false,
      this.doneAdd});

  @override
  Widget build(BuildContext context) {
    return TextField(
        controller: inputController,
        textAlign: TextAlign.center,
        cursorColor:
            Get.isDarkMode ? Colors.white : context.theme.colorScheme.secondary,
        minLines: 1,
        maxLines: 3,
        onEditingComplete: () => doneAdd,
        // onChanged: (change) => inputController.text = change,
        style: TextStyle(
          decoration: TextDecoration.none,
          fontSize: 30,
          color: Get.isDarkMode
              ? Colors.white
              : context.theme.colorScheme.secondary,
          fontWeight: FontWeight.bold,
        ),
        decoration: InputDecoration(
          focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(
                  width: 3,
                  color: Get.isDarkMode
                      ? Colors.white
                      : context.theme.colorScheme.secondary)),
          enabledBorder: UnderlineInputBorder(
            borderSide: BorderSide(
                // width: 2,
                color: Get.isDarkMode
                    ? Colors.white
                    : context.theme.colorScheme.secondary),
          ),
          border: UnderlineInputBorder(
              borderSide: BorderSide(
            color: Get.isDarkMode
                ? Colors.white
                : context.theme.colorScheme.secondary,
          )),
          hintText: isfolder ? "Folder Name" : "Sound Name",
        ));
  }
}
