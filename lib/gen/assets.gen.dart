/// GENERATED CODE - DO NOT MODIFY BY HAND
/// *****************************************************
///  FlutterGen
/// *****************************************************

// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: directives_ordering,unnecessary_import,implicit_dynamic_list_literal,deprecated_member_use

import 'package:flutter/widgets.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter/services.dart';

class $AssetsIconsGen {
  const $AssetsIconsGen();

  /// File path: assets/icons/ic_color_border.svg
  SvgGenImage get icColorBorder =>
      const SvgGenImage('assets/icons/ic_color_border.svg');

  /// File path: assets/icons/ic_color_wheel.svg
  SvgGenImage get icColorWheel =>
      const SvgGenImage('assets/icons/ic_color_wheel.svg');

  /// File path: assets/icons/ic_eraser.svg
  SvgGenImage get icEraser => const SvgGenImage('assets/icons/ic_eraser.svg');

  /// File path: assets/icons/ic_paint.svg
  SvgGenImage get icPaint => const SvgGenImage('assets/icons/ic_paint.svg');

  /// File path: assets/icons/ic_pen.svg
  SvgGenImage get icPen => const SvgGenImage('assets/icons/ic_pen.svg');

  /// File path: assets/icons/ic_pen1_preview.svg
  SvgGenImage get icPen1Preview =>
      const SvgGenImage('assets/icons/ic_pen1_preview.svg');

  /// File path: assets/icons/ic_pen2_preview.svg
  SvgGenImage get icPen2Preview =>
      const SvgGenImage('assets/icons/ic_pen2_preview.svg');

  /// File path: assets/icons/ic_pen3_preview.svg
  SvgGenImage get icPen3Preview =>
      const SvgGenImage('assets/icons/ic_pen3_preview.svg');

  /// File path: assets/icons/ic_pen6_preview.svg
  SvgGenImage get icPen6Preview =>
      const SvgGenImage('assets/icons/ic_pen6_preview.svg');

  /// File path: assets/icons/ic_smiley.png
  AssetGenImage get icSmileyPng =>
      const AssetGenImage('assets/icons/ic_smiley.png');

  /// File path: assets/icons/ic_smiley.svg
  SvgGenImage get icSmileySvg =>
      const SvgGenImage('assets/icons/ic_smiley.svg');

  /// File path: assets/icons/ic_star.png
  AssetGenImage get icStarPng =>
      const AssetGenImage('assets/icons/ic_star.png');

  /// File path: assets/icons/ic_star.svg
  SvgGenImage get icStarSvg => const SvgGenImage('assets/icons/ic_star.svg');

  /// List of all assets
  List<dynamic> get values => [
        icColorBorder,
        icColorWheel,
        icEraser,
        icPaint,
        icPen,
        icPen1Preview,
        icPen2Preview,
        icPen3Preview,
        icPen6Preview,
        icSmileyPng,
        icSmileySvg,
        icStarPng,
        icStarSvg
      ];
}

class Assets {
  Assets._();

  static const $AssetsIconsGen icons = $AssetsIconsGen();
}

class AssetGenImage {
  const AssetGenImage(this._assetName);

  final String _assetName;

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
    bool gaplessPlayback = false,
    bool isAntiAlias = false,
    String? package,
    FilterQuality filterQuality = FilterQuality.low,
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

  ImageProvider provider({
    AssetBundle? bundle,
    String? package,
  }) {
    return AssetImage(
      _assetName,
      bundle: bundle,
      package: package,
    );
  }

  String get path => _assetName;

  String get keyName => _assetName;
}

class SvgGenImage {
  const SvgGenImage(this._assetName);

  final String _assetName;

  SvgPicture svg({
    Key? key,
    bool matchTextDirection = false,
    AssetBundle? bundle,
    String? package,
    double? width,
    double? height,
    BoxFit fit = BoxFit.contain,
    AlignmentGeometry alignment = Alignment.center,
    bool allowDrawingOutsideViewBox = false,
    WidgetBuilder? placeholderBuilder,
    String? semanticsLabel,
    bool excludeFromSemantics = false,
    SvgTheme theme = const SvgTheme(),
    ColorFilter? colorFilter,
    Clip clipBehavior = Clip.hardEdge,
    @deprecated Color? color,
    @deprecated BlendMode colorBlendMode = BlendMode.srcIn,
    @deprecated bool cacheColorFilter = false,
  }) {
    return SvgPicture.asset(
      _assetName,
      key: key,
      matchTextDirection: matchTextDirection,
      bundle: bundle,
      package: package,
      width: width,
      height: height,
      fit: fit,
      alignment: alignment,
      allowDrawingOutsideViewBox: allowDrawingOutsideViewBox,
      placeholderBuilder: placeholderBuilder,
      semanticsLabel: semanticsLabel,
      excludeFromSemantics: excludeFromSemantics,
      theme: theme,
      colorFilter: colorFilter,
      color: color,
      colorBlendMode: colorBlendMode,
      clipBehavior: clipBehavior,
      cacheColorFilter: cacheColorFilter,
    );
  }

  String get path => _assetName;

  String get keyName => _assetName;
}
