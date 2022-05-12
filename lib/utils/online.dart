import 'dart:io';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:get/get.dart';
import 'package:mysoundboard/widgets/snackbar.dart';
import 'package:url_launcher/url_launcher.dart';

//Lanuch URL
Future<void> openUrl(String url) async {
  await canLaunch(url) ? await launch(url) : throw 'Could not launch $url';
}

//Lanuch URL WebView
Future<void> openUrlWebView(String url) async {
  await canLaunch(url)
      ? await launch(url, enableJavaScript: true, forceWebView: true)
      : throw 'Could not launch $url';
}

//Check Internet
Future<bool> checkInternet() async {
  if (!GetPlatform.isWeb) {
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        return true;
      }
    } on SocketException catch (_) {
      noInternetSnackbar();
      return false;
    }
  }
  return true;
}

/*---------------------Analytics---------------------*/
FirebaseAnalytics analytics = FirebaseAnalytics.instance;

FirebaseAnalyticsObserver analyticsObserver =
    FirebaseAnalyticsObserver(analytics: analytics);
