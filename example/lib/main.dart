import 'package:flutter/material.dart';
import 'package:scale_picker/scale_picker.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Scale Picker Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        useMaterial3: true,
      ),
      home: const ScalePickerDemo(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class ScalePickerDemo extends StatefulWidget {
  const ScalePickerDemo({super.key});

  @override
  State<ScalePickerDemo> createState() => _ScalePickerDemoState();
}

class _ScalePickerDemoState extends State<ScalePickerDemo> {
  MeasurementValue? _heightValue;
  MeasurementValue? _weightValue;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Scale Picker Demo'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            _buildSummaryCard(),
            const SizedBox(height: 24),
            _buildTabView(),
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryCard() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const Text(
              'Current Selection',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Column(
                  children: [
                    const Text('Height', style: TextStyle(fontSize: 12)),
                    Text(
                      _heightValue?.toString() ?? 'Not selected',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
                Column(
                  children: [
                    const Text('Weight', style: TextStyle(fontSize: 12)),
                    Text(
                      _weightValue?.toString() ?? 'Not selected',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTabView() {
    return DefaultTabController(
      length: 4,
      child: Column(
        children: [
          const TabBar(
            labelColor: Colors.blue,
            unselectedLabelColor: Colors.grey,
            tabs: [
              Tab(text: 'Height'),
              Tab(text: 'Weight'),
              Tab(text: 'Basic Scale'),
              Tab(text: 'Custom Scale'),
            ],
          ),
          SizedBox(
            height: 500,
            child: TabBarView(
              children: [
                _buildHeightPicker(),
                _buildWeightPicker(),
                _buildBasicScale(),
                _buildCustomScale(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeightPicker() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: MeasurementPicker(
        primaryConfig: MeasurementConfig.heightCm,
        secondaryConfig: const MeasurementConfig(
          primaryUnit: 'ft',
          secondaryUnit: 'cm',
          minValue: 2.0,
          maxValue: 8.5,
          initialValue: 5.7,
          majorInterval: 1,
          minorInterval: 1,
          decimalPlaces: 0,
          conversionFactor: 0.0328084,
          labelFormatter: _heightFeetFormatter,
        ),
        scaleConfig: const ScaleConfig(
          isVertical: true,
          backgroundColor: Color(0xFFF8F9FA),
          centerIndicatorColor: Colors.blue,
          majorLineColor: Colors.blue,
          minorLineColor: Colors.grey,
        ),
        title: 'How tall are you?',
        subtitle: 'This is used to calculate your BMI',
        primaryUnitLabel: 'CM',
        secondaryUnitLabel: 'FT',
        onChanged: (value) {
          setState(() {
            _heightValue = value;
          });
        },
        shaderColors: [
          Colors.white.withOpacity(0.01),
          Colors.white,
          Colors.white,
          Colors.white.withOpacity(0.01),
        ],
        shaderStops: const [0.1, 0.26, 0.75, 1.0],
      ),
    );
  }

  Widget _buildWeightPicker() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: MeasurementPicker(
        primaryConfig: MeasurementConfig.weightKg,
        secondaryConfig: MeasurementConfig.weightLbs,
        scaleConfig: const ScaleConfig(
          isVertical: true,
          backgroundColor: Color(0xFFF0F8FF),
          centerIndicatorColor: Colors.green,
          majorLineColor: Colors.green,
          minorLineColor: Colors.grey,
        ),
        title: 'What\'s your weight?',
        subtitle: 'This helps us personalize your experience',
        primaryUnitLabel: 'KG',
        secondaryUnitLabel: 'LBS',
        onChanged: (value) {
          setState(() {
            _weightValue = value;
          });
        },
        shaderColors: [
          Colors.white.withOpacity(0.01),
          Colors.lightBlue.withOpacity(0.3),
          Colors.white.withOpacity(0.01),
        ],
        shaderStops: const [0.1, 0.5, 1.0],
      ),
    );
  }

  Widget _buildBasicScale() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          const Text(
            'Basic Horizontal Scale',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 32),
          ScaleWidget(
            config: const ScaleConfig(
              isVertical: false,
              height: 120,
              backgroundColor: Colors.white,
              centerIndicatorColor: Colors.orange,
              majorLineColor: Colors.orange,
              minorLineColor: Colors.grey,
              borderRadius: BorderRadius.all(Radius.circular(12)),
            ),
            measurementConfig: const MeasurementConfig(
              primaryUnit: 'units',
              secondaryUnit: 'units',
              minValue: 0,
              maxValue: 100,
              initialValue: 50,
              majorInterval: 10,
              minorInterval: 1,
            ),
            onChanged: (value) {
              print('Basic Scale Value: $value');
            },
          ),
        ],
      ),
    );
  }

  Widget _buildCustomScale() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          const Text(
            'Custom Temperature Scale',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 32),
          ScaleWidget(
            config: ScaleConfig(
              isVertical: true,
              height: 300,
              backgroundColor: Colors.grey[100]!,
              centerIndicatorColor: Colors.red,
              majorLineColor: Colors.red,
              minorLineColor: Colors.pink.shade200,
              borderRadius: const BorderRadius.all(Radius.circular(16)),
              majorTextStyle: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: Colors.red,
              ),
            ),
            measurementConfig: const MeasurementConfig(
              primaryUnit: '°C',
              secondaryUnit: '°F',
              minValue: -10,
              maxValue: 50,
              initialValue: 25,
              majorInterval: 10,
              minorInterval: 5,
            ),
            onChanged: (value) {
              print('Temperature: ${value}°C');
            },
            shaderColors: [
              Colors.blue.withOpacity(0.3),
              Colors.white,
              Colors.red.withOpacity(0.3),
            ],
            shaderStops: const [0.0, 0.5, 1.0],
          ),
        ],
      ),
    );
  }

  static String _heightFeetFormatter(int index, bool isMajor) {
    if (!isMajor) return '';
    final feet = (index ~/ 12) + 2;
    final inches = index % 12;
    if (inches == 0) {
      return '$feet\'';
    } else {
      return '$inches"';
    }
  }
}