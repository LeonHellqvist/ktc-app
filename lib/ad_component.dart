import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class AdComponent extends StatefulWidget {
  const AdComponent({super.key, required this.adUnit, required this.showAds});
  final String adUnit;
  final bool showAds;

  @override
  State<AdComponent> createState() => _AdComponentState();
}

class _AdComponentState extends State<AdComponent> {
  BannerAd? _anchoredAdaptiveAd;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _loadAd(widget.showAds);
  }

  Future<void> _loadAd(bool showAds) async {
    // Get an AnchoredAdaptiveBannerAdSize before loading the ad.
    final AnchoredAdaptiveBannerAdSize? size =
        await AdSize.getCurrentOrientationAnchoredAdaptiveBannerAdSize(
            MediaQuery.of(context).size.width.truncate());

    if (size == null) {
      log('Unable to get height of anchored banner.');
      return;
    }

    _anchoredAdaptiveAd = showAds
        ? BannerAd(
            adUnitId: widget.adUnit,
            size: size,
            request: const AdRequest(),
            listener: BannerAdListener(
              onAdLoaded: (Ad ad) {
                log('$ad loaded: ${ad.responseInfo}');
                setState(() {
                  // When the ad is loaded, get the ad size and use it to set
                  // the height of the ad container.
                  _anchoredAdaptiveAd = ad as BannerAd;
                });
              },
              onAdFailedToLoad: (Ad ad, LoadAdError error) {
                log('Anchored adaptive banner failedToLoad: $error');
                ad.dispose();
              },
            ),
          )
        : null;
    return _anchoredAdaptiveAd!.load();
  }

  @override
  void dispose() {
    _anchoredAdaptiveAd?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.showAds == false) {
      return const SizedBox(
        height: 0,
        width: 0,
      );
    }
    if (_anchoredAdaptiveAd == null) {
      return SizedBox(
        // TODO: Make this the correct height of adaptive ad
        height: 60,
        width: MediaQuery.of(context).size.width,
      );
    } else {
      return SizedBox(
          height: _anchoredAdaptiveAd!.size.height.toDouble(),
          width: _anchoredAdaptiveAd!.size.width.toDouble(),
          child: AdWidget(ad: _anchoredAdaptiveAd!));
    }
  }
}
