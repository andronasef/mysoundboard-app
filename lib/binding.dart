import 'package:get/get.dart';
// import 'controller.dart';
import 'screens/home/home_controller.dart';

class InitialBinding implements Bindings {
  @override
  void dependencies() {
    // Get.put<AppController>(AppController(), permanent: true);
    Get.put<HomeController>(HomeController(), permanent: true);
  }
}
