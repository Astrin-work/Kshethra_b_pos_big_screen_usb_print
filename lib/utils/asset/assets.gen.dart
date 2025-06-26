/// GENERATED CODE - DO NOT MODIFY BY HAND
/// *****************************************************
///  FlutterGen
/// *****************************************************

// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: directives_ordering,unnecessary_import,implicit_dynamic_list_literal,deprecated_member_use

import 'package:flutter/widgets.dart';

class $AssetsGifsGen {
  const $AssetsGifsGen();

  /// File path: assets/gifs/payment_success.json
  String get paymentSuccess => 'assets/gifs/payment_success.json';

  /// List of all assets
  List<String> get values => [paymentSuccess];
}

class $AssetsIconsGen {
  const $AssetsIconsGen();

  /// File path: assets/icons/astrins_kshethra_logo.png
  AssetGenImage get astrinsKshethraLogo =>
      const AssetGenImage('assets/images/kshethra logo.png');

  /// File path: assets/icons/astrins_logo.png
  AssetGenImage get astrinsLogo =>
      const AssetGenImage('assets/icons/astrins_logo.png');

  /// File path: assets/icons/back_arrow.png
  AssetGenImage get backArrow =>
      const AssetGenImage('assets/icons/back_arrow.png');

  /// File path: assets/icons/camera_icon.png
  AssetGenImage get cameraIcon =>
      const AssetGenImage('assets/icons/camera_icon.png');

  /// File path: assets/icons/donation.png
  AssetGenImage get donation =>
      const AssetGenImage('assets/icons/donation.png');

  /// File path: assets/icons/e_hundi.png
  AssetGenImage get eHundi => const AssetGenImage('assets/icons/e_hundi.png');

  AssetGenImage get view_and_edite => const AssetGenImage('assets/icons/view_and_edite.png');

  /// File path: assets/icons/image_icon.png
  AssetGenImage get imageIcon =>
      const AssetGenImage('assets/icons/image_icon.png');

  /// File path: assets/icons/kshethra_logo.png
  AssetGenImage get kshethraLogo =>
      const AssetGenImage('assets/images/Kshetra Eye Logo New.png');

  /// File path: assets/icons/plus_icon.png
  AssetGenImage get plusIcon =>
      const AssetGenImage('assets/icons/plus_icon.png');

  /// File path: assets/icons/pray.png
  AssetGenImage get pray => const AssetGenImage('assets/icons/pray.png');

  AssetGenImage get add_prathishtta =>
      const AssetGenImage('assets/icons/add_prathishtta.png');

  AssetGenImage get add_vazhipaddu =>
      const AssetGenImage('assets/icons/add_vazhippadu.png');

  /// File path: assets/icons/pre_booking.png
  AssetGenImage get preBooking =>
      const AssetGenImage('assets/icons/pre_booking.png');

  /// List of all assets
  List<AssetGenImage> get values => [
    astrinsKshethraLogo,
    astrinsLogo,
    backArrow,
    cameraIcon,
    donation,
    eHundi,
    imageIcon,
    kshethraLogo,
    plusIcon,
    pray,
    preBooking,
  ];
}

class $AssetsImagesGen {
  const $AssetsImagesGen();

  /// File path: assets/images/clean_bg.jpg
  AssetGenImage get cleanBg =>
      const AssetGenImage('assets/images/background_login.png');

  /// File path: assets/images/home_background.png
  AssetGenImage get homeBackground =>
      const AssetGenImage('assets/images/home_background.png');

  AssetGenImage get splashBackground =>
      const AssetGenImage('assets/images/image_bg10.png');
  /// File path: assets/images/lang_background.png
  AssetGenImage get langBackground =>
      const AssetGenImage('assets/images/lang_background.png');

  /// File path: assets/images/loard_shiva_background.jpg
  AssetGenImage get loardShivaBackground =>
      const AssetGenImage('assets/images/loard_shiva_background.jpg');

