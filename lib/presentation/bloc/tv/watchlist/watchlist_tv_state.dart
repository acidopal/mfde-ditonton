part of 'watchlist_tv_bloc.dart';

abstract class TVWatchlistState extends Equatable {
  const TVWatchlistState();

  @override
  List<Object> get props => [];
}

class TVWatchlistEmpty extends TVWatchlistState {}

class TVWatchlistLoading extends TVWatchlistState {}

class TVWatchlistError extends TVWatchlistState {
  final String message;

  TVWatchlistError(this.message);

  @override
  List<Object> get props => [message];
}

class TVWatchlistHasData extends TVWatchlistState {
  final List<TVSeries> result;

  TVWatchlistHasData({required this.result});

  @override
  List<Object> get props => [result];
}