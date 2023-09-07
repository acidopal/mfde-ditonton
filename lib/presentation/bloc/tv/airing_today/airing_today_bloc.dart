import 'package:ditonton/domain/entities/tv_series.dart';
import 'package:ditonton/domain/usecases/get_airing_today_tvseries.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'airing_today_event.dart';
part 'airing_today_state.dart';

class AiringTodayBloc extends Bloc<AiringTodayEvent, AiringTodayState> {

  final GetAiringTodayTVSeries getAiringTodayTVSeries;

  AiringTodayBloc({
    required this.getAiringTodayTVSeries,
  }) : super(AiringTodayEmpty()) {
    on<FetchAiringTodayTVSeries>((event, emit) async {
      emit(AiringTodayLoading());
      final result = await getAiringTodayTVSeries.execute();

      result.fold(
            (failure) {
          emit(AiringTodayError(failure.message));
        },
            (data) {
          emit(AiringTodayHasData(result: data));
        },
      );
    });
  }
}