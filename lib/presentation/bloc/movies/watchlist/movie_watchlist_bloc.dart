import 'package:ditonton/domain/entities/movie.dart';
import 'package:ditonton/domain/usecases/get_watchlist_movies.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'movie_watchlist_event.dart';

part 'movie_watchlist_state.dart';

class MovieWatchlistBloc
    extends Bloc<MovieWatchlistEvent, MovieWatchlistState> {
  final GetWatchlistMovies getMovieWatchlist;

  MovieWatchlistBloc({
    required this.getMovieWatchlist,
  }) : super(MovieWatchlistEmpty()) {
    on<FetchWatchlistMovies>((event, emit) async {
      emit(MovieWatchlistLoading());
      final result = await getMovieWatchlist.execute();

      result.fold(
        (failure) {
          emit(MovieWatchlistError(failure.message));
        },
        (data) {
          final filterByMovie =
              data.where((element) => element.isMovie == 1).toList();
          emit(MovieWatchlistHasData(result: filterByMovie));
        },
      );
    });
  }
}
