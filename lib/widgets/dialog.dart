import 'package:flutter/material.dart';
import 'package:get/get.dart';

void myDialog(List<Widget> childern) {
  showDialog(
    context: Get.context!,
    builder: (context) {
      return Dialog(
        clipBehavior: Clip.antiAlias,
        shape: ContinuousRectangleBorder(
          borderRadius: BorderRadius.circular(25),
        ),
        backgroundColor: context.theme.colorScheme.secondary,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: childern,
          ),
        ),
      );
    },
  );
}
