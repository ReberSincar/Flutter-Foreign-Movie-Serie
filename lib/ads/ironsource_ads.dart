import 'package:flutter/material.dart';
import 'package:foreign_movie_watch/ui/pages/iqplayer.dart';
import 'package:get/get.dart';
import 'package:ironsource/ironsource.dart';
import 'package:ironsource/models.dart';

class IronSourceAdsController extends GetxController
    with IronSourceListener, WidgetsBindingObserver {
  final String appKey = "e43632a9";
  final rewardeVideoAvailable = false.obs,
      showBanner = true.obs,
      interstitialReady = false.obs;
  String videoLink;
  String subtitleLink;
  String title;
  String desc;

  @override
  void onInit() async {
    WidgetsBinding.instance.addObserver(this);
    String userId = await IronSource.getAdvertiserId();
    await IronSource.validateIntegration();
    await IronSource.setUserId(userId);
    await IronSource.initialize(appKey: appKey, listener: this);
    loadRewarded();
    super.onInit();
  }

  openPlayer() {
    Get.to(IQPlayerPage(
      videoLink: videoLink,
      subtitleLink: subtitleLink,
      title: title,
      description: desc,
    ));
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    switch (state) {
      case AppLifecycleState.resumed:
        IronSource.activityResumed();
        break;
      case AppLifecycleState.inactive:
        break;
      case AppLifecycleState.paused:
        IronSource.activityPaused();
        break;
      case AppLifecycleState.detached:
        break;
    }
  }

  loadRewarded() async {
    rewardeVideoAvailable.value = await IronSource.isRewardedVideoAvailable();
  }

  void loadInterstitial() async {
    await IronSource.loadInterstitial();
  }

  Future<void> showInterstitial() async {
    if (interstitialReady.value) {
      IronSource.showInterstitial();
    } else {
      print(
        "Interstial is not ready. use 'Ironsource.loadInterstial' before showing it",
      );
    }
  }

  Future<void> showRewardedVideo() async {
    if (rewardeVideoAvailable.value) {
      IronSource.showRewardedVideol();
    } else {
      openPlayer();
    }
  }

  IronSourceBannerAd getBannerAd() {
    return IronSourceBannerAd(keepAlive: true, listener: BannerAdListener());
  }

  void showHideBanner() {
    showBanner.value = !showBanner.value;
  }

  @override
  void onInterstitialAdClicked() {
    print("onInterstitialAdClicked");
  }

  @override
  void onInterstitialAdClosed() {
    print("onInterstitialAdClosed");
    openPlayer();
  }

  @override
  void onInterstitialAdLoadFailed(IronSourceError error) {
    print("onInterstitialAdLoadFailed : ${error.toString()}");
    interstitialReady.value = false;
    loadInterstitial();
  }

  @override
  void onInterstitialAdOpened() {
    print("onInterstitialAdOpened");
    loadInterstitial();
    interstitialReady.value = false;
  }

  @override
  void onInterstitialAdReady() {
    print("onInterstitialAdReady");
    interstitialReady.value = true;
  }

  @override
  void onInterstitialAdShowFailed(IronSourceError error) {
    print("onInterstitialAdShowFailed : ${error.toString()}");
    interstitialReady.value = false;
    loadInterstitial();
  }

  @override
  void onInterstitialAdShowSucceeded() {
    print("nInterstitialAdShowSucceeded");
  }

  @override
  void onRewardedVideoAdClicked(Placement placement) {
    print("onRewardedVideoAdClicked");
  }

  @override
  void onRewardedVideoAdClosed() {
    print("onRewardedVideoAdClosed");
    openPlayer();
    loadRewarded();
  }

  @override
  void onRewardedVideoAdEnded() {
    print("onRewardedVideoAdEnded");
  }

  @override
  void onRewardedVideoAdOpened() {
    print("onRewardedVideoAdOpened");
  }

  @override
  void onRewardedVideoAdRewarded(Placement placement) {
    print("onRewardedVideoAdRewarded: ${placement.placementName}");
  }

  @override
  void onRewardedVideoAdShowFailed(IronSourceError error) {
    print("onRewardedVideoAdShowFailed : ${error.toString()}");
    loadRewarded();
  }

  @override
  void onRewardedVideoAdStarted() {
    print("onRewardedVideoAdStarted");
  }

  @override
  void onRewardedVideoAvailabilityChanged(bool available) {
    print("onRewardedVideoAvailabilityChanged : $available");
    rewardeVideoAvailable.value = available;
  }

  @override
  void onGetOfferwallCreditsFailed(IronSourceError error) {}

  @override
  void onOfferwallAdCredited(OfferwallCredit reward) {}

  @override
  void onOfferwallAvailable(bool available) {}

  @override
  void onOfferwallClosed() {}

  @override
  void onOfferwallOpened() {}

  @override
  void onOfferwallShowFailed(IronSourceError error) {}
}

class BannerAdListener extends IronSourceBannerListener {
  @override
  void onBannerAdClicked() {
    print("onBannerAdClicked");
  }

  @override
  void onBannerAdLeftApplication() {
    print("onBannerAdLeftApplication");
  }

  @override
  void onBannerAdLoadFailed(Map<String, dynamic> error) {
    print("onBannerAdLoadFailed");
  }

  @override
  void onBannerAdLoaded() {
    print("onBannerAdLoaded");
  }

  @override
  void onBannerAdScreenDismissed() {
    print("onBannerAdScreenDismisse");
  }

  @override
  void onBannerAdScreenPresented() {
    print("onBannerAdScreenPresented");
  }
}
