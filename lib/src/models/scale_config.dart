import 'package:flutter/material.dart';

/// Configuration class for scale appearance and behavior
class ScaleConfig {
  final double? width;
  final double? height;
  final Color backgroundColor;
  final BorderRadiusGeometry borderRadius;
  final EdgeInsetsGeometry padding;
  final bool isVertical;
  
  // Scale line properties
  final Color majorLineColor;
  final Color minorLineColor;
  final Color centerIndicatorColor;
  final double majorLineWidth;
  final double minorLineWidth;
  final double majorLineLength;
  final double minorLineLength;
  final double itemSpacing;
  
  // Text properties
  final TextStyle? majorTextStyle;
  final TextStyle? minorTextStyle;
  final bool showMinorLabels;
  
  // Behavior
  final Duration animationDuration;
  final Curve animationCurve;
  final double sensitivity;

  const ScaleConfig({
    this.width,
    this.height,
    this.backgroundColor = const Color(0xFFF5F5F5),
    this.borderRadius = const BorderRadius.all(Radius.circular(20)),
    this.padding = const EdgeInsets.all(16.0),
    this.isVertical = false,
    this.majorLineColor = Colors.black,
    this.minorLineColor = Colors.grey,
    this.centerIndicatorColor = Colors.blue,
    this.majorLineWidth = 2.0,
    this.minorLineWidth = 1.0,
    this.majorLineLength = 40.0,
    this.minorLineLength = 20.0,
    this.itemSpacing = 18.0,
    this.majorTextStyle,
    this.minorTextStyle,
    this.showMinorLabels = false,
    this.animationDuration = const Duration(milliseconds: 200),
    this.animationCurve = Curves.easeInOut,
    this.sensitivity = 1.0,
  });

  ScaleConfig copyWith({
    double? width,
    double? height,
    Color? backgroundColor,
    BorderRadiusGeometry? borderRadius,
    EdgeInsetsGeometry? padding,
    bool? isVertical,
    Color? majorLineColor,
    Color? minorLineColor,
    Color? centerIndicatorColor,
    double? majorLineWidth,
    double? minorLineWidth,
    double? majorLineLength,
    double? minorLineLength,
    double? itemSpacing,
    TextStyle? majorTextStyle,
    TextStyle? minorTextStyle,
    bool? showMinorLabels,
    Duration? animationDuration,
    Curve? animationCurve,
    double? sensitivity,
  }) {
    return ScaleConfig(
      width: width ?? this.width,
      height: height ?? this.height,
      backgroundColor: backgroundColor ?? this.backgroundColor,
      borderRadius: borderRadius ?? this.borderRadius,
      padding: padding ?? this.padding,
      isVertical: isVertical ?? this.isVertical,
      majorLineColor: majorLineColor ?? this.majorLineColor,
      minorLineColor: minorLineColor ?? this.minorLineColor,
      centerIndicatorColor: centerIndicatorColor ?? this.centerIndicatorColor,
      majorLineWidth: majorLineWidth ?? this.majorLineWidth,
      minorLineWidth: minorLineWidth ?? this.minorLineWidth,
      majorLineLength: majorLineLength ?? this.majorLineLength,
      minorLineLength: minorLineLength ?? this.minorLineLength,
      itemSpacing: itemSpacing ?? this.itemSpacing,
      majorTextStyle: majorTextStyle ?? this.majorTextStyle,
      minorTextStyle: minorTextStyle ?? this.minorTextStyle,
      showMinorLabels: showMinorLabels ?? this.showMinorLabels,
      animationDuration: animationDuration ?? this.animationDuration,
      animationCurve: animationCurve ?? this.animationCurve,
      sensitivity: sensitivity ?? this.sensitivity,
    );
  }
}

/// Configuration for measurement units and conversion
class MeasurementConfig {
  final String primaryUnit;
  final String secondaryUnit;
  final double minValue;
  final double maxValue;
  final double initialValue;
  final int majorInterval;
  final int minorInterval;
  final int decimalPlaces;
  final double conversionFactor;
  final String Function(double)? valueFormatter;
  final String Function(int, bool)? labelFormatter;

  const MeasurementConfig({
    required this.primaryUnit,
    required this.secondaryUnit,
    required this.minValue,
    required this.maxValue,
    required this.initialValue,
    this.majorInterval = 10,
    this.minorInterval = 1,
    this.decimalPlaces = 0,
    this.conversionFactor = 1.0,
    this.valueFormatter,
    this.labelFormatter,
  });

  // Predefined configurations
  static const MeasurementConfig heightCm = MeasurementConfig(
    primaryUnit: 'cm',
    secondaryUnit: 'ft',
    minValue: 60,
    maxValue: 250,
    initialValue: 170,
    majorInterval: 10,
    minorInterval: 1,
    conversionFactor: 30.48, // cm per foot
  );

  static const MeasurementConfig heightFt = MeasurementConfig(
    primaryUnit: 'ft',
    secondaryUnit: 'cm',
    minValue: 2,
    maxValue: 8,
    initialValue: 5.7,
    majorInterval: 1,
    minorInterval: 1,
    decimalPlaces: 1,
    conversionFactor: 0.0328084, // ft per cm
  );

  static const MeasurementConfig weightKg = MeasurementConfig(
    primaryUnit: 'kg',
    secondaryUnit: 'lbs',
    minValue: 25,
    maxValue: 200,
    initialValue: 70,
    majorInterval: 10,
    minorInterval: 1,
    conversionFactor: 0.453592, // kg per lb
  );

  static const MeasurementConfig weightLbs = MeasurementConfig(
    primaryUnit: 'lbs',
    secondaryUnit: 'kg',
    minValue: 50,
    maxValue: 450,
    initialValue: 154,
    majorInterval: 10,
    minorInterval: 1,
    conversionFactor: 2.20462, // lbs per kg
  );
}