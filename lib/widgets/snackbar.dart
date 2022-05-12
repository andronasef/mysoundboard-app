import 'package:flutter/material.dart';
import 'package:get/get.dart';

void showCustomSnackbar(String title, String message, IconData icon) {
  if (!Get.isSnackbarOpen) {
    Get.snackbar(title, message,
        backgroundColor: Get.context!.theme.colorScheme.secondary,
        icon: Icon(
          icon,
          color: Colors.white,
        ),
        boxShadows: const [
          BoxShadow(
              blurRadius: 5,
              color: Colors.black26,
              offset: Offset(3, 5),
              spreadRadius: 1)
        ],
        colorText: Colors.white,
        margin: const EdgeInsets.only(bottom: 20),
        shouldIconPulse: false,
        maxWidth: Get.context!.width * .9,
        snackPosition: SnackPosition.BOTTOM);
  }
}

void noRecordSnackBar() => showCustomSnackbar("Error (There Is No Record)",
    "Please Record Your Sound", Icons.do_not_touch_rounded);

void noInternetSnackbar() => showCustomSnackbar("Error", "There Is No Internet",
    Icons.signal_cellular_connected_no_internet_4_bar_rounded);

void emptyInput() => showCustomSnackbar(
    "Error", "Please Enter Your Search Query", Icons.border_color);

void emptyInputAddEdit() => showCustomSnackbar(
    "Error", "Please Enter Your Search Query", Icons.border_color);