  /// File path: assets/images/lord_devi.jpg
  AssetGenImage get lordDevi =>
      const AssetGenImage('assets/images/lord_devi.jpg');

  /// File path: assets/images/lord_durga.jpg
  AssetGenImage get lordDurga =>
      const AssetGenImage('assets/images/lord_durga.jpg');

  /// File path: assets/images/lord_ganesh.jpg
  AssetGenImage get lordGanesh =>
      const AssetGenImage('assets/images/lord_ganesh.jpg');

  /// File path: assets/images/lord_hanuman.jpg
  AssetGenImage get lordHanuman =>
      const AssetGenImage('assets/images/lord_hanuman.jpg');

  /// File path: assets/images/lord_krishna.jpg
  AssetGenImage get lordKrishna =>
      const AssetGenImage('assets/images/lord_krishna.jpg');

  /// File path: assets/images/lord_saraswati.jpg
  AssetGenImage get lordSaraswati =>
      const AssetGenImage('assets/images/lord_saraswati.jpg');

  /// File path: assets/images/lord_siva.jpg
  AssetGenImage get lordSiva =>
      const AssetGenImage('assets/images/lord_siva.jpg');

  /// File path: assets/images/lord_vishnu.jpg
  AssetGenImage get lordVishnu =>
      const AssetGenImage('assets/images/lord_vishnu.jpg');

  /// List of all assets
  List<AssetGenImage> get values => [
    cleanBg,
    homeBackground,
    langBackground,
    loardShivaBackground,
    lordDevi,
    lordDurga,
    lordGanesh,
    lordHanuman,
    lordKrishna,
    lordSaraswati,
    lordSiva,
    lordVishnu,
  ];
}

class Assets {
  const Assets._();

  static const $AssetsGifsGen gifs = $AssetsGifsGen();
  static const $AssetsIconsGen icons = $AssetsIconsGen();
  static const $AssetsImagesGen images = $AssetsImagesGen();
}

class AssetGenImage {
  const AssetGenImage(this._assetName, {this.size, this.flavors = const {}});

  final String _assetName;

  final Size? size;
  final Set<String> flavors;

  Image image({
    Key? key,
    AssetBundle? bundle,
    ImageFrameBuilder? frameBuilder,
    ImageErrorWidgetBuilder? errorBuilder,
    String? semanticLabel,
    bool excludeFromSemantics = false,
    double? scale,
    double? width,
    double? height,
    Color? color,
    Animation<double>? opacity,
    BlendMode? colorBlendMode,
    BoxFit? fit,
    AlignmentGeometry alignment = Alignment.center,
    ImageRepeat repeat = ImageRepeat.noRepeat,
    Rect? centerSlice,
    bool matchTextDirection = false,
    bool gaplessPlayback = true,
    bool isAntiAlias = false,
    String? package,
    FilterQuality filterQuality = FilterQuality.medium,
    int? cacheWidth,
    int? cacheHeight,
  }) {
    return Image.asset(
      _assetName,
      key: key,
      bundle: bundle,
      frameBuilder: frameBuilder,
      errorBuilder: errorBuilder,
      semanticLabel: semanticLabel,
      excludeFromSemantics: excludeFromSemantics,
      scale: scale,
      width: width,
      height: height,
      color: color,
      opacity: opacity,
      colorBlendMode: colorBlendMode,
      fit: fit,
      alignment: alignment,
      repeat: repeat,
      centerSlice: centerSlice,
      matchTextDirection: matchTextDirection,
      gaplessPlayback: gaplessPlayback,
      isAntiAlias: isAntiAlias,
      package: package,
      filterQuality: filterQuality,
      cacheWidth: cacheWidth,
      cacheHeight: cacheHeight,
    );
  }

  ImageProvider provider({AssetBundle? bundle, String? package}) {
    return AssetImage(_assetName, bundle: bundle, package: package);
  }

  String get path => _assetName;

  String get keyName => _assetName;
}
