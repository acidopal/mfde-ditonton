import 'package:ditonton/domain/entities/tv_series.dart';
import 'package:ditonton/domain/usecases/get_watchlist_tv_series.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'watchlist_tv_event.dart';
part 'watchlist_tv_state.dart';

class TVWatchlistBloc
    extends Bloc<TVWatchlistEvent, TVWatchlistState> {
  final GetWatchlistTVSeries getWatchlistTVSeries;

  TVWatchlistBloc({
    required this.getWatchlistTVSeries,
  }) : super(TVWatchlistEmpty()) {
    on<FetchWatchlistTVSeries>((event, emit) async {
      emit(TVWatchlistLoading());
      final result = await getWatchlistTVSeries.execute();

      result.fold(
            (failure) {
          emit(TVWatchlistError(failure.message));
        },
            (data) {
          final filterByTV =
          data.where((element) => element.isMovie == 0).toList();
          emit(TVWatchlistHasData(result: filterByTV));
        },
      );
    });
  }
}
