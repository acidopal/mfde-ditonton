import 'package:dartz/dartz.dart';
import 'package:ditonton/domain/entities/movie.dart';
import 'package:ditonton/domain/entities/movie_detail.dart';
import 'package:ditonton/common/failure.dart';
import 'package:ditonton/domain/entities/tv_series.dart';
import 'package:ditonton/domain/entities/tv_series_detail.dart';

abstract class MovieRepository {
  Future<Either<Failure, List<Movie>>> getNowPlayingMovies();

  Future<Either<Failure, List<Movie>>> getPopularMovies();

  Future<Either<Failure, List<Movie>>> getTopRatedMovies();

  Future<Either<Failure, MovieDetail>> getMovieDetail(int id);

  Future<Either<Failure, List<Movie>>> getMovieRecommendations(int id);

  Future<Either<Failure, List<Movie>>> searchMovies(String query);

  Future<Either<Failure, String>> saveWatchlist(MovieDetail movie);

  Future<Either<Failure, String>> removeWatchlist(MovieDetail movie);

  Future<bool> isAddedToWatchlist(int id);

  Future<Either<Failure, List<Movie>>> getWatchlistMovies();

  Future<Either<Failure, List<TVSeries>>> getAiringTodayTVSeries();

  Future<Either<Failure, List<TVSeries>>> getPopularTVSeries();

  Future<Either<Failure, List<TVSeries>>> getTopRatedTVSeries();

  Future<Either<Failure, TVSeriesDetail>> getTVSeriesDetail(int id);

  Future<Either<Failure, List<TVSeries>>> getTVSeriesRecommendations(int id);

  Future<Either<Failure, List<TVSeries>>> searchTVSeries(String query);

  Future<Either<Failure, String>> saveWatchlistTVSeries(
      TVSeriesDetail tvSeriesDetail);

  Future<Either<Failure, String>> removeWatchlistTVSeries(
      TVSeriesDetail tvSeriesDetail);

  Future<Either<Failure, List<TVSeries>>> getWatchlistTVSeries();
}
