import 'package:ditonton/domain/entities/movie.dart';
import 'package:ditonton/domain/usecases/get_popular_movies.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'popular_event.dart';
part 'popular_state.dart';

class PopularBloc extends Bloc<PopularEvent, PopularState> {

  final GetPopularMovies getPopularMovies;

  PopularBloc({
    required this.getPopularMovies,
  }) : super(PopularEmpty()) {
    on<FetchPopularMovies>((event, emit) async {
      emit(PopularLoading());
      final result = await getPopularMovies.execute();

      result.fold(
            (failure) {
          emit(PopularError(failure.message));
        },
            (data) {
          emit(PopularHasData(result: data));
        },
      );
    });
  }
}