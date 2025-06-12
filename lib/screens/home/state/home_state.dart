import 'package:bloom_flutter/screens/home/model/home_model.dart';

abstract class HomeState {}

class HomeInitial extends HomeState {}

class HomeLoading extends HomeState {}

class HomeLoaded extends HomeState {
  final HomeModel data;
  HomeLoaded(this.data);
}

class HomeError extends HomeState {
  final String msg;
  HomeError(this.msg);
}