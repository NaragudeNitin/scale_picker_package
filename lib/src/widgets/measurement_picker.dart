import 'package:flutter/material.dart';
import '../models/scale_config.dart';
import '../utils/unit_converter.dart';
import 'scale_widget.dart';

/// A complete measurement picker with unit toggle functionality
class MeasurementPicker extends StatefulWidget {
  /// Primary measurement configuration (e.g., kg, cm)
  final MeasurementConfig primaryConfig;
  
  /// Secondary measurement configuration (e.g., lbs, ft)
  final MeasurementConfig secondaryConfig;
  
  /// Scale appearance configuration
  final ScaleConfig scaleConfig;
  
  /// Initial value in primary units
  final double? initialValue;
  
  /// Whether to start with primary unit (true) or secondary (false)
  final bool initialPrimaryUnit;
  
  /// Title text
  final String? title;
  final TextStyle? titleStyle;
  
  /// Subtitle text
  final String? subtitle;
  final TextStyle? subtitleStyle;
  
  /// Toggle button labels
  final String primaryUnitLabel;
  final String secondaryUnitLabel;
  
  /// Callback when value changes
  final ValueChanged<MeasurementValue>? onChanged;
  
  /// Custom toggle button builder
  final Widget Function(bool isPrimary, VoidCallback onToggle)? toggleButtonBuilder;
  
  /// Custom value display builder
  final Widget Function(MeasurementValue value)? valueDisplayBuilder;
  
  /// Custom shader colors for fade effect
  final List<Color>? shaderColors;
  final List<double>? shaderStops;

  const MeasurementPicker({
    super.key,
    required this.primaryConfig,
    required this.secondaryConfig,
    required this.scaleConfig,
    this.initialValue,
    this.initialPrimaryUnit = true,
    this.title,
    this.titleStyle,
    this.subtitle,
    this.subtitleStyle,
    required this.primaryUnitLabel,
    required this.secondaryUnitLabel,
    this.onChanged,
    this.toggleButtonBuilder,
    this.valueDisplayBuilder,
    this.shaderColors,
    this.shaderStops,
  });

  @override
  State<MeasurementPicker> createState() => _MeasurementPickerState();
}

class _MeasurementPickerState extends State<MeasurementPicker> {
  late ValueNotifier<bool> _isPrimaryUnitNotifier;
  late ValueNotifier<double> _currentValueNotifier;
  late ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _isPrimaryUnitNotifier = ValueNotifier(widget.initialPrimaryUnit);
    _scrollController = ScrollController();
    
    // Set initial value
    final initialVal = widget.initialValue ?? 
        (widget.initialPrimaryUnit 
            ? widget.primaryConfig.initialValue 
            : widget.secondaryConfig.initialValue);
    _currentValueNotifier = ValueNotifier(initialVal);
    
