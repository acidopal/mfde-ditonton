part of 'movies_bloc.dart';

class MoviesState extends Equatable {
  const MoviesState({
    this.statusNowPlaying = RequestState.Empty,
    this.statusPopular = RequestState.Empty,
    this.statusTopRated = RequestState.Empty,
    this.resultNowPlaying = const [],
    this.resultPopular = const [],
    this.resultTopRated = const [],
    this.failureMessage = '',
  });

  factory MoviesState.initial() {
    return const MoviesState();
  }

  final RequestState statusNowPlaying;
  final RequestState statusPopular;
  final RequestState statusTopRated;
  final List<Movie> resultNowPlaying;
  final List<Movie> resultPopular;
  final List<Movie> resultTopRated;
  final String? failureMessage;

  MoviesState copyWith({
    RequestState? statusNowPlaying,
    RequestState? statusPopular,
    RequestState? statusTopRated,
    List<Movie>? resultNowPlaying,
    List<Movie>? resultPopular,
    List<Movie>? resultTopRated,
    String? failureMessage,
  }) {
    return MoviesState(
      statusNowPlaying: statusNowPlaying ?? this.statusNowPlaying,
      statusPopular: statusPopular ?? this.statusPopular,
      statusTopRated: statusTopRated ?? this.statusTopRated,
      resultNowPlaying: resultNowPlaying ?? this.resultNowPlaying,
      resultPopular: resultPopular ?? this.resultPopular,
      resultTopRated: resultTopRated ?? this.resultTopRated,
      failureMessage: failureMessage,
    );
  }

  @override
  List<Object?> get props => [
        statusNowPlaying,
        statusPopular,
        statusTopRated,
        resultNowPlaying,
        resultPopular,
        resultTopRated,
        failureMessage,
      ];
}
