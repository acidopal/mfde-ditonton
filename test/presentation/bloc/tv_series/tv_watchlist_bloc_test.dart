
import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:ditonton/common/failure.dart';
import 'package:ditonton/domain/usecases/get_watchlist_tv_series.dart';
import 'package:ditonton/presentation/bloc/bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import '../../../dummy_data/dummy_objects.dart';
import 'tv_watchlist_bloc_test.mocks.dart';

@GenerateMocks([GetWatchlistTVSeries])
void main() {
  late TVWatchlistBloc watchlistBloc;
  late MockGetWatchlistTVSeries mockGetWatchlistTVSeries;

  setUp(() {
    mockGetWatchlistTVSeries = MockGetWatchlistTVSeries();
    watchlistBloc = TVWatchlistBloc(
      getWatchlistTVSeries: mockGetWatchlistTVSeries,
    );
  });

  test('initial state should be empty', () {
    expect(watchlistBloc.state, TVWatchlistEmpty());
  });

  // WATCHLIST MOVIE TEST
  blocTest<TVWatchlistBloc, TVWatchlistState>(
    'Should emit [Loading, HasData for TVWatchlist TVSeries] when data is gotten successfully',
    build: () {
      when(mockGetWatchlistTVSeries.execute())
          .thenAnswer((_) async => Right([testWatchlistTVSeries]));
      return watchlistBloc;
    },
    act: (bloc) => bloc.add(FetchWatchlistTVSeries()),
    wait: const Duration(milliseconds: 100),
    expect: () => [
      TVWatchlistLoading(),
      TVWatchlistHasData(result: [testWatchlistTVSeries])
    ],
    verify: (bloc) {
      verify(mockGetWatchlistTVSeries.execute());
    },
  );

  blocTest<TVWatchlistBloc, TVWatchlistState>(
    'Should emit [Loading, Error TVWatchlist TVSeries] when get is unsuccessful',
    build: () {
      when(mockGetWatchlistTVSeries.execute())
          .thenAnswer((_) async => Left(ServerFailure('Server Failure')));
      return watchlistBloc;
    },
    act: (bloc) => bloc.add(FetchWatchlistTVSeries()),
    wait: const Duration(milliseconds: 100),
    expect: () => [
      TVWatchlistLoading(),
      TVWatchlistError('Server Failure')
    ],
    verify: (bloc) {
      verify(mockGetWatchlistTVSeries.execute());
    },
  );
}