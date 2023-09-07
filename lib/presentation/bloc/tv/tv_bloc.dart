import 'package:ditonton/common/state_enum.dart';
import 'package:ditonton/domain/entities/tv_series.dart';
import 'package:ditonton/domain/usecases/get_airing_today_tvseries.dart';
import 'package:ditonton/domain/usecases/get_popular_tvseries.dart';
import 'package:ditonton/domain/usecases/get_top_rated_tvseries.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'tv_event.dart';
part 'tv_state.dart';

class TVBloc extends Bloc<TVEvent, TVState> {
  final GetAiringTodayTVSeries getAiringTodayTVSeries;
  final GetPopularTVSeries getPopularTV;
  final GetTopRatedTVSeries getTopRatedTV;

  TVBloc({
    required this.getAiringTodayTVSeries,
    required this.getPopularTV,
    required this.getTopRatedTV,
  }) : super(TVState.initial()) {
    on<OnFetchAiringToday>((event, emit) async {
      emit(state.copyWith(statusAiringToday: RequestState.Loading));
      final result = await getAiringTodayTVSeries.execute();

      result.fold(
            (failure) {
          emit(state.copyWith(
            statusAiringToday: RequestState.Error,
            failureMessage: failure.message,
          ));
        },
            (data) {
          emit(state.copyWith(
            statusAiringToday: RequestState.Loaded,
            resultAiringToday: data,
          ));
        },
      );
    });

    on<OnFetchPopular>((event, emit) async {
      emit(state.copyWith(statusPopular: RequestState.Loading));
      final result = await getPopularTV.execute();

      result.fold(
            (failure) {
          emit(state.copyWith(
            statusPopular: RequestState.Error,
            failureMessage: failure.message,
          ));
        },
            (data) {
          emit(state.copyWith(
            statusPopular: RequestState.Loaded,
            resultPopular: data,
          ));
        },
      );
    });

    on<OnFetchTopRated>((event, emit) async {
      emit(state.copyWith(statusTopRated: RequestState.Loading));
      final result = await getTopRatedTV.execute();

      result.fold(
            (failure) {
          emit(state.copyWith(
            statusTopRated: RequestState.Error,
            failureMessage: failure.message,
          ));
        },
            (data) {
          emit(state.copyWith(
            statusTopRated: RequestState.Loaded,
            resultTopRated: data,
          ));
        },
      );
    });
  }
}
