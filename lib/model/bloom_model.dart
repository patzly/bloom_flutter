class BloomModel {
  final Duration sessionTime;
  final Duration screenTime;
  final Duration exceededTime;
  final bool isServiceRunning;

  BloomModel({
    required this.sessionTime,
    required this.screenTime,
    required this.exceededTime,
    this.isServiceRunning = false,
  });

  BloomModel copyWith({
    Duration? sessionTime,
    Duration? screenTime,
    Duration? exceededTime,
    bool? isServiceRunning,
  }) {
    return BloomModel(
      sessionTime: sessionTime ?? this.sessionTime,
      screenTime: screenTime ?? this.screenTime,
      exceededTime: exceededTime ?? this.exceededTime,
      isServiceRunning: isServiceRunning ?? this.isServiceRunning,
    );
  }
}