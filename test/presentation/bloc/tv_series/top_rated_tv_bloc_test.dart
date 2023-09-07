
import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:ditonton/common/failure.dart';
import 'package:ditonton/domain/entities/tv_series.dart';
import 'package:ditonton/domain/usecases/get_top_rated_tvseries.dart';
import 'package:ditonton/presentation/bloc/bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'top_rated_tv_bloc_test.mocks.dart';


@GenerateMocks([GetTopRatedTVSeries])
void main() {
  late TopRatedTVBloc topRatedTVBloc;
  late MockGetTopRatedTVSeries mockGetTopRatedTVSeries;

  setUp(() {
    mockGetTopRatedTVSeries = MockGetTopRatedTVSeries();
    topRatedTVBloc = TopRatedTVBloc(
      getTopRatedTVSeries: mockGetTopRatedTVSeries,
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
    expect(topRatedTVBloc.state, TopRatedTVEmpty());
  });

  // POPULAR TEST
  blocTest<TopRatedTVBloc, TopRatedTVState>(
    'Should emit [Loading, HasData for TopRated TVSeries] when data is gotten successfully',
    build: () {
      when(mockGetTopRatedTVSeries.execute())
          .thenAnswer((_) async => Right(tTVSeriesList));
      return topRatedTVBloc;
    },
    act: (bloc) => bloc.add(FetchTopRatedTVSeries()),
    wait: const Duration(milliseconds: 100),
    expect: () => [
      TopRatedTVLoading(),
      TopRatedTVHasData(result: tTVSeriesList)
    ],
    verify: (bloc) {
      verify(mockGetTopRatedTVSeries.execute());
    },
  );

  blocTest<TopRatedTVBloc, TopRatedTVState>(
    'Should emit [Loading, Error TopRated TVSeries] when get is unsuccessful',
    build: () {
      when(mockGetTopRatedTVSeries.execute())
          .thenAnswer((_) async => Left(ServerFailure('Server Failure')));
      return topRatedTVBloc;
    },
    act: (bloc) => bloc.add(FetchTopRatedTVSeries()),
    wait: const Duration(milliseconds: 100),
    expect: () => [
      TopRatedTVLoading(),
      TopRatedTVError('Server Failure')
    ],
    verify: (bloc) {
      verify(mockGetTopRatedTVSeries.execute());
    },
  );
}