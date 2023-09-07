import 'package:ditonton/common/state_enum.dart';
import 'package:ditonton/domain/entities/tv_series.dart';
import 'package:ditonton/domain/entities/tv_series_detail.dart';
import 'package:ditonton/domain/usecases/get_tv_series_detail.dart';
import 'package:ditonton/domain/usecases/get_tv_series_recommendations.dart';
import 'package:ditonton/domain/usecases/get_watchlist_status.dart';
import 'package:ditonton/domain/usecases/remove_watchlist_tv_series.dart';
import 'package:ditonton/domain/usecases/save_watchlist_tv_series.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'tv_detail_event.dart';

part 'tv_detail_state.dart';

class TVSeriesDetailBloc extends Bloc<TVSeriesDetailEvent, TVSeriesDetailState> {
  static const watchlistAddSuccessMessage = 'Added to Watchlist';
  static const watchlistRemoveSuccessMessage = 'Removed from Watchlist';

  final GetTVSeriesDetail getTVSeriesDetail;
  final GetTVSeriesRecommendations getTVSeriesRecommendations;
  final SaveWatchlistTVSeries saveWatchlist;
  final GetWatchListStatus getWatchListStatus;
  final RemoveWatchlistTVSeries removeWatchList;

  TVSeriesDetailBloc({
    required this.getTVSeriesDetail,
    required this.getTVSeriesRecommendations,
    required this.saveWatchlist,
    required this.getWatchListStatus,
    required this.removeWatchList,
  }) : super(TVSeriesDetailState.initial()) {

    on<OnResetStateTVSeries>((event, emit) => emit(TVSeriesDetailState.initial()));

    on<OnFetchDetailTVSeries>((event, emit) async {
      emit(state.copyWith(statusDetail: RequestState.Loading));
      final result = await getTVSeriesDetail.execute(event.id);
      final resultRecommendation = await getTVSeriesRecommendations.execute(event.id);

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
            tvSeries: data,
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
                tvSeriesRecommendation: recommendations,
              ));
            },
          );
        },
      );
    });

    on<OnAddWatchListTVSeries>((event, emit) async {
      final result = await saveWatchlist.execute(event.tvSeriesDetail);

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
      add(OnLoadWatchListStatusTVSeries(id: event.tvSeriesDetail.id));
    });

    on<OnRemoveWatchListTVSeries>((event, emit) async {
      final result = await removeWatchList.execute(event.tvSeriesDetail);

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
      add(OnLoadWatchListStatusTVSeries(id: event.tvSeriesDetail.id));
    });

    on<OnLoadWatchListStatusTVSeries>((event, emit) async {
      final result = await getWatchListStatus.execute(event.id);
      emit(TVSeriesDetailState.initial().copyWith(
          isAddedToWatchlist: result,
          statusRecommendation: state.statusRecommendation,
          statusDetail: state.statusDetail,
          tvSeriesRecommendation: state.tvSeriesRecommendation,
          tvSeries: state.tvSeries
      ));
    });
  }
}
