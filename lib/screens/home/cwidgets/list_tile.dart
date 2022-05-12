import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/themes.dart';
// import '../../../utils/online.dart';
// import 'package:mysoundboard/utils/online.dart';

Widget listViewItem(String title, IconData icon, Function() action) {
  return ListTile(
      title: Text(
        title,
        style: dts,
      ),
      trailing: Icon(icon, color: Colors.white),
      onTap: () async {
        Get.back();
        action();
      });
}
