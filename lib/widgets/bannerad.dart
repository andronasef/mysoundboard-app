import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class AppBannerAd extends StatefulWidget {
  const AppBannerAd({Key? key}) : super(key: key);

  @override
  _AppBannerAdState createState() => _AppBannerAdState();
}

class _AppBannerAdState extends State<AppBannerAd> {
  bool isBannerAdReady = false;
  late BannerAd bannerAd;

  void loadBannerAd() {
    bannerAd = BannerAd(
      adUnitId: kDebugMode
          ? "ca-app-pub-3940256099942544/6300978111"
          : "ca-app-pub-8830378458631357/1841520583",
      // ignore: prefer_const_constructors
      request: AdRequest(),
      size: AdSize.banner,
      listener: BannerAdListener(
        onAdLoaded: (_) {
          setState(() {
            isBannerAdReady = true;
          });
          if (kDebugMode) print("Banner Ad Loaded");
        },
        onAdFailedToLoad: (ad, err) {
          if (kDebugMode) print('Failed to load a banner ad: ${err.message}');
          isBannerAdReady = false;
          ad.dispose();
        },
      ),
    );
    bannerAd.load();
    if (isBannerAdReady = true) {
      setState(() {
        isBannerAdReady = true;
      });
    }
  }

  @override
  void initState() {
    loadBannerAd();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return isBannerAdReady
        ? SizedBox(
            width: bannerAd.size.width.toDouble(),
            height: bannerAd.size.height.toDouble(),
            child: AdWidget(ad: bannerAd),
          )
        : const SizedBox();
  }
}
