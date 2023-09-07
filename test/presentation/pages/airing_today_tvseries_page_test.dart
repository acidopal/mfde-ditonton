import 'package:bloc_test/bloc_test.dart';
import 'package:ditonton/presentation/bloc/bloc.dart';
import 'package:ditonton/presentation/pages/airing_today_tvseries_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../dummy_data/dummy_objects.dart';


class MockAiringTodayBloc
    extends MockBloc<AiringTodayEvent, AiringTodayState>
    implements AiringTodayBloc {}

class AiringTodayEventFake extends Fake implements AiringTodayEvent {}

class AiringTodayStateFake extends Fake implements AiringTodayState {}

void main() {
  late MockAiringTodayBloc mockAiringTodayBloc;

  setUp(() {
    mockAiringTodayBloc = MockAiringTodayBloc();
  });

  Widget _makeTestableWidget(Widget body) {
    return BlocProvider<AiringTodayBloc>(
      create: (context) => mockAiringTodayBloc,
      child: MaterialApp(
        home: body,
      ),
    );
  }

  testWidgets('Page should display center progress bar when loading',
          (WidgetTester tester) async {
        when(()=>mockAiringTodayBloc.state).thenReturn(AiringTodayLoading());

        final progressBarFinder = find.byType(CircularProgressIndicator);
        final centerFinder = find.byType(Center);

        await tester.pumpWidget(_makeTestableWidget(AiringTodayTVSeriesPage()));

        expect(centerFinder, findsOneWidget);
        expect(progressBarFinder, findsOneWidget);
      });

  testWidgets('Page should display ListView when data is loaded',
          (WidgetTester tester) async {
        when(()=>mockAiringTodayBloc.state).thenReturn(AiringTodayHasData(result: testTVSeriesList));

        final listViewFinder = find.byType(ListView);

        await tester.pumpWidget(_makeTestableWidget(AiringTodayTVSeriesPage()));

        expect(listViewFinder, findsOneWidget);
      });

  testWidgets('Page should display text with message when Error',
          (WidgetTester tester) async {
        when(()=>mockAiringTodayBloc.state).thenReturn(AiringTodayError('Error message'));

        final textFinder = find.byKey(Key('error_message'));

        await tester.pumpWidget(_makeTestableWidget(AiringTodayTVSeriesPage()));

        expect(textFinder, findsOneWidget);
      });
}
