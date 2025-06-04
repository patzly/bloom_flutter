class HomeModel {
  final Duration sessionTime;
  final Duration screenTime;
  final Duration exceededTime;

  HomeModel({
    required this.sessionTime,
    required this.screenTime,
    required this.exceededTime,
  });
}