import 'package:bloc_test/bloc_test.dart';
import 'package:ditonton/common/state_enum.dart';
import 'package:ditonton/presentation/bloc/bloc.dart';
import 'package:ditonton/presentation/pages/movie_detail_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../dummy_data/dummy_objects.dart';

class MockMovieDetail extends MockBloc<MovieDetailEvent, MovieDetailState>
    implements MovieDetailBloc {}

void main() {
  late MockMovieDetail mockMovieDetail;

  setUp(() {
    mockMovieDetail = MockMovieDetail();
  });

  Widget _makeTestableWidget(Widget body) {
    return BlocProvider<MovieDetailBloc>(
      create: (context) => mockMovieDetail,
      child: MaterialApp(
        home: body,
      ),
    );
  }

  testWidgets(
      'Watchlist button should display add icon when movie not added to watchlist',
      (WidgetTester tester) async {
    final initialState = MovieDetailState.initial().copyWith(
      statusDetail: RequestState.Loaded,
      statusRecommendation: RequestState.Loaded,
      movie: testMovieDetail,
      movieRecommendation: testMovieList,
    );
    when(() => mockMovieDetail.stream)
        .thenAnswer((_) => Stream.value(initialState));
    when(() => mockMovieDetail.state).thenReturn(initialState);

    final watchlistButtonIcon = find.byIcon(Icons.add);

    await tester.pumpWidget(_makeTestableWidget(MovieDetailPage(id: 1)));

    expect(watchlistButtonIcon, findsOneWidget);
  });

  testWidgets(
      'Watchlist button should dispay check icon when movie is added to wathclist',
      (WidgetTester tester) async {
    final initialState = MovieDetailState.initial().copyWith(
        statusDetail: RequestState.Loaded,
        statusRecommendation: RequestState.Loaded,
        movie: testMovieDetail,
        movieRecommendation: testMovieList,
        isAddedToWatchlist: true);
    when(() => mockMovieDetail.stream)
        .thenAnswer((_) => Stream.value(initialState));
    when(() => mockMovieDetail.state).thenReturn(initialState);

    final watchlistButtonIcon = find.byIcon(Icons.check);

    await tester.pumpWidget(_makeTestableWidget(MovieDetailPage(id: 1)));

    expect(watchlistButtonIcon, findsOneWidget);
  });

  testWidgets(
      'Watchlist button should display Snackbar when added to watchlist',
      (WidgetTester tester) async {
    final initialState = MovieDetailState.initial().copyWith(
        statusDetail: RequestState.Loaded,
        statusRecommendation: RequestState.Loaded,
        movie: testMovieDetail,
        movieRecommendation: testMovieList,
        isAddedToWatchlist: false,
        watchlistMessage: 'Added to Watchlist');
    when(() => mockMovieDetail.stream)
        .thenAnswer((_) => Stream.value(initialState));
    when(() => mockMovieDetail.state).thenReturn(initialState);

    final watchlistButton = find.byType(ElevatedButton);

    await tester.pumpWidget(_makeTestableWidget(MovieDetailPage(id: 1)));

    expect(find.byIcon(Icons.add), findsOneWidget);

    await tester.tap(watchlistButton);
    await tester.pump();

    expect(find.byType(SnackBar), findsOneWidget);
    expect(find.text('Added to Watchlist'), findsOneWidget);
  });

  testWidgets(
      'Watchlist button should display AlertDialog when add to watchlist failed',
      (WidgetTester tester) async {
    final initialState = MovieDetailState.initial().copyWith(
        statusDetail: RequestState.Loaded,
        statusRecommendation: RequestState.Loaded,
        movie: testMovieDetail,
        movieRecommendation: testMovieList,
        isAddedToWatchlist: false,
        watchlistMessage: 'Failed');
    when(() => mockMovieDetail.stream)
        .thenAnswer((_) => Stream.value(initialState));
    when(() => mockMovieDetail.state).thenReturn(initialState);

    final watchlistButton = find.byType(ElevatedButton);

    await tester.pumpWidget(_makeTestableWidget(MovieDetailPage(id: 1)));

    expect(find.byIcon(Icons.add), findsOneWidget);

    await tester.tap(watchlistButton, warnIfMissed: false);
    await tester.pump();

    expect(find.byType(AlertDialog), findsOneWidget);
    expect(find.text('Failed'), findsOneWidget);
  });
}
