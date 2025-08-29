# Scale Picker

A highly customizable and dynamic scale picker widget for Flutter applications. Perfect for selecting measurements like height, weight, temperature, and any other numeric values with smooth scrolling and snapping behavior.

## Features

✨ **Highly Customizable**: Configure every aspect of appearance and behavior  
🎯 **Smooth Interactions**: Debounced scrolling with automatic snapping  
📏 **Multiple Orientations**: Both horizontal and vertical layouts  
🔄 **Unit Conversion**: Built-in support for unit switching  
🎨 **Shader Effects**: Gradient fade effects for better UX  
📱 **Responsive**: Adapts to different screen sizes  
⚡ **Performance**: Optimized for smooth 60fps scrolling  

## Installation

Add this to your package's `pubspec.yaml` file:

```yaml
dependencies:
  scale_picker: ^1.0.0
```

Then run:

```bash
flutter pub get
```

## Quick Start

### Basic Scale Widget

```dart
import 'package:scale_picker/scale_picker.dart';

ScaleWidget(
  config: const ScaleConfig(
    isVertical: true,
    backgroundColor: Colors.white,
    centerIndicatorColor: Colors.blue,
  ),
  measurementConfig: const MeasurementConfig(
    primaryUnit: 'cm',
    secondaryUnit: 'ft',
    minValue: 100,
    maxValue: 220,
    initialValue: 170,
  ),
  onChanged: (value) {
    print('Selected: $value');
  },
)
```

### Complete Measurement Picker (Height Example)

```dart
MeasurementPicker(
  primaryConfig: MeasurementConfig.heightCm,
  secondaryConfig: MeasurementConfig.heightFt,
  scaleConfig: const ScaleConfig(
    isVertical: true,
    centerIndicatorColor: Colors.blue,
  ),
  title: 'How tall are you?',
  subtitle: 'This is used to calculate your BMI',
  primaryUnitLabel: 'CM',
  secondaryUnitLabel: 'FT',
  onChanged: (MeasurementValue value) {
    print('Height: ${value.formattedValue} ${value.unit}');
  },
)
```

## Configuration Options

### ScaleConfig

Configure the appearance and behavior of your scale:

```dart
ScaleConfig(
  // Layout
  isVertical: true,
  width: 300.0,
  height: 200.0,
  
  // Styling
  backgroundColor: Colors.grey[100],
  borderRadius: BorderRadius.circular(20),
  padding: EdgeInsets.all(16),
  
  // Lines
  majorLineColor: Colors.black,
  minorLineColor: Colors.grey,
  centerIndicatorColor: Colors.blue,
  majorLineLength: 40.0,
  minorLineLength: 20.0,
  itemSpacing: 18.0,
  
  // Text
  majorTextStyle: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
  minorTextStyle: TextStyle(fontSize: 10),
  showMinorLabels: false,
  
  // Animation
  animationDuration: Duration(milliseconds: 200),
  animationCurve: Curves.easeInOut,
)
```

### MeasurementConfig

Define your measurement parameters:

```dart
MeasurementConfig(
  primaryUnit: 'kg',
  secondaryUnit: 'lbs',
  minValue: 30.0,
  maxValue: 200.0,
  initialValue: 70.0,
  majorInterval: 10,      // Major tick every 10 units
  minorInterval: 1,       // Minor tick every 1 unit
  decimalPlaces: 1,
  conversionFactor: 2.20462, // kg to lbs conversion
)
```

### Predefined Configurations

The package includes common configurations:

```dart
// Height configurations
MeasurementConfig.heightCm    // 60-250 cm
MeasurementConfig.heightFt    // 2-8.5 feet

// Weight configurations  
MeasurementConfig.weightKg    // 25-200 kg
MeasurementConfig.weightLbs   // 50-450 lbs
```

## Advanced Usage

### Custom Value Display

```dart
MeasurementPicker(
  // ... other properties
  valueDisplayBuilder: (MeasurementValue value) {
    return Column(
      children: [
        Text(
          value.formattedValue,
          style: TextStyle(fontSize: 48, fontWeight: FontWeight.bold),
        ),
        Text(
          value.unit,
          style: TextStyle(fontSize: 16, color: Colors.grey),
        ),
      ],
    );
  },
)
```

### Custom Toggle Button

```dart
MeasurementPicker(
  // ... other properties
  toggleButtonBuilder: (bool isPrimary, VoidCallback onToggle) {
    return Row(
      children: [
        ElevatedButton(
          onPressed: isPrimary ? null : onToggle,
          child: Text('KG'),
        ),
        SizedBox(width: 8),
        ElevatedButton(
          onPressed: isPrimary ? onToggle : null,
          child: Text('LBS'),
        ),
      ],
    );
  },
)
```

### Shader Effects

Add gradient fade effects:

```dart
ScaleWidget(
  // ... other properties
  shaderColors: [
    Colors.white.withOpacity(0.0),
    Colors.white,
    Colors.white,
    Colors.white.withOpacity(0.0),
  ],
  shaderStops: [0.0, 0.25, 0.75, 1.0],
)
```

### Custom Label Formatting

```dart
MeasurementConfig(
  // ... other properties
  labelFormatter: (int index, bool isMajor) {
    if (!isMajor) return '';
    final value = minValue + (index * minorInterval);
    return '${value.toInt()}°';
  },
)
```

