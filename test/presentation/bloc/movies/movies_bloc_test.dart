import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:ditonton/common/failure.dart';
import 'package:ditonton/common/state_enum.dart';
import 'package:ditonton/domain/entities/movie.dart';
import 'package:ditonton/domain/usecases/get_now_playing_movies.dart';
import 'package:ditonton/domain/usecases/get_popular_movies.dart';
import 'package:ditonton/domain/usecases/get_top_rated_movies.dart';
import 'package:ditonton/presentation/bloc/bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'movies_bloc_test.mocks.dart';

@GenerateMocks([GetNowPlayingMovies, GetPopularMovies, GetTopRatedMovies])
void main() {
  late MoviesBloc moviesBloc;
  late MockGetNowPlayingMovies mockGetNowPlayingMovies;
  late MockGetPopularMovies mockGetPopularMovies;
  late MockGetTopRatedMovies mockGetTopRatedMovies;

  setUp(() {
    mockGetNowPlayingMovies = MockGetNowPlayingMovies();
    mockGetPopularMovies = MockGetPopularMovies();
    mockGetTopRatedMovies = MockGetTopRatedMovies();
    moviesBloc = MoviesBloc(
      getNowPlayingMovies: mockGetNowPlayingMovies,
      getPopularMovies: mockGetPopularMovies,
      getTopRatedMovies: mockGetTopRatedMovies,
    );
  });

  final tMovieModel = Movie(
    adult: false,
    backdropPath: '/muth4OYamXf41G2evdrLEg8d3om.jpg',
    genreIds: [14, 28],
    id: 557,
    originalTitle: 'Spider-Man',
    overview:
        'After being bitten by a genetically altered spider, nerdy high school student Peter Parker is endowed with amazing powers to become the Amazing superhero known as Spider-Man.',
    popularity: 60.441,
    posterPath: '/rweIrveL43TaxUN0akQEaAXL6x0.jpg',
    releaseDate: '2002-05-01',
    title: 'Spider-Man',
    video: false,
    voteAverage: 7.2,
    voteCount: 13507,
  );
  final tMovieList = <Movie>[tMovieModel];

  test('initial state should be empty', () {
    expect(moviesBloc.state, MoviesState.initial());
  });

  // NOW PLAYING TEST
  blocTest<MoviesBloc, MoviesState>(
    'Should emit [Loading, HasData for Now Playing Movie] when data is gotten successfully',
    build: () {
      when(mockGetNowPlayingMovies.execute())
          .thenAnswer((_) async => Right(tMovieList));
      return moviesBloc;
    },
    act: (bloc) => bloc.add(GetNowPlaying()),
    wait: const Duration(milliseconds: 100),
    expect: () => [
      moviesBloc.state.copyWith(
        statusNowPlaying: RequestState.Loading,
        resultNowPlaying: []
      ),
      moviesBloc.state.copyWith(
        statusNowPlaying: RequestState.Loaded,
        resultNowPlaying: tMovieList,
      ),
    ],
    verify: (bloc) {
      verify(mockGetNowPlayingMovies.execute());
    },
  );

  blocTest<MoviesBloc, MoviesState>(
    'Should emit [Loading, Error NowPlaying Movie] when get is unsuccessful',
    build: () {
      when(mockGetNowPlayingMovies.execute())
          .thenAnswer((_) async => Left(ServerFailure('Server Failure')));
      return moviesBloc;
    },
    act: (bloc) => bloc.add(GetNowPlaying()),
    wait: const Duration(milliseconds: 100),
    expect: () => [
      moviesBloc.state.copyWith(
          statusNowPlaying: RequestState.Loading,
        failureMessage: null,
      ),
      moviesBloc.state.copyWith(
        statusNowPlaying: RequestState.Error,
        failureMessage: 'Server Failure',
      ),
    ],
    verify: (bloc) {
      verify(mockGetNowPlayingMovies.execute());
    },
  );

  // POPULAR TEST
  blocTest<MoviesBloc, MoviesState>(
    'Should emit [Loading, HasData for Popular Movie] when data is gotten successfully',
    build: () {
      when(mockGetPopularMovies.execute())
          .thenAnswer((_) async => Right(tMovieList));
      return moviesBloc;
    },
    act: (bloc) => bloc.add(GetPopular()),
    wait: const Duration(milliseconds: 100),
    expect: () => [
      moviesBloc.state.copyWith(
          statusPopular: RequestState.Loading,
          resultPopular: []
      ),
      moviesBloc.state.copyWith(
        statusPopular: RequestState.Loaded,
        resultPopular: tMovieList,
      ),
    ],
    verify: (bloc) {
      verify(mockGetPopularMovies.execute());
    },
  );

  blocTest<MoviesBloc, MoviesState>(
    'Should emit [Loading, Error Popular Movie] when get is unsuccessful',
    build: () {
      when(mockGetPopularMovies.execute())
          .thenAnswer((_) async => Left(ServerFailure('Server Failure')));
      return moviesBloc;
    },
    act: (bloc) => bloc.add(GetPopular()),
    wait: const Duration(milliseconds: 100),
    expect: () => [
      moviesBloc.state.copyWith(
        statusPopular: RequestState.Loading,
        failureMessage: null,
      ),
      moviesBloc.state.copyWith(
        statusPopular: RequestState.Error,
        failureMessage: 'Server Failure',
      ),
    ],
    verify: (bloc) {
      verify(mockGetPopularMovies.execute());
    },
  );

  // TOP RATED TEST
  blocTest<MoviesBloc, MoviesState>(
    'Should emit [Loading, HasData for Top Rated Movie] when data is gotten successfully',
    build: () {
      when(mockGetTopRatedMovies.execute())
          .thenAnswer((_) async => Right(tMovieList));
      return moviesBloc;
    },
    act: (bloc) => bloc.add(GetTopRated()),
    wait: const Duration(milliseconds: 100),
    expect: () => [
      moviesBloc.state.copyWith(
          statusTopRated: RequestState.Loading,
          resultTopRated: []
      ),
      moviesBloc.state.copyWith(
        statusTopRated: RequestState.Loaded,
        resultTopRated: tMovieList,
      ),
    ],
    verify: (bloc) {
      verify(mockGetTopRatedMovies.execute());
    },
  );

  blocTest<MoviesBloc, MoviesState>(
    'Should emit [Loading, Error Top Rated Movie] when get is unsuccessful',
    build: () {
      when(mockGetTopRatedMovies.execute())
          .thenAnswer((_) async => Left(ServerFailure('Server Failure')));
      return moviesBloc;
    },
    act: (bloc) => bloc.add(GetTopRated()),
    wait: const Duration(milliseconds: 100),
    expect: () => [
      moviesBloc.state.copyWith(
        statusTopRated: RequestState.Loading,
        failureMessage: null,
      ),
      moviesBloc.state.copyWith(
        statusTopRated: RequestState.Error,
        failureMessage: 'Server Failure',
      ),
    ],
    verify: (bloc) {
      verify(mockGetTopRatedMovies.execute());
    },
  );
}
