class Constants {
  static const sessionTimeTolerance = 1; // in minutes (default is 5)
  static const updateInterval = 1000; // in milliseconds
}

class PrefKeys {
  static const brightnessLevel = 'brightnessLevel';
  static const contrastLevel = 'contrastLevel';
  static const sessionTimeFraction = 'sessionTimeFraction';
  static const sessionTimeToleranceFraction = 'sessionTimeToleranceFraction';
  static const sessionTimeMax = 'sessionTimeMax';
  static const breakTimeMin = 'breakTimeMin';
  static const screenTimeFraction = 'screenTimeFraction';
  static const screenTimeMax = 'screenTimeMax';
}

class Defaults {
  static const brightnessLevel = BrightnessLevel.auto;
  static const contrastLevel = ContrastLevel.standard;
  static const sessionTimeFraction = 0.0;
  static const sessionTimeToleranceFraction = 0.0;
  static const sessionTimeMax = 1; // in minutes (default is 10)
  static const breakTimeMin = 1; // in minutes (default is 10)
  static const screenTimeFraction = 0.0;
  static const screenTimeMax = 180; // in minutes (default is 180)
}

enum BrightnessLevel { auto, light, dark }

enum ContrastLevel { standard, medium, high }