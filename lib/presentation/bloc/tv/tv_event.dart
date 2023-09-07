part of 'tv_bloc.dart';

abstract class TVEvent extends Equatable {
  const TVEvent();

  @override
  List<Object> get props => [];
}

class OnFetchAiringToday extends TVEvent {}
class OnFetchPopular extends TVEvent {}
class OnFetchTopRated extends TVEvent {}