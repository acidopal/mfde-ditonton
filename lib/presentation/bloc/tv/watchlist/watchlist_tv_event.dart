part of 'watchlist_tv_bloc.dart';

abstract class TVWatchlistEvent extends Equatable {
  const TVWatchlistEvent();

  @override
  List<Object> get props => [];
}

class FetchWatchlistTVSeries extends TVWatchlistEvent {}