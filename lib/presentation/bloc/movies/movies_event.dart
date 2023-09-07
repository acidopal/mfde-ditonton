part of 'movies_bloc.dart';

abstract class MoviesEvent extends Equatable {
  const MoviesEvent();

  @override
  List<Object> get props => [];
}

class GetNowPlaying extends MoviesEvent {}
class GetPopular extends MoviesEvent {}
class GetTopRated extends MoviesEvent {}