## Real-world Examples

### Height Picker with Feet/Inches

```dart
MeasurementPicker(
  primaryConfig: MeasurementConfig.heightCm,
  secondaryConfig: MeasurementConfig(
    primaryUnit: 'ft',
    secondaryUnit: 'cm',
    minValue: 2.0,
    maxValue: 8.0,
    initialValue: 5.7,
    majorInterval: 1,
    minorInterval: 1,
    labelFormatter: (index, isMajor) {
      if (!isMajor) return '';
      final feet = (index ~/ 12) + 2;
      final inches = index % 12;
      return inches == 0 ? '$feet\'' : '$inches"';
    },
  ),
  scaleConfig: const ScaleConfig(isVertical: true),
  title: 'Height',
  primaryUnitLabel: 'CM',
  secondaryUnitLabel: 'FT',
  onChanged: (value) => print('Height: $value'),
)
```

### Temperature Picker

```dart
ScaleWidget(
  config: ScaleConfig(
    isVertical: true,
    centerIndicatorColor: Colors.red,
    majorLineColor: Colors.red,
    minorLineColor: Colors.orange,
  ),
  measurementConfig: const MeasurementConfig(
    primaryUnit: '°C',
    secondaryUnit: '°F',
    minValue: -10,
    maxValue: 50,
    initialValue: 20,
    majorInterval: 10,
    minorInterval: 5,
  ),
  onChanged: (temp) => print('Temperature: ${temp}°C'),
  shaderColors: [
    Colors.blue.withOpacity(0.3),
    Colors.white,
    Colors.red.withOpacity(0.3),
  ],
)
```

## Migration from Custom Implementation

If you're migrating from a custom implementation:

1. **Replace your scale widget** with `ScaleWidget`
2. **Use `MeasurementPicker`** for complete pickers with unit toggle
3. **Configure appearance** with `ScaleConfig`
4. **Define measurements** with `MeasurementConfig`
5. **Handle value changes** with the `onChanged` callback

### Before (Custom Implementation)
```dart
// Your custom HeightView widget
HeightView(
  onBoarding: onBoarding,
  callback: callback,
  indexValue: index,
  isFeet: isFeet,
)
```

### After (Scale Picker Package)
```dart
MeasurementPicker(
  primaryConfig: MeasurementConfig.heightCm,
  secondaryConfig: MeasurementConfig.heightFt,
  scaleConfig: const ScaleConfig(isVertical: true),
  onChanged: (value) {
    // Handle height change
  },
)
```

## API Reference

### ScaleWidget

The core scale picker widget.

| Property | Type | Description | Default |
|----------|------|-------------|---------|
| `config` | `ScaleConfig` | Configuration for appearance and behavior | Required |
| `measurementConfig` | `MeasurementConfig` | Configuration for measurement parameters | Required |
| `onChanged` | `ValueChanged<double>?` | Callback when value changes | `null` |
| `controller` | `ScrollController?` | Optional scroll controller | `null` |
| `showCenterIndicator` | `bool` | Whether to show center indicator | `true` |
| `centerIndicator` | `Widget?` | Custom center indicator widget | `null` |
| `shaderColors` | `List<Color>?` | Colors for gradient effect | `null` |
| `shaderStops` | `List<double>?` | Stops for gradient effect | `null` |

### MeasurementPicker

Complete picker with unit toggle functionality.

| Property | Type | Description | Default |
|----------|------|-------------|---------|
| `primaryConfig` | `MeasurementConfig` | Primary measurement configuration | Required |
| `secondaryConfig` | `MeasurementConfig` | Secondary measurement configuration | Required |
| `scaleConfig` | `ScaleConfig` | Scale appearance configuration | Required |
| `primaryUnitLabel` | `String` | Label for primary unit button | Required |
| `secondaryUnitLabel` | `String` | Label for secondary unit button | Required |
| `initialValue` | `double?` | Initial value in primary units | `null` |
| `initialPrimaryUnit` | `bool` | Start with primary unit | `true` |
| `title` | `String?` | Title text | `null` |
| `subtitle` | `String?` | Subtitle text | `null` |
| `onChanged` | `ValueChanged<MeasurementValue>?` | Callback when value changes | `null` |

### UnitConverter

Utility class for unit conversions.

| Method | Description |
|--------|-------------|
| `cmToFeet(double cm)` | Convert centimeters to feet |
| `feetToCm(double feet)` | Convert feet to centimeters |
| `kgToLbs(double kg)` | Convert kilograms to pounds |
| `lbsToKg(double lbs)` | Convert pounds to kilograms |
| `cmToFeetAndInches(double cm)` | Convert cm to feet and inches map |
| `formatValue(double value, int places)` | Format value with decimal places |

## Performance Tips

- Use `const` constructors when possible
- Avoid rebuilding the entire picker frequently
- Use `ValueListenableBuilder` for efficient updates
- Consider using a `ScrollController` for programmatic control

## Contributing

We welcome contributions! Please see our [Contributing Guide](CONTRIBUTING.md) for details.

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## Support

If you like this package, please give it a ⭐ on GitHub and consider supporting the developer.

For issues and feature requests, please use the [GitHub Issues](https://github.com/yourusername/scale_picker/issues) page.

## Changelog

See [CHANGELOG.md](CHANGELOG.md) for a detailed list of changes.