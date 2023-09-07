
import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:ditonton/common/failure.dart';
import 'package:ditonton/domain/entities/tv_series.dart';
import 'package:ditonton/domain/usecases/get_airing_today_tvseries.dart';
import 'package:ditonton/presentation/bloc/bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'airing_today_bloc_test.mocks.dart';

@GenerateMocks([GetAiringTodayTVSeries])
void main() {
  late AiringTodayBloc airingTodayBloc;
  late MockGetAiringTodayTVSeries mockGetAiringTodayTVSeries;

  setUp(() {
    mockGetAiringTodayTVSeries = MockGetAiringTodayTVSeries();
    airingTodayBloc = AiringTodayBloc(
      getAiringTodayTVSeries: mockGetAiringTodayTVSeries,
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
    expect(airingTodayBloc.state, AiringTodayEmpty());
  });

  // POPULAR TEST
  blocTest<AiringTodayBloc, AiringTodayState>(
    'Should emit [Loading, HasData for AiringToday TVSeries] when data is gotten successfully',
    build: () {
      when(mockGetAiringTodayTVSeries.execute())
          .thenAnswer((_) async => Right(tTVSeriesList));
      return airingTodayBloc;
    },
    act: (bloc) => bloc.add(FetchAiringTodayTVSeries()),
    wait: const Duration(milliseconds: 100),
    expect: () => [
      AiringTodayLoading(),
      AiringTodayHasData(result: tTVSeriesList)
    ],
    verify: (bloc) {
      verify(mockGetAiringTodayTVSeries.execute());
    },
  );

  blocTest<AiringTodayBloc, AiringTodayState>(
    'Should emit [Loading, Error AiringToday TVSeries] when get is unsuccessful',
    build: () {
      when(mockGetAiringTodayTVSeries.execute())
          .thenAnswer((_) async => Left(ServerFailure('Server Failure')));
      return airingTodayBloc;
    },
    act: (bloc) => bloc.add(FetchAiringTodayTVSeries()),
    wait: const Duration(milliseconds: 100),
    expect: () => [
      AiringTodayLoading(),
      AiringTodayError('Server Failure')
    ],
    verify: (bloc) {
      verify(mockGetAiringTodayTVSeries.execute());
    },
  );
}