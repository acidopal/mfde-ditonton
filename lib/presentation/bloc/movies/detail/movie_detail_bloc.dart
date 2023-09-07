import 'package:ditonton/common/state_enum.dart';
import 'package:ditonton/domain/entities/movie.dart';
import 'package:ditonton/domain/entities/movie_detail.dart';
import 'package:ditonton/domain/usecases/get_movie_detail.dart';
import 'package:ditonton/domain/usecases/get_movie_recommendations.dart';
import 'package:ditonton/domain/usecases/get_watchlist_status.dart';
import 'package:ditonton/domain/usecases/remove_watchlist.dart';
import 'package:ditonton/domain/usecases/save_watchlist.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'movie_detail_event.dart';

part 'movie_detail_state.dart';

class MovieDetailBloc extends Bloc<MovieDetailEvent, MovieDetailState> {
  static const watchlistAddSuccessMessage = 'Added to Watchlist';
  static const watchlistRemoveSuccessMessage = 'Removed from Watchlist';

  final GetMovieDetail getDetailMovie;
  final GetMovieRecommendations getRecommendation;
  final SaveWatchlist saveWatchlist;
  final GetWatchListStatus getWatchListStatus;
  final RemoveWatchlist removeWatchList;

  MovieDetailBloc({
    required this.getDetailMovie,
    required this.getRecommendation,
    required this.saveWatchlist,
    required this.getWatchListStatus,
    required this.removeWatchList,
  }) : super(MovieDetailState.initial()) {
    on<OnResetState>((event, emit) => emit(MovieDetailState.initial()));

    on<OnFetchDetailMovie>((event, emit) async {
      emit(state.copyWith(statusDetail: RequestState.Loading));
      final result = await getDetailMovie.execute(event.id);
      final resultRecommendation = await getRecommendation.execute(event.id);

      result.fold(
        (failure) {
          emit(state.copyWith(
            statusDetail: RequestState.Error,
            failureMessage: failure.message,
          ));
        },
        (data) {
          emit(state.copyWith(
            statusRecommendation: RequestState.Loading,
            movie: data,
          ));
          resultRecommendation.fold(
            (failure) {
              emit(state.copyWith(
                statusRecommendation: RequestState.Error,
                failureMessage: failure.message,
              ));
            },
            (recommendations) {
              emit(state.copyWith(
                statusRecommendation: RequestState.Loaded,
                statusDetail: RequestState.Loaded,
                movieRecommendation: recommendations,
              ));
            },
          );
        },
      );
    });

    on<OnAddWatchList>((event, emit) async {
      final result = await saveWatchlist.execute(event.movieDetail);

      result.fold(
        (failure) {
          emit(state.copyWith(
            watchlistMessage: failure.message,
          ));
        },
        (success) {
          emit(state.copyWith(
            watchlistMessage: success,
          ));
        },
      );
      add(OnLoadWatchListStatus(id: event.movieDetail.id));
    });

    on<OnRemoveWatchList>((event, emit) async {
      final result = await removeWatchList.execute(event.movieDetail);

      result.fold(
        (failure) {
          emit(state.copyWith(
            watchlistMessage: failure.message,
          ));
        },
        (success) {
          emit(state.copyWith(
            watchlistMessage: success,
          ));
        },
      );
      add(OnLoadWatchListStatus(id: event.movieDetail.id));
    });

    on<OnLoadWatchListStatus>((event, emit) async {
      final result = await getWatchListStatus.execute(event.id);
      emit(MovieDetailState.initial().copyWith(
        isAddedToWatchlist: result,
        statusRecommendation: state.statusRecommendation,
        statusDetail: state.statusDetail,
        movieRecommendation: state.movieRecommendation,
        movie: state.movie
      ));
    });
  }
}
