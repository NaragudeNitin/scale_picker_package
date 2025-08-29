/// Utility class for unit conversions
class UnitConverter {
  // Height conversions
  static double cmToFeet(double cm) => cm * 0.0328084;
  static double feetToCm(double feet) => feet * 30.48;
  static double cmToInches(double cm) => cm * 0.393701;
  static double inchesToCm(double inches) => inches * 2.54;
  
  // Weight conversions
  static double kgToLbs(double kg) => kg * 2.20462;
  static double lbsToKg(double lbs) => lbs * 0.453592;
  
  // Temperature conversions
  static double celsiusToFahrenheit(double celsius) => (celsius * 9/5) + 32;
  static double fahrenheitToCelsius(double fahrenheit) => (fahrenheit - 32) * 5/9;
  
  // Generic conversion
  static double convert(double value, double conversionFactor) {
    return value * conversionFactor;
  }
  
  // Format feet and inches
  static Map<String, int> cmToFeetAndInches(double cm) {
    final totalInches = cmToInches(cm);
    final feet = totalInches ~/ 12;
    final inches = (totalInches % 12).round();
    return {'feet': feet, 'inches': inches};
  }
  
  static double feetAndInchesToCm(int feet, int inches) {
    final totalInches = (feet * 12) + inches;
    return inchesToCm(totalInches.toDouble());
  }
  
  // Format value with specified decimal places
  static String formatValue(double value, int decimalPlaces) {
    return value.toStringAsFixed(decimalPlaces);
  }
  
  // Parse feet and inches string like "5' 8\""
  static Map<String, int>? parseFeetInches(String value) {
    final regex = RegExp(r"(\d+)'\s*(\d+)\"?");
    final match = regex.firstMatch(value);
    
    if (match != null) {
      final feet = int.tryParse(match.group(1) ?? '');
      final inches = int.tryParse(match.group(2) ?? '');
      
      if (feet != null && inches != null) {
        return {'feet': feet, 'inches': inches};
      }
    }
    return null;
  }
}