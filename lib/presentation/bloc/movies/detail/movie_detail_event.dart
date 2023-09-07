part of 'movie_detail_bloc.dart';

abstract class MovieDetailEvent extends Equatable {
  const MovieDetailEvent();

  @override
  List<Object> get props => [];
}

class OnResetState extends MovieDetailEvent {}

class OnFetchDetailMovie extends MovieDetailEvent {
  final int id;

  OnFetchDetailMovie({required this.id});

  @override
  List<Object> get props => [id];
}

class OnAddWatchList extends MovieDetailEvent {
  final MovieDetail movieDetail;

  OnAddWatchList({required this.movieDetail});

  @override
  List<Object> get props => [movieDetail];
}

class OnRemoveWatchList extends MovieDetailEvent {
  final MovieDetail movieDetail;

  OnRemoveWatchList({required this.movieDetail});

  @override
  List<Object> get props => [movieDetail];
}

class OnLoadWatchListStatus extends MovieDetailEvent {
  final int id;

  OnLoadWatchListStatus({required this.id});

  @override
  List<Object> get props => [id];
}