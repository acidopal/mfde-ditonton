import 'package:dartz/dartz.dart';
import 'package:ditonton/domain/entities/tv_series.dart';
import 'package:ditonton/domain/usecases/get_tv_series_recommendations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../helpers/test_helper.mocks.dart';

void main() {
  late GetTVSeriesRecommendations usecase;
  late MockMovieRepository mockMovieRepository;

  setUp(() {
    mockMovieRepository = MockMovieRepository();
    usecase = GetTVSeriesRecommendations(mockMovieRepository);
  });

  final tId = 1;
  final tTVSeries = <TVSeries>[];

  test('should get list of tv series recommendations from the repository',
          () async {
        // arrange
        when(mockMovieRepository.getTVSeriesRecommendations(tId))
            .thenAnswer((_) async => Right(tTVSeries));
        // act
        final result = await usecase.execute(tId);
        // assert
        expect(result, Right(tTVSeries));
      });
}
