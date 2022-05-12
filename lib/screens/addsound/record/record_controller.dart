import 'dart:async';

import 'package:get/get.dart';

class SoundRecordingController extends GetxController {
  late Timer recordTimer;
  final RxInt recordSeconds = 0.obs;
  final RxBool hasRecord = false.obs;
}
