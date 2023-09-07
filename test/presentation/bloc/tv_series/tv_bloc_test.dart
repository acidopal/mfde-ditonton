import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:ditonton/common/failure.dart';
import 'package:ditonton/common/state_enum.dart';
import 'package:ditonton/domain/entities/tv_series.dart';
import 'package:ditonton/domain/usecases/get_airing_today_tvseries.dart';
import 'package:ditonton/domain/usecases/get_popular_tvseries.dart';
import 'package:ditonton/domain/usecases/get_top_rated_tvseries.dart';
import 'package:ditonton/presentation/bloc/bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'tv_bloc_test.mocks.dart';

@GenerateMocks([GetAiringTodayTVSeries, GetPopularTVSeries, GetTopRatedTVSeries])
void main() {
  late TVBloc tvBloc;
  late MockGetAiringTodayTVSeries mockGetAiringTodayTVSeries;
  late MockGetPopularTVSeries mockGetPopularTVSeries;
  late MockGetTopRatedTVSeries mockGetTopRatedTVSeries;

  setUp(() {
    mockGetAiringTodayTVSeries = MockGetAiringTodayTVSeries();
    mockGetPopularTVSeries = MockGetPopularTVSeries();
    mockGetTopRatedTVSeries = MockGetTopRatedTVSeries();
    tvBloc = TVBloc(
      getAiringTodayTVSeries: mockGetAiringTodayTVSeries,
      getPopularTV: mockGetPopularTVSeries,
      getTopRatedTV: mockGetTopRatedTVSeries,
    );
  });

  final tTVSeriesModel = TVSeries(
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
    voteAverage: 7.2,
    voteCount: 13507,
  );
  final tTVSeriesList = <TVSeries>[tTVSeriesModel];

  test('initial state should be empty', () {
    expect(tvBloc.state, TVState.initial());
  });

  // NOW PLAYING TEST
  blocTest<TVBloc, TVState>(
    'Should emit [Loading, HasData for Airing Today TVSeries] when data is gotten successfully',
    build: () {
      when(mockGetAiringTodayTVSeries.execute())
          .thenAnswer((_) async => Right(tTVSeriesList));
      return tvBloc;
    },
    act: (bloc) => bloc.add(OnFetchAiringToday()),
    wait: const Duration(milliseconds: 100),
    expect: () => [
      TVState.initial().copyWith(
          statusAiringToday: RequestState.Loading,
      ),
      tvBloc.state.copyWith(
        statusAiringToday: RequestState.Loaded,
        resultAiringToday: tTVSeriesList,
      ),
    ],
    verify: (bloc) {
      verify(mockGetAiringTodayTVSeries.execute());
    },
  );

  blocTest<TVBloc, TVState>(
    'Should emit [Loading, Error AiringToday TVSeries] when get is unsuccessful',
    build: () {
      when(mockGetAiringTodayTVSeries.execute())
          .thenAnswer((_) async => Left(ServerFailure('Server Failure')));
      return tvBloc;
    },
    act: (bloc) => bloc.add(OnFetchAiringToday()),
    wait: const Duration(milliseconds: 100),
    expect: () => [
      TVState.initial().copyWith(
        statusAiringToday: RequestState.Loading,
      ),
      tvBloc.state.copyWith(
        statusAiringToday: RequestState.Error,
        failureMessage: 'Server Failure',
      ),
    ],
    verify: (bloc) {
      verify(mockGetAiringTodayTVSeries.execute());
    },
  );

  // POPULAR TEST
  blocTest<TVBloc, TVState>(
    'Should emit [Loading, HasData for Popular TVSeries] when data is gotten successfully',
    build: () {
      when(mockGetPopularTVSeries.execute())
          .thenAnswer((_) async => Right(tTVSeriesList));
      return tvBloc;
    },
    act: (bloc) => bloc.add(OnFetchPopular()),
    wait: const Duration(milliseconds: 100),
    expect: () => [
      TVState.initial().copyWith(
          statusPopular: RequestState.Loading,
      ),
      tvBloc.state.copyWith(
        statusPopular: RequestState.Loaded,
        resultPopular: tTVSeriesList,
      ),
    ],
    verify: (bloc) {
      verify(mockGetPopularTVSeries.execute());
    },
  );

  blocTest<TVBloc, TVState>(
    'Should emit [Loading, Error Popular TVSeries] when get is unsuccessful',
    build: () {
      when(mockGetPopularTVSeries.execute())
          .thenAnswer((_) async => Left(ServerFailure('Server Failure')));
      return tvBloc;
    },
    act: (bloc) => bloc.add(OnFetchPopular()),
    wait: const Duration(milliseconds: 100),
    expect: () => [
      TVState.initial().copyWith(
        statusPopular: RequestState.Loading,
      ),
      tvBloc.state.copyWith(
        statusPopular: RequestState.Error,
        failureMessage: 'Server Failure',
      ),
    ],
    verify: (bloc) {
      verify(mockGetPopularTVSeries.execute());
    },
  );

  // TOP RATED TEST
  blocTest<TVBloc, TVState>(
    'Should emit [Loading, HasData for Top Rated TVSeries] when data is gotten successfully',
    build: () {
      when(mockGetTopRatedTVSeries.execute())
          .thenAnswer((_) async => Right(tTVSeriesList));
      return tvBloc;
    },
    act: (bloc) => bloc.add(OnFetchTopRated()),
    wait: const Duration(milliseconds: 100),
    expect: () => [
      TVState.initial().copyWith(
          statusTopRated: RequestState.Loading,
      ),
      tvBloc.state.copyWith(
        statusTopRated: RequestState.Loaded,
        resultTopRated: tTVSeriesList,
      ),
    ],
    verify: (bloc) {
      verify(mockGetTopRatedTVSeries.execute());
    },
  );

  blocTest<TVBloc, TVState>(
    'Should emit [Loading, Error Top Rated TVSeries] when get is unsuccessful',
    build: () {
      when(mockGetTopRatedTVSeries.execute())
          .thenAnswer((_) async => Left(ServerFailure('Server Failure')));
      return tvBloc;
    },
    act: (bloc) => bloc.add(OnFetchTopRated()),
    wait: const Duration(milliseconds: 100),
    expect: () => [
      TVState.initial().copyWith(
        statusTopRated: RequestState.Loading,
      ),
      tvBloc.state.copyWith(
        statusTopRated: RequestState.Error,
        failureMessage: 'Server Failure',
      ),
    ],
    verify: (bloc) {
      verify(mockGetTopRatedTVSeries.execute());
    },
  );
}
