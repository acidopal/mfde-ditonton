import 'package:ditonton/domain/entities/tv_series.dart';
import 'package:ditonton/domain/usecases/get_top_rated_tvseries.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'top_rated_tv_event.dart';
part 'top_rated_tv_state.dart';

class TopRatedTVBloc extends Bloc<TopRatedTVEvent, TopRatedTVState> {

  final GetTopRatedTVSeries getTopRatedTVSeries;

  TopRatedTVBloc({
    required this.getTopRatedTVSeries,
  }) : super(TopRatedTVEmpty()) {
    on<FetchTopRatedTVSeries>((event, emit) async {
      emit(TopRatedTVLoading());
      final result = await getTopRatedTVSeries.execute();

      result.fold(
            (failure) {
          emit(TopRatedTVError(failure.message));
        },
            (data) {
          emit(TopRatedTVHasData(result: data));
        },
      );
    });
  }
}