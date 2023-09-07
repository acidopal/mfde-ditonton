import 'package:ditonton/common/state_enum.dart';
import 'package:ditonton/domain/entities/movie.dart';
import 'package:ditonton/domain/usecases/get_now_playing_movies.dart';
import 'package:ditonton/domain/usecases/get_popular_movies.dart';
import 'package:ditonton/domain/usecases/get_top_rated_movies.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'movies_event.dart';
part 'movies_state.dart';

class MoviesBloc extends Bloc<MoviesEvent, MoviesState> {
  final GetNowPlayingMovies getNowPlayingMovies;
  final GetPopularMovies getPopularMovies;
  final GetTopRatedMovies getTopRatedMovies;

  MoviesBloc({
    required this.getNowPlayingMovies,
    required this.getPopularMovies,
    required this.getTopRatedMovies,
  }) : super(MoviesState.initial()) {
    on<GetNowPlaying>((event, emit) async {
      emit(state.copyWith(statusNowPlaying: RequestState.loading));
      final result = await getNowPlayingMovies.execute();

      result.fold(
        (failure) {
          emit(state.copyWith(
            statusNowPlaying: RequestState.error,
            failureMessage: failure.message,
          ));
        },
        (data) {
          emit(state.copyWith(
            statusNowPlaying: RequestState.loaded,
            resultNowPlaying: data,
          ));
        },
      );
    });

    on<GetPopular>((event, emit) async {
      emit(state.copyWith(statusPopular: RequestState.loading));
      final result = await getPopularMovies.execute();

      result.fold(
        (failure) {
          emit(state.copyWith(
            statusPopular: RequestState.error,
            failureMessage: failure.message,
          ));
        },
        (data) {
          emit(state.copyWith(
            statusPopular: RequestState.loaded,
            resultPopular: data,
          ));
        },
      );
    });

    on<GetTopRated>((event, emit) async {
      emit(state.copyWith(statusTopRated: RequestState.loading));
      final result = await getTopRatedMovies.execute();

      result.fold(
        (failure) {
          emit(state.copyWith(
            statusTopRated: RequestState.error,
            failureMessage: failure.message,
          ));
        },
        (data) {
          emit(state.copyWith(
            statusTopRated: RequestState.loaded,
            resultTopRated: data,
          ));
        },
      );
    });
  }
}
