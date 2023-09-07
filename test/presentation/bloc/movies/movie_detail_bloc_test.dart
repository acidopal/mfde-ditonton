import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:ditonton/common/failure.dart';
import 'package:ditonton/common/state_enum.dart';
import 'package:ditonton/domain/entities/movie.dart';
import 'package:ditonton/domain/usecases/get_movie_detail.dart';
import 'package:ditonton/domain/usecases/get_movie_recommendations.dart';
import 'package:ditonton/domain/usecases/get_watchlist_status.dart';
import 'package:ditonton/domain/usecases/remove_watchlist.dart';
import 'package:ditonton/domain/usecases/save_watchlist.dart';
import 'package:ditonton/presentation/bloc/bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import '../../../dummy_data/dummy_objects.dart';
import 'movie_detail_bloc_test.mocks.dart';

@GenerateMocks([
  GetMovieDetail,
  GetMovieRecommendations,
  GetWatchListStatus,
  SaveWatchlist,
  RemoveWatchlist,
])
void main() {
  late MovieDetailBloc moviesDetailBloc;
  late MockGetMovieDetail mockGetMovieDetail;
  late MockGetMovieRecommendations mockGetMovieRecommendations;
  late MockGetWatchListStatus mockGetWatchlistStatus;
  late MockSaveWatchlist mockSaveWatchlist;
  late MockRemoveWatchlist mockRemoveWatchlist;

  setUp(() {
    mockGetMovieDetail = MockGetMovieDetail();
    mockGetMovieRecommendations = MockGetMovieRecommendations();
    mockGetWatchlistStatus = MockGetWatchListStatus();
    mockSaveWatchlist = MockSaveWatchlist();
    mockRemoveWatchlist = MockRemoveWatchlist();
    moviesDetailBloc = MovieDetailBloc(
      getDetailMovie: mockGetMovieDetail,
      getRecommendation: mockGetMovieRecommendations,
      getWatchListStatus: mockGetWatchlistStatus,
      saveWatchlist: mockSaveWatchlist,
      removeWatchList: mockRemoveWatchlist,
    );
  });

  final tId = 1;

  final tMovie = Movie(
    adult: false,
    backdropPath: 'backdropPath',
    genreIds: [1, 2, 3],
    id: 1,
    originalTitle: 'originalTitle',
    overview: 'overview',
    popularity: 1,
    posterPath: 'posterPath',
    releaseDate: 'releaseDate',
    title: 'title',
    video: false,
    voteAverage: 1,
    voteCount: 1,
  );
  final tMovies = <Movie>[tMovie];

  test('initial state should be empty', () {
    expect(moviesDetailBloc.state, MovieDetailState.initial());
  });

  blocTest<MovieDetailBloc, MovieDetailState>(
    'Should emit [Loading, HasData for Detail Movie] when data is gotten successfully',
    build: () {
      when(mockGetMovieDetail.execute(tId))
          .thenAnswer((_) async => Right(testMovieDetail));
      when(mockGetMovieRecommendations.execute(tId))
          .thenAnswer((_) async => Right(tMovies));
      return moviesDetailBloc;
    },
    act: (bloc) => bloc.add(OnFetchDetailMovie(id: tId)),
    wait: const Duration(milliseconds: 100),
    expect: () => [
      MovieDetailState.initial().copyWith(
        statusDetail: RequestState.Loading,
      ),
      moviesDetailBloc.state.copyWith(
        statusDetail: RequestState.Loading,
        statusRecommendation: RequestState.Loading,
        movie: testMovieDetail,
        movieRecommendation: [],
      ),
      moviesDetailBloc.state.copyWith(
        statusDetail: RequestState.Loaded,
        statusRecommendation: RequestState.Loaded,
        movieRecommendation: tMovies,
        movie: null,
      ),
    ],
    verify: (bloc) {
      verify(mockGetMovieDetail.execute(tId));
      verify(mockGetMovieRecommendations.execute(tId));
    },
  );

  blocTest<MovieDetailBloc, MovieDetailState>(
    'Should emit [Loading, Error for Detail Movie] when data is gotten unsuccessfully',
    build: () {
      when(mockGetMovieDetail.execute(tId))
          .thenAnswer((_) async => Left(ServerFailure('Server Failure')));
      when(mockGetMovieRecommendations.execute(tId))
          .thenAnswer((_) async => Right(tMovies));
      return moviesDetailBloc;
    },
    act: (bloc) => bloc.add(OnFetchDetailMovie(id: tId)),
    wait: const Duration(milliseconds: 100),
    expect: () => [
      MovieDetailState.initial().copyWith(
        statusDetail: RequestState.Loading,
      ),
      moviesDetailBloc.state.copyWith(
          statusDetail: RequestState.Error,
          statusRecommendation: RequestState.Empty,
          failureMessage: 'Server Failure'),
    ],
    verify: (bloc) {
      verify(mockGetMovieDetail.execute(tId));
      verify(mockGetMovieRecommendations.execute(tId));
    },
  );

  blocTest<MovieDetailBloc, MovieDetailState>(
    'Should emit [Loading, Error for Recommendation Movie] when data is gotten unsuccessfully',
    build: () {
      when(mockGetMovieDetail.execute(tId))
          .thenAnswer((_) async => Right(testMovieDetail));
      when(mockGetMovieRecommendations.execute(tId))
          .thenAnswer((_) async => Left(ServerFailure('Server Failure')));
      return moviesDetailBloc;
    },
    act: (bloc) => bloc.add(OnFetchDetailMovie(id: tId)),
    wait: const Duration(milliseconds: 100),
    expect: () => [
      MovieDetailState.initial().copyWith(
        statusDetail: RequestState.Loading,
      ),
      MovieDetailState.initial().copyWith(
        statusDetail: RequestState.Loading,
        statusRecommendation: RequestState.Loading,
        movie: testMovieDetail,
      ),
      moviesDetailBloc.state.copyWith(
          statusDetail: RequestState.Loading,
          statusRecommendation: RequestState.Error,
          failureMessage: 'Server Failure'),
    ],
    verify: (bloc) {
      verify(mockGetMovieDetail.execute(tId));
      verify(mockGetMovieRecommendations.execute(tId));
    },
  );

  blocTest<MovieDetailBloc, MovieDetailState>(
    'Should emit [Success added Watchlist Movie] when data is gotten successfully',
    build: () {
      when(mockSaveWatchlist.execute(testMovieDetail))
          .thenAnswer((_) async => Right('Success'));
      when(mockGetWatchlistStatus.execute(testMovieDetail.id))
          .thenAnswer((_) async => true);
      return moviesDetailBloc;
    },
    act: (bloc) => bloc.add(OnAddWatchList(movieDetail: testMovieDetail)),
    wait: const Duration(milliseconds: 100),
    expect: () => [
      moviesDetailBloc.state.copyWith(
        isAddedToWatchlist: false,
        watchlistMessage: 'Success',
      ),
      moviesDetailBloc.state.copyWith(
        isAddedToWatchlist: true,
      ),
    ],
    verify: (bloc) {
      verify(mockSaveWatchlist.execute(testMovieDetail));
      verify(mockGetWatchlistStatus.execute(testMovieDetail.id));
    },
  );

  blocTest<MovieDetailBloc, MovieDetailState>(
    'Should emit [Failed added Watchlist Movie] when data is gotten unsuccessfully',
    build: () {
      when(mockSaveWatchlist.execute(testMovieDetail))
          .thenAnswer((_) async => Left(DatabaseFailure('Failed')));
      when(mockGetWatchlistStatus.execute(testMovieDetail.id))
          .thenAnswer((_) async => false);
      return moviesDetailBloc;
    },
    act: (bloc) => bloc.add(OnAddWatchList(movieDetail: testMovieDetail)),
    wait: const Duration(milliseconds: 100),
    expect: () => [
      MovieDetailState.initial().copyWith(
        isAddedToWatchlist: false,
        watchlistMessage: 'Failed',
      ),
      MovieDetailState.initial()
    ],
    verify: (bloc) {
      verify(mockSaveWatchlist.execute(testMovieDetail));
      verify(mockGetWatchlistStatus.execute(testMovieDetail.id));
    },
  );

  blocTest<MovieDetailBloc, MovieDetailState>(
    'Should emit [Success removed Watchlist Movie] when data is gotten successfully',
    build: () {
      when(mockRemoveWatchlist.execute(testMovieDetail))
          .thenAnswer((_) async => Right('Removed'));
      when(mockGetWatchlistStatus.execute(testMovieDetail.id))
          .thenAnswer((_) async => false);
      return moviesDetailBloc;
    },
    act: (bloc) => bloc.add(OnRemoveWatchList(movieDetail: testMovieDetail)),
    wait: const Duration(milliseconds: 100),
    expect: () => [
      MovieDetailState.initial().copyWith(
        isAddedToWatchlist: false,
        watchlistMessage: 'Removed',
      ),
      MovieDetailState.initial()
    ],
    verify: (bloc) {
      verify(mockRemoveWatchlist.execute(testMovieDetail));
      verify(mockGetWatchlistStatus.execute(testMovieDetail.id));
    },
  );

  blocTest<MovieDetailBloc, MovieDetailState>(
    'Should emit [Failed removed Watchlist Movie] when data is gotten unsuccessfully',
    build: () {
      when(mockRemoveWatchlist.execute(testMovieDetail))
          .thenAnswer((_) async => Left(DatabaseFailure('Failed')));
      when(mockGetWatchlistStatus.execute(testMovieDetail.id))
          .thenAnswer((_) async => false);
      return moviesDetailBloc;
    },
    act: (bloc) => bloc.add(OnRemoveWatchList(movieDetail: testMovieDetail)),
    wait: const Duration(milliseconds: 100),
    expect: () => [
      moviesDetailBloc.state.copyWith(
        isAddedToWatchlist: false,
        watchlistMessage: 'Failed',
      ),
      MovieDetailState.initial()
    ],
    verify: (bloc) {
      verify(mockRemoveWatchlist.execute(testMovieDetail));
      verify(mockGetWatchlistStatus.execute(testMovieDetail.id));
    },
  );

  blocTest<MovieDetailBloc, MovieDetailState>(
    'Should emit [Success Get Status with true value Watchlist Movie] when data is gotten successfully',
    build: () {
      when(mockGetWatchlistStatus.execute(testMovieDetail.id))
          .thenAnswer((_) async => true);
      return moviesDetailBloc;
    },
    act: (bloc) => bloc.add(OnLoadWatchListStatus(id: testMovieDetail.id)),
    wait: const Duration(milliseconds: 100),
    expect: () => [
      moviesDetailBloc.state.copyWith(
        isAddedToWatchlist: true,
      ),
    ],
    verify: (bloc) {
      verify(mockGetWatchlistStatus.execute(testMovieDetail.id));
    },
  );

  blocTest<MovieDetailBloc, MovieDetailState>(
    'Should emit [Success Get Status with false value Watchlist Movie] when data is gotten successfully',
    build: () {
      when(mockGetWatchlistStatus.execute(testMovieDetail.id))
          .thenAnswer((_) async => false);
      return moviesDetailBloc;
    },
    act: (bloc) => bloc.add(OnLoadWatchListStatus(id: testMovieDetail.id)),
    wait: const Duration(milliseconds: 100),
    expect: () => [
      moviesDetailBloc.state.copyWith(
        isAddedToWatchlist: false,
      ),
    ],
    verify: (bloc) {
      verify(mockGetWatchlistStatus.execute(testMovieDetail.id));
    },
  );
}
