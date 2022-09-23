import 'package:flutter/material.dart';

final $styles = AppStyle();

@immutable
class AppStyle {
  /// The current theme colors for the app
  final AppColors colors = AppColors();

  /// Rounded edge corner radius
  late final corners = _Corners();

  /// Padding and margin values
  late final insets = _Insets();

  /// Text styles
  late final text = _Text();
}

class AppColors {
  final Color primaryBackground = Colors.grey.shade900;
  final Color primaryAccent = Colors.blue;
  final Color white = Colors.white;
  final Color link = Colors.blue;

  ThemeData themeData({required bool isDark}) {
    /// Create a TextTheme and ColorScheme, that we can use to generate ThemeData
    final textTheme = (isDark ? ThemeData.dark() : ThemeData.light()).textTheme;

    final textColor = textTheme.bodyText1!.color!;

    ColorScheme colorScheme = ColorScheme(
        // Decide how you want to apply your own custom them, to the MaterialApp
        brightness: isDark ? Brightness.dark : Brightness.light,
        primary: primaryAccent,
        primaryContainer: primaryAccent,
        secondary: primaryAccent,
        secondaryContainer: primaryAccent,
        background: primaryBackground,
        surface: primaryBackground,
        onBackground: textColor,
        onSurface: textColor,
        onError: white,
        onPrimary: white,
        onSecondary: white,
        error: Colors.red.shade400);

    /// Now that we have ColorScheme and TextTheme, we can create the ThemeData
    var theme = ThemeData.from(
      useMaterial3: true,
      textTheme: textTheme,
      colorScheme: colorScheme,
    );

    /// Return the themeData which MaterialApp can now use
    return theme;
  }
}

@immutable
class _Text {
  TextStyle _getBaseText() {
    return const TextStyle();
  }

  TextStyle get baseFont => _getBaseText();

  late final TextStyle shitTitle =
      copy(baseFont, sizePx: 64, weight: FontWeight.bold);

  late final TextStyle h1 = copy(baseFont, sizePx: 64);

  late final TextStyle h2 = copy(baseFont, sizePx: 32);

  late final TextStyle h3 = copy(
    baseFont,
    sizePx: 24,
    weight: FontWeight.w600,
  );

  late final TextStyle h4 = copy(
    baseFont,
    sizePx: 14,
    spacingPc: 5,
    weight: FontWeight.w600,
  );

  late final TextStyle title1 = copy(
    baseFont,
    sizePx: 16,
    spacingPc: 5,
  );

  late final TextStyle title2 = copy(
    baseFont,
    sizePx: 14,
  );

  late final TextStyle body = copy(
    baseFont,
    sizePx: 16,
  );

  late final TextStyle bodyBold = copy(
    baseFont,
    sizePx: 16,
    weight: FontWeight.w600,
  );

  late final TextStyle bodySmall = copy(
    baseFont,
    sizePx: 14,
  );

  late final TextStyle bodySmallBold = copy(
    baseFont,
    sizePx: 14,
    weight: FontWeight.w600,
  );

  late final TextStyle button = copy(
    baseFont,
    sizePx: 12,
    weight: FontWeight.w600,
  );

  TextStyle copy(
    TextStyle style, {
    required double sizePx,
    double? heightPx,
    double? spacingPc,
    FontWeight? weight,
  }) {
    return style.copyWith(
        fontSize: sizePx,
        height: heightPx != null ? (heightPx / sizePx) : style.height,
        letterSpacing:
            spacingPc != null ? sizePx * spacingPc * 0.01 : style.letterSpacing,
        fontWeight: weight);
  }
}

@immutable
class _Corners {
  late final double sm = 4;
  late final double md = 8;
  late final double lg = 32;
}

@immutable
class _Insets {
  late final double xxs = 4;
  late final double xs = 8;
  late final double sm = 16;
  late final double md = 24;
  late final double lg = 32;
  late final double xl = 48;
  late final double xxl = 56;
  late final double offset = 80;
}