    // Listen for unit changes
    _isPrimaryUnitNotifier.addListener(_onUnitChanged);
  }

  @override
  void dispose() {
    _isPrimaryUnitNotifier.dispose();
    _currentValueNotifier.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _onUnitChanged() {
    // Convert current value to the new unit
    final currentValue = _currentValueNotifier.value;
    double convertedValue;
    
    if (_isPrimaryUnitNotifier.value) {
      // Converting from secondary to primary
      convertedValue = UnitConverter.convert(
        currentValue, 
        1.0 / widget.secondaryConfig.conversionFactor,
      );
    } else {
      // Converting from primary to secondary
      convertedValue = UnitConverter.convert(
        currentValue, 
        widget.primaryConfig.conversionFactor,
      );
    }
    
    _currentValueNotifier.value = convertedValue;
    _notifyChange();
  }

  void _onScaleChanged(double value) {
    _currentValueNotifier.value = value;
    _notifyChange();
  }

  void _notifyChange() {
    if (widget.onChanged != null) {
      final measurementValue = MeasurementValue(
        value: _currentValueNotifier.value,
        unit: _isPrimaryUnitNotifier.value 
            ? widget.primaryConfig.primaryUnit
            : widget.secondaryConfig.primaryUnit,
        isPrimaryUnit: _isPrimaryUnitNotifier.value,
      );
      widget.onChanged!(measurementValue);
    }
  }

  MeasurementConfig get _currentConfig => 
      _isPrimaryUnitNotifier.value ? widget.primaryConfig : widget.secondaryConfig;

  Widget _buildDefaultToggleButton(bool isPrimary, VoidCallback onToggle) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(25),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          GestureDetector(
            onTap: isPrimary ? null : onToggle,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
              decoration: BoxDecoration(
                color: isPrimary ? Colors.blue : Colors.transparent,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                widget.primaryUnitLabel,
                style: TextStyle(
                  color: isPrimary ? Colors.white : Colors.black,
                  fontWeight: isPrimary ? FontWeight.bold : FontWeight.normal,
                ),
              ),
            ),
          ),
          GestureDetector(
            onTap: isPrimary ? onToggle : null,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
              decoration: BoxDecoration(
                color: !isPrimary ? Colors.blue : Colors.transparent,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                widget.secondaryUnitLabel,
                style: TextStyle(
                  color: !isPrimary ? Colors.white : Colors.black,
                  fontWeight: !isPrimary ? FontWeight.bold : FontWeight.normal,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDefaultValueDisplay(MeasurementValue value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          value.formattedValue,
          style: const TextStyle(
            fontSize: 32,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(width: 8),
        Text(
          value.unit,
          style: TextStyle(
            fontSize: 16,
            color: Colors.grey[600],
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<bool>(
      valueListenable: _isPrimaryUnitNotifier,
      builder: (context, isPrimaryUnit, _) {
        return Column(
          children: [
            if (widget.title != null) ...[
              Text(
                widget.title!,
                style: widget.titleStyle ?? 
                    const TextStyle(fontSize: 24, fontWeight: FontWeight.w600),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
            ],
            
            if (widget.subtitle != null) ...[
              Text(
                widget.subtitle!,
                style: widget.subtitleStyle ?? 
                    TextStyle(fontSize: 12, color: Colors.grey[600]),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
            ],
            
            // Unit toggle button
            if (widget.toggleButtonBuilder != null)
              widget.toggleButtonBuilder!(isPrimaryUnit, () {
                _isPrimaryUnitNotifier.value = !_isPrimaryUnitNotifier.value;
              })
            else
              _buildDefaultToggleButton(isPrimaryUnit, () {
                _isPrimaryUnitNotifier.value = !_isPrimaryUnitNotifier.value;
              }),
            
            const SizedBox(height: 32),
            
            // Value display
            ValueListenableBuilder<double>(
              valueListenable: _currentValueNotifier,
              builder: (context, currentValue, _) {
                final measurementValue = MeasurementValue(
                  value: currentValue,
                  unit: _currentConfig.primaryUnit,
                  isPrimaryUnit: isPrimaryUnit,
                );
                
                return widget.valueDisplayBuilder?.call(measurementValue) ??
                    _buildDefaultValueDisplay(measurementValue);
              },
            ),
            
            const SizedBox(height: 32),
            
            // Scale widget
            ScaleWidget(
              config: widget.scaleConfig,
              measurementConfig: _currentConfig,
              controller: _scrollController,
              onChanged: _onScaleChanged,
              shaderColors: widget.shaderColors,
              shaderStops: widget.shaderStops,
            ),
          ],
        );
      },
    );
  }
}

/// Represents a measurement value with its unit
class MeasurementValue {
  final double value;
  final String unit;
  final bool isPrimaryUnit;
  final int decimalPlaces;

  const MeasurementValue({
    required this.value,
    required this.unit,
    required this.isPrimaryUnit,
    this.decimalPlaces = 0,
  });

  String get formattedValue => value.toStringAsFixed(decimalPlaces);

  @override
  String toString() => '$formattedValue $unit';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is MeasurementValue &&
        other.value == value &&
        other.unit == unit &&
        other.isPrimaryUnit == isPrimaryUnit;
  }

  @override
  int get hashCode => Object.hash(value, unit, isPrimaryUnit);
}