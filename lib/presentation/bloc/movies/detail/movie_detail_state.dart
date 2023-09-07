part of 'movie_detail_bloc.dart';

class MovieDetailState extends Equatable {
  const MovieDetailState({
    required this.statusDetail,
    required this.statusRecommendation,
    required this.movie,
    required this.movieRecommendation,
    required this.isAddedToWatchlist,
    required this.failureMessage,
    required this.watchlistMessage,
  });

  factory MovieDetailState.initial() {
    return const MovieDetailState(
      statusDetail: RequestState.Empty,
      statusRecommendation: RequestState.Empty,
      movieRecommendation: [],
      movie: null,
      isAddedToWatchlist: false,
      failureMessage: null,
      watchlistMessage: null,
    );
  }

  final RequestState statusDetail;
  final RequestState statusRecommendation;
  final List<Movie> movieRecommendation;
  final MovieDetail? movie;
  final bool isAddedToWatchlist;
  final String? failureMessage;
  final String? watchlistMessage;

  MovieDetailState copyWith({
    RequestState? statusDetail,
    RequestState? statusRecommendation,
    List<Movie>? movieRecommendation,
    MovieDetail? movie,
    bool? isAddedToWatchlist,
    String? failureMessage,
    String? watchlistMessage,
  }) {
    return MovieDetailState(
      statusDetail: statusDetail ?? this.statusDetail,
      statusRecommendation: statusRecommendation ?? this.statusRecommendation,
      movieRecommendation: movieRecommendation ?? this.movieRecommendation,
      movie: movie ?? this.movie,
      isAddedToWatchlist: isAddedToWatchlist ?? this.isAddedToWatchlist,
      failureMessage: failureMessage ?? this.failureMessage,
      watchlistMessage: watchlistMessage ?? this.watchlistMessage,
    );
  }

  @override
  List<Object?> get props => [
    statusDetail,
    statusRecommendation,
    movieRecommendation,
    movie,
    isAddedToWatchlist,
    failureMessage,
    watchlistMessage,
  ];
}
