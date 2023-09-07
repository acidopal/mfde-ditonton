import 'package:ditonton/domain/entities/tv_series.dart';
import 'package:ditonton/domain/usecases/get_popular_tvseries.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'popular_tv_event.dart';
part 'popular_tv_state.dart';

class PopularTVBloc extends Bloc<PopularTVEvent, PopularTVState> {

  final GetPopularTVSeries getPopularTVSeries;

  PopularTVBloc({
    required this.getPopularTVSeries,
  }) : super(PopularTVEmpty()) {
    on<FetchPopularTVSeries>((event, emit) async {
      emit(PopularTVLoading());
      final result = await getPopularTVSeries.execute();

      result.fold(
            (failure) {
          emit(PopularTVError(failure.message));
        },
            (data) {
          emit(PopularTVHasData(result: data));
        },
      );
    });
  }
}