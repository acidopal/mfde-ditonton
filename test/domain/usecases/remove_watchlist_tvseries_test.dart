import 'package:dartz/dartz.dart';
import 'package:ditonton/domain/usecases/remove_watchlist_tv_series.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../dummy_data/dummy_objects.dart';
import '../../helpers/test_helper.mocks.dart';

void main() {
  late RemoveWatchlistTVSeries usecase;
  late MockMovieRepository mockMovieRepository;

  setUp(() {
    mockMovieRepository = MockMovieRepository();
    usecase = RemoveWatchlistTVSeries(mockMovieRepository);
  });

  test('should remove watchlist tv series from repository', () async {
    // arrange
    when(mockMovieRepository.removeWatchlistTVSeries(testTVSeriesDetail))
        .thenAnswer((_) async => Right('Removed from watchlist tv series'));
    // act
    final result = await usecase.execute(testTVSeriesDetail);
    // assert
    verify(mockMovieRepository.removeWatchlistTVSeries(testTVSeriesDetail));
    expect(result, Right('Removed from watchlist tv series'));
  });
}
