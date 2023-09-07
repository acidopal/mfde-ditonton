part of 'airing_today_bloc.dart';

abstract class AiringTodayEvent extends Equatable {
  const AiringTodayEvent();

  @override
  List<Object> get props => [];
}

class FetchAiringTodayTVSeries extends AiringTodayEvent {}