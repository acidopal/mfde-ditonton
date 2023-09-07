import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:ditonton/common/failure.dart';
import 'package:ditonton/common/state_enum.dart';
import 'package:ditonton/domain/entities/tv_series.dart';
import 'package:ditonton/domain/usecases/get_tv_series_detail.dart';
import 'package:ditonton/domain/usecases/get_tv_series_recommendations.dart';
import 'package:ditonton/domain/usecases/get_watchlist_status.dart';
import 'package:ditonton/domain/usecases/remove_watchlist_tv_series.dart';
import 'package:ditonton/domain/usecases/save_watchlist_tv_series.dart';
import 'package:ditonton/presentation/bloc/bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import '../../../dummy_data/dummy_objects.dart';
import 'tv_detail_bloc_test.mocks.dart';

@GenerateMocks([
  GetTVSeriesDetail,
  GetTVSeriesRecommendations,
  GetWatchListStatus,
  SaveWatchlistTVSeries,
  RemoveWatchlistTVSeries,
])
void main() {
  late TVSeriesDetailBloc tvSeriesDetailBloc;
  late MockGetTVSeriesDetail mockGetTVSeriesDetail;
  late MockGetTVSeriesRecommendations mockGetTVSeriesRecommendations;
  late MockGetWatchListStatus mockGetWatchListStatus;
  late MockSaveWatchlistTVSeries mockSaveWatchlistTVSeries;
  late MockRemoveWatchlistTVSeries mockRemoveWatchlistTVSeries;

  setUp(() {
    mockGetTVSeriesDetail = MockGetTVSeriesDetail();
    mockGetTVSeriesRecommendations = MockGetTVSeriesRecommendations();
    mockGetWatchListStatus = MockGetWatchListStatus();
    mockSaveWatchlistTVSeries = MockSaveWatchlistTVSeries();
    mockRemoveWatchlistTVSeries = MockRemoveWatchlistTVSeries();
    tvSeriesDetailBloc = TVSeriesDetailBloc(
      getTVSeriesDetail: mockGetTVSeriesDetail,
      getTVSeriesRecommendations: mockGetTVSeriesRecommendations,
      getWatchListStatus: mockGetWatchListStatus,
      saveWatchlist: mockSaveWatchlistTVSeries,
      removeWatchList: mockRemoveWatchlistTVSeries,
    );
  });

  final tId = 1;

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
    expect(tvSeriesDetailBloc.state, TVSeriesDetailState.initial());
  });

  blocTest<TVSeriesDetailBloc, TVSeriesDetailState>(
    'Should emit [Loading, HasData for Detail TVSeries] when data is gotten successfully',
    build: () {
      when(mockGetTVSeriesDetail.execute(tId))
          .thenAnswer((_) async => Right(testTVSeriesDetail));
      when(mockGetTVSeriesRecommendations.execute(tId))
          .thenAnswer((_) async => Right(tTVSeriesList));
      return tvSeriesDetailBloc;
    },
    act: (bloc) => bloc.add(OnFetchDetailTVSeries(id: tId)),
    wait: const Duration(milliseconds: 100),
    expect: () => [
      TVSeriesDetailState.initial().copyWith(
        statusDetail: RequestState.Loading,
      ),
      tvSeriesDetailBloc.state.copyWith(
        statusDetail: RequestState.Loading,
        statusRecommendation: RequestState.Loading,
        tvSeries: testTVSeriesDetail,
        tvSeriesRecommendation: [],
      ),
      tvSeriesDetailBloc.state.copyWith(
        statusDetail: RequestState.Loaded,
        statusRecommendation: RequestState.Loaded,
        tvSeriesRecommendation: tTVSeriesList,
        tvSeries: null,
      ),
    ],
    verify: (bloc) {
      verify(mockGetTVSeriesDetail.execute(tId));
      verify(mockGetTVSeriesRecommendations.execute(tId));
    },
  );

  blocTest<TVSeriesDetailBloc, TVSeriesDetailState>(
    'Should emit [Loading, Error for Detail TVSeries] when data is gotten unsuccessfully',
    build: () {
      when(mockGetTVSeriesDetail.execute(tId))
          .thenAnswer((_) async => Left(ServerFailure('Server Failure')));
      when(mockGetTVSeriesRecommendations.execute(tId))
          .thenAnswer((_) async => Right(tTVSeriesList));
      return tvSeriesDetailBloc;
    },
    act: (bloc) => bloc.add(OnFetchDetailTVSeries(id: tId)),
    wait: const Duration(milliseconds: 100),
    expect: () => [
      TVSeriesDetailState.initial().copyWith(
        statusDetail: RequestState.Loading,
      ),
      tvSeriesDetailBloc.state.copyWith(
          statusDetail: RequestState.Error,
          statusRecommendation: RequestState.Empty,
          failureMessage: 'Server Failure'),
    ],
    verify: (bloc) {
      verify(mockGetTVSeriesDetail.execute(tId));
      verify(mockGetTVSeriesRecommendations.execute(tId));
    },
  );

  blocTest<TVSeriesDetailBloc, TVSeriesDetailState>(
    'Should emit [Loading, Error for Recommendation TVSeries] when data is gotten unsuccessfully',
    build: () {
      when(mockGetTVSeriesDetail.execute(tId))
          .thenAnswer((_) async => Right(testTVSeriesDetail));
      when(mockGetTVSeriesRecommendations.execute(tId))
          .thenAnswer((_) async => Left(ServerFailure('Server Failure')));
      return tvSeriesDetailBloc;
    },
    act: (bloc) => bloc.add(OnFetchDetailTVSeries(id: tId)),
    wait: const Duration(milliseconds: 100),
    expect: () => [
      TVSeriesDetailState.initial().copyWith(
        statusDetail: RequestState.Loading,
      ),
      TVSeriesDetailState.initial().copyWith(
        statusDetail: RequestState.Loading,
        statusRecommendation: RequestState.Loading,
        tvSeries: testTVSeriesDetail,
      ),
      tvSeriesDetailBloc.state.copyWith(
          statusDetail: RequestState.Loading,
          statusRecommendation: RequestState.Error,
          failureMessage: 'Server Failure'),
    ],
    verify: (bloc) {
      verify(mockGetTVSeriesDetail.execute(tId));
      verify(mockGetTVSeriesRecommendations.execute(tId));
    },
  );

  blocTest<TVSeriesDetailBloc, TVSeriesDetailState>(
    'Should emit [Success added Watchlist TVSeries] when data is gotten successfully',
    build: () {
      when(mockSaveWatchlistTVSeries.execute(testTVSeriesDetail))
          .thenAnswer((_) async => Right('Success'));
      when(mockGetWatchListStatus.execute(testTVSeriesDetail.id))
          .thenAnswer((_) async => true);
      return tvSeriesDetailBloc;
    },
    act: (bloc) => bloc.add(OnAddWatchListTVSeries(tvSeriesDetail: testTVSeriesDetail)),
    wait: const Duration(milliseconds: 100),
    expect: () => [
      tvSeriesDetailBloc.state.copyWith(
        isAddedToWatchlist: false,
        watchlistMessage: 'Success',
      ),
      TVSeriesDetailState.initial().copyWith(
        isAddedToWatchlist: true,
      )
    ],
    verify: (bloc) {
      verify(mockSaveWatchlistTVSeries.execute(testTVSeriesDetail));
      verify(mockGetWatchListStatus.execute(testTVSeriesDetail.id));
    },
  );

  blocTest<TVSeriesDetailBloc, TVSeriesDetailState>(
    'Should emit [Failed added Watchlist TVSeries] when data is gotten unsuccessfully',
    build: () {
      when(mockSaveWatchlistTVSeries.execute(testTVSeriesDetail))
          .thenAnswer((_) async => Left(DatabaseFailure('Failed')));
      when(mockGetWatchListStatus.execute(testTVSeriesDetail.id))
          .thenAnswer((_) async => false);
      return tvSeriesDetailBloc;
    },
    act: (bloc) => bloc.add(OnAddWatchListTVSeries(tvSeriesDetail: testTVSeriesDetail)),
    wait: const Duration(milliseconds: 100),
    expect: () => [
      tvSeriesDetailBloc.state.copyWith(
        isAddedToWatchlist: false,
        watchlistMessage: 'Failed',
      ),
      TVSeriesDetailState.initial()
    ],
    verify: (bloc) {
      verify(mockSaveWatchlistTVSeries.execute(testTVSeriesDetail));
      verify(mockGetWatchListStatus.execute(testTVSeriesDetail.id));
    },
  );

  blocTest<TVSeriesDetailBloc, TVSeriesDetailState>(
    'Should emit [Success removed Watchlist TVSeries] when data is gotten successfully',
    build: () {
      when(mockRemoveWatchlistTVSeries.execute(testTVSeriesDetail))
          .thenAnswer((_) async => Right('Removed'));
      when(mockGetWatchListStatus.execute(testTVSeriesDetail.id))
          .thenAnswer((_) async => false);
      return tvSeriesDetailBloc;
    },
    act: (bloc) => bloc.add(OnRemoveWatchListTVSeries(tvSeriesDetail: testTVSeriesDetail)),
    wait: const Duration(milliseconds: 100),
    expect: () => [
      tvSeriesDetailBloc.state.copyWith(
        isAddedToWatchlist: false,
        watchlistMessage: 'Removed',
      ),
      TVSeriesDetailState.initial()
    ],
    verify: (bloc) {
      verify(mockRemoveWatchlistTVSeries.execute(testTVSeriesDetail));
      verify(mockGetWatchListStatus.execute(testTVSeriesDetail.id));
    },
  );

  blocTest<TVSeriesDetailBloc, TVSeriesDetailState>(
    'Should emit [Failed removed Watchlist TVSeries] when data is gotten unsuccessfully',
    build: () {
      when(mockRemoveWatchlistTVSeries.execute(testTVSeriesDetail))
          .thenAnswer((_) async => Left(DatabaseFailure('Failed')));
      when(mockGetWatchListStatus.execute(testTVSeriesDetail.id))
          .thenAnswer((_) async => false);
      return tvSeriesDetailBloc;
    },
    act: (bloc) => bloc.add(OnRemoveWatchListTVSeries(tvSeriesDetail: testTVSeriesDetail)),
    wait: const Duration(milliseconds: 100),
    expect: () => [
      tvSeriesDetailBloc.state.copyWith(
        isAddedToWatchlist: false,
        watchlistMessage: 'Failed',
      ),
      TVSeriesDetailState.initial()
    ],
    verify: (bloc) {
      verify(mockRemoveWatchlistTVSeries.execute(testTVSeriesDetail));
      verify(mockGetWatchListStatus.execute(testTVSeriesDetail.id));
    },
  );

  blocTest<TVSeriesDetailBloc, TVSeriesDetailState>(
    'Should emit [Success Get Status with true value Watchlist TVSeries] when data is gotten successfully',
    build: () {
      when(mockGetWatchListStatus.execute(testTVSeriesDetail.id))
          .thenAnswer((_) async => true);
      return tvSeriesDetailBloc;
    },
    act: (bloc) => bloc.add(OnLoadWatchListStatusTVSeries(id: testTVSeriesDetail.id)),
    wait: const Duration(milliseconds: 100),
    expect: () => [
      tvSeriesDetailBloc.state.copyWith(
        isAddedToWatchlist: true,
      ),
    ],
    verify: (bloc) {
      verify(mockGetWatchListStatus.execute(testTVSeriesDetail.id));
    },
  );

  blocTest<TVSeriesDetailBloc, TVSeriesDetailState>(
    'Should emit [Success Get Status with false value Watchlist TVSeries] when data is gotten successfully',
    build: () {
      when(mockGetWatchListStatus.execute(testTVSeriesDetail.id))
          .thenAnswer((_) async => false);
      return tvSeriesDetailBloc;
    },
    act: (bloc) => bloc.add(OnLoadWatchListStatusTVSeries(id: testTVSeriesDetail.id)),
    wait: const Duration(milliseconds: 100),
    expect: () => [
      tvSeriesDetailBloc.state.copyWith(
        isAddedToWatchlist: false,
      ),
    ],
    verify: (bloc) {
      verify(mockGetWatchListStatus.execute(testTVSeriesDetail.id));
    },
  );
}
