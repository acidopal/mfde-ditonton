import 'package:ditonton/domain/entities/movie.dart';
import 'package:ditonton/domain/usecases/get_top_rated_movies.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'top_rated_event.dart';
part 'top_rated_state.dart';

class TopRatedBloc extends Bloc<TopRatedEvent, TopRatedState> {

  final GetTopRatedMovies getTopRated;

  TopRatedBloc({
    required this.getTopRated,
  }) : super(TopRatedEmpty()) {
    on<FetchTopRatedMovies>((event, emit) async {
      emit(TopRatedLoading());
      final result = await getTopRated.execute();

      result.fold(
            (failure) {
          emit(TopRatedError(failure.message));
        },
            (data) {
          emit(TopRatedHasData(result: data));
        },
      );
    });
  }
}