import 'package:bloc_test/bloc_test.dart';
import 'package:ditonton/presentation/bloc/bloc.dart';
import 'package:ditonton/presentation/pages/top_rated_tvseries_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../dummy_data/dummy_objects.dart';

class MockTopRatedTVBloc extends MockBloc<TopRatedTVEvent, TopRatedTVState>
    implements TopRatedTVBloc {}

void main() {
  late MockTopRatedTVBloc mockTopRatedTVBloc;

  setUp(() {
    mockTopRatedTVBloc = MockTopRatedTVBloc();
  });

  Widget _makeTestableWidget(Widget body) {
    return BlocProvider<TopRatedTVBloc>(
      create: (context) => mockTopRatedTVBloc,
      child: MaterialApp(
        home: body,
      ),
    );
  }

  testWidgets('Page should display progress bar when loading',
          (WidgetTester tester) async {
        when(()=>mockTopRatedTVBloc.state).thenReturn(TopRatedTVLoading());

        final progressFinder = find.byType(CircularProgressIndicator);
        final centerFinder = find.byType(Center);

        await tester.pumpWidget(_makeTestableWidget(TopRatedTVSeriesPage()));

        expect(centerFinder, findsOneWidget);
        expect(progressFinder, findsOneWidget);
      });

  testWidgets('Page should display when data is loaded',
          (WidgetTester tester) async {
        when(()=>mockTopRatedTVBloc.state).thenReturn(TopRatedTVHasData(result: testTVSeriesList));

        final listViewFinder = find.byType(ListView);

        await tester.pumpWidget(_makeTestableWidget(TopRatedTVSeriesPage()));

        expect(listViewFinder, findsOneWidget);
      });

  testWidgets('Page should display text with message when Error',
          (WidgetTester tester) async {
        when(()=>mockTopRatedTVBloc.state).thenReturn(TopRatedTVError('Error message'));

        final textFinder = find.byKey(Key('error_message'));

        await tester.pumpWidget(_makeTestableWidget(TopRatedTVSeriesPage()));

        expect(textFinder, findsOneWidget);
      });
}
