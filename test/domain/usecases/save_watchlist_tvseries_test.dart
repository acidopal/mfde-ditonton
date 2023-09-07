import 'package:dartz/dartz.dart';
import 'package:ditonton/domain/usecases/save_watchlist_tv_series.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../dummy_data/dummy_objects.dart';
import '../../helpers/test_helper.mocks.dart';

void main() {
  late SaveWatchlistTVSeries usecase;
  late MockMovieRepository mockMovieRepository;

  setUp(() {
    mockMovieRepository = MockMovieRepository();
    usecase = SaveWatchlistTVSeries(mockMovieRepository);
  });

  test('should save tv series to the repository', () async {
    // arrange
    when(mockMovieRepository.saveWatchlistTVSeries(testTVSeriesDetail))
        .thenAnswer((_) async => Right('Added to Watchlist TVSeries'));
    // act
    final result = await usecase.execute(testTVSeriesDetail);
    // assert
    verify(mockMovieRepository.saveWatchlistTVSeries(testTVSeriesDetail));
    expect(result, Right('Added to Watchlist TVSeries'));
  });
}
