class HomeModel {
  final Duration sessionTime;
  final Duration screenTime;
  final Duration exceededTime;
  final bool isServiceRunning;

  HomeModel({
    required this.sessionTime,
    required this.screenTime,
    required this.exceededTime,
    this.isServiceRunning = false,
  });

  HomeModel copyWith({
    Duration? sessionTime,
    Duration? screenTime,
    Duration? exceededTime,
    bool? isServiceRunning,
  }) {
    return HomeModel(
      sessionTime: sessionTime ?? this.sessionTime,
      screenTime: screenTime ?? this.screenTime,
      exceededTime: exceededTime ?? this.exceededTime,
      isServiceRunning: isServiceRunning ?? this.isServiceRunning,
    );
  }
}