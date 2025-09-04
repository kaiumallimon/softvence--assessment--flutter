import 'package:flutter/material.dart';

class ResponsiveHelper {
  final BuildContext context;
  late double _screenWidth;
  late double _screenHeight;

  ResponsiveHelper(this.context) {
    final size = MediaQuery.of(context).size;
    _screenWidth = size.width;
    _screenHeight = size.height;
  }

  double get screenWidth => _screenWidth;
  double get screenHeight => _screenHeight;

  // Scale width based on a base width (default 375)
  double scaleWidth(double width, {double baseWidth = 375}) {
    return width * (_screenWidth / baseWidth);
  }

  // Scale height based on a base height (default 812)
  double scaleHeight(double height, {double baseHeight = 812}) {
    return height * (_screenHeight / baseHeight);
  }

  // Scale font size
  double scaleFont(double fontSize, {double baseHeight = 812}) {
    return fontSize * (_screenHeight / baseHeight);
  }

  // Optional: scaled padding/margin
  double scalePadding(double padding, {double baseWidth = 375}) {
    return padding * (_screenWidth / baseWidth);
  }
}
