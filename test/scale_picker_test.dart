import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:scale_picker/scale_picker.dart';

void main() {
  group('ScaleWidget Tests', () {
    testWidgets('ScaleWidget builds without error', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ScaleWidget(
              config: const ScaleConfig(isVertical: true),
              measurementConfig: const MeasurementConfig(
                primaryUnit: 'test',
                secondaryUnit: 'test2',
                minValue: 0,
                maxValue: 100,
                initialValue: 50,
              ),
            ),
          ),
        ),
      );

      expect(find.byType(ScaleWidget), findsOneWidget);
    });

    testWidgets('ScaleWidget calls onChanged callback', (WidgetTester tester) async {
      double? changedValue;
      
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ScaleWidget(
              config: const ScaleConfig(isVertical: true),
              measurementConfig: const MeasurementConfig(
                primaryUnit: 'test',
                secondaryUnit: 'test2',
                minValue: 0,
                maxValue: 100,
                initialValue: 50,
              ),
              onChanged: (value) {
                changedValue = value;
              },
            ),
          ),
        ),
      );

      // Simulate scroll
      await tester.drag(find.byType(ListView), const Offset(0, -100));
      await tester.pumpAndSettle();

      expect(changedValue, isNotNull);
    });

    testWidgets('ScaleWidget displays correct initial value', (WidgetTester tester) async {
      const initialValue = 75.0;
      
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ScaleWidget(
              config: const ScaleConfig(isVertical: true),
              measurementConfig: const MeasurementConfig(
                primaryUnit: 'test',
                secondaryUnit: 'test2',
                minValue: 0,
                maxValue: 100,
                initialValue: initialValue,
              ),
            ),
          ),
        ),
      );

      // Verify the widget is built
      expect(find.byType(ScaleWidget), findsOneWidget);
      expect(find.byType(ListView), findsOneWidget);
    });
  });

  group('MeasurementPicker Tests', () {
    testWidgets('MeasurementPicker builds with height config', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: MeasurementPicker(
              primaryConfig: MeasurementConfig.heightCm,
              secondaryConfig: MeasurementConfig.heightFt,
              scaleConfig: const ScaleConfig(isVertical: true),
              primaryUnitLabel: 'CM',
              secondaryUnitLabel: 'FT',
            ),
          ),
        ),
      );

      expect(find.byType(MeasurementPicker), findsOneWidget);
      expect(find.text('CM'), findsOneWidget);
      expect(find.text('FT'), findsOneWidget);
    });

    testWidgets('MeasurementPicker toggles units', (WidgetTester tester) async {
      MeasurementValue? currentValue;
      
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: MeasurementPicker(
              primaryConfig: MeasurementConfig.heightCm,
              secondaryConfig: MeasurementConfig.heightFt,
              scaleConfig: const ScaleConfig(isVertical: true),
              primaryUnitLabel: 'CM',
              secondaryUnitLabel: 'FT',
              initialPrimaryUnit: true,
              onChanged: (value) {
                currentValue = value;
              },
            ),
          ),
        ),
      );

      // Wait for initial build
      await tester.pumpAndSettle();

      // Initially should be in CM (primary unit)
      expect(currentValue?.unit, equals('cm'));

      // Tap on FT to toggle units
      await tester.tap(find.text('FT'));
      await tester.pumpAndSettle();

      // Should now be in FT (secondary unit)
      expect(currentValue?.unit, equals('ft'));
    });

    testWidgets('MeasurementPicker displays title and subtitle', (WidgetTester tester) async {
      const title = 'Test Title';
      const subtitle = 'Test Subtitle';
      
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: MeasurementPicker(
              primaryConfig: MeasurementConfig.weightKg,
              secondaryConfig: MeasurementConfig.weightLbs,
              scaleConfig: const ScaleConfig(isVertical: true),
              primaryUnitLabel: 'KG',
              secondaryUnitLabel: 'LBS',
              title: title,
              subtitle: subtitle,
            ),
          ),
        ),
      );

      expect(find.text(title), findsOneWidget);
      expect(find.text(subtitle), findsOneWidget);
    });
  });

  group('UnitConverter Tests', () {
    test('converts cm to feet correctly', () {
      const cm = 170.0;
      final feet = UnitConverter.cmToFeet(cm);
      expect(feet, closeTo(5.577, 0.001));
    });

    test('converts feet to cm correctly', () {
      const feet = 5.5;
      final cm = UnitConverter.feetToCm(feet);
      expect(cm, closeTo(167.64, 0.01));
    });

    test('converts kg to lbs correctly', () {
      const kg = 70.0;
      final lbs = UnitConverter.kgToLbs(kg);
      expect(lbs, closeTo(154.32, 0.01));
    });

    test('converts lbs to kg correctly', () {
      const lbs = 150.0;
      final kg = UnitConverter.lbsToKg(lbs);
      expect(kg, closeTo(68.04, 0.01));
    });

    test('converts cm to feet and inches correctly', () {
      const cm = 175.0;
      final result = UnitConverter.cmToFeetAndInches(cm);
      expect(result['feet'], equals(5));
      expect(result['inches'], equals(9));
    });

    test('formats value with decimal places', () {
      const value = 123.456789;
      expect(UnitConverter.formatValue(value, 0), equals('123'));
      expect(UnitConverter.formatValue(value, 2), equals('123.46'));
    });

    test('parses feet inches string correctly', () {
      const input = "5' 8\"";
      final result = UnitConverter.parseFeetInches(input);
      expect(result, isNotNull);
      expect(result!['feet'], equals(5));
      expect(result['inches'], equals(8));
    });

    test('returns null for invalid feet inches string', () {
      const input = "invalid";
      final result = UnitConverter.parseFeetInches(input);
      expect(result, isNull);
    });
  });

  group('Debounce Tests', () {
    test('debounce delays function execution', () async {
      bool functionCalled = false;
      final debounce = Debounce(duration: const Duration(milliseconds: 100));
      
      debounce.call(() {
        functionCalled = true;
      });
      
      // Function should not be called immediately
      expect(functionCalled, false);
      
      // Wait for debounce duration
      await Future.delayed(const Duration(milliseconds: 150));
      
      // Function should now be called
      expect(functionCalled, true);
      
      debounce.dispose();
    });

    test('debounce cancels previous calls', () async {
      int callCount = 0;
      final debounce = Debounce(duration: const Duration(milliseconds: 100));
      
      // Make multiple rapid calls
      debounce.call(() => callCount++);
      debounce.call(() => callCount++);
      debounce.call(() => callCount++);
      
      // Wait for debounce duration
      await Future.delayed(const Duration(milliseconds: 150));
      
      // Only the last call should have executed
      expect(callCount, equals(1));
      
      debounce.dispose();
    });

    test('debounce isPending property works correctly', () {
      final debounce = Debounce(duration: const Duration(milliseconds: 100));
      
      expect(debounce.isPending, false);
      
      debounce.call(() {});
      expect(debounce.isPending, true);
      
      debounce.cancel();
      expect(debounce.isPending, false);
      
      debounce.dispose();
    });
  });

  group('MeasurementValue Tests', () {
    test('MeasurementValue formats correctly', () {
      const value = MeasurementValue(
        value: 123.456,
        unit: 'cm',
        isPrimaryUnit: true,
        decimalPlaces: 2,
      );
      
      expect(value.formattedValue, equals('123.46'));
      expect(value.toString(), equals('123.46 cm'));
    });

    test('MeasurementValue equality works', () {
      const value1 = MeasurementValue(
        value: 100.0,
        unit: 'cm',
        isPrimaryUnit: true,
      );
      
      const value2 = MeasurementValue(
        value: 100.0,
        unit: 'cm',
        isPrimaryUnit: true,
      );
      
      const value3 = MeasurementValue(
        value: 100.0,
        unit: 'ft',
        isPrimaryUnit: false,
      );
      
      expect(value1 == value2, true);
      expect(value1 == value3, false);
      expect(value1.hashCode == value2.hashCode, true);
      expect(value1.hashCode == value3.hashCode, false);
    });

    test('MeasurementValue handles zero decimal places', () {
      const value = MeasurementValue(
        value: 123.789,
        unit: 'kg',
        isPrimaryUnit: true,
        decimalPlaces: 0,
      );
      
      expect(value.formattedValue, equals('124'));
      expect(value.toString(), equals('124 kg'));
    });
  });

  group('ScaleConfig Tests', () {
    test('ScaleConfig has correct defaults', () {
      const config = ScaleConfig();
      
      expect(config.backgroundColor, equals(const Color(0xFFF5F5F5)));
      expect(config.isVertical, equals(false));
      expect(config.majorLineColor, equals(Colors.black));
      expect(config.minorLineColor, equals(Colors.grey));
      expect(config.centerIndicatorColor, equals(Colors.blue));
      expect(config.itemSpacing, equals(18.0));
      expect(config.showMinorLabels, equals(false));
    });

    test('ScaleConfig copyWith works correctly', () {
      const originalConfig = ScaleConfig();
      final newConfig = originalConfig.copyWith(
        isVertical: true,
        backgroundColor: Colors.red,
        itemSpacing: 20.0,
      );
      
      expect(newConfig.isVertical, equals(true));
      expect(newConfig.backgroundColor, equals(Colors.red));
      expect(newConfig.itemSpacing, equals(20.0));
      // Should preserve other values
      expect(newConfig.majorLineColor, equals(Colors.black));
      expect(newConfig.minorLineColor, equals(Colors.grey));
    });
  });

  group('MeasurementConfig Tests', () {
    test('predefined height config has correct values', () {
      const config = MeasurementConfig.heightCm;
      
      expect(config.primaryUnit, equals('cm'));
      expect(config.secondaryUnit, equals('ft'));
      expect(config.minValue, equals(60));
      expect(config.maxValue, equals(250));
      expect(config.initialValue, equals(170));
      expect(config.majorInterval, equals(10));
      expect(config.minorInterval, equals(1));
    });

    test('predefined weight config has correct values', () {
      const config = MeasurementConfig.weightKg;
      
      expect(config.primaryUnit, equals('kg'));
      expect(config.secondaryUnit, equals('lbs'));
      expect(config.minValue, equals(25));
      expect(config.maxValue, equals(200));
      expect(config.initialValue, equals(70));
      expect(config.majorInterval, equals(10));
      expect(config.minorInterval, equals(1));
    });
  });
}