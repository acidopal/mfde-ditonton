import 'package:ditonton/presentation/bloc/bloc.dart';
import 'package:ditonton/presentation/widgets/tv_series_card_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AiringTodayTVSeriesPage extends StatefulWidget {
  static const ROUTE_NAME = '/airing-today-tvseries';

  @override
  _AiringTodayTVSeriesPageState createState() =>
      _AiringTodayTVSeriesPageState();
}

class _AiringTodayTVSeriesPageState extends State<AiringTodayTVSeriesPage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(
      () => context.read<AiringTodayBloc>().add(
            FetchAiringTodayTVSeries(),
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('AiringToday TV Series'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: BlocBuilder<AiringTodayBloc, AiringTodayState>(
          builder: (context, state) {
            if (state is AiringTodayLoading) {
              return Center(
                child: CircularProgressIndicator(),
              );
            } else if (state is AiringTodayHasData) {
              return ListView.builder(
                itemBuilder: (context, index) {
                  final tvSeries = state.result[index];
                  return TVSeriesCard(tvSeries);
                },
                itemCount: state.result.length,
              );
            } else if (state is AiringTodayError) {
              return Center(
                key: Key('error_message'),
                child: Text(state.message),
              );
            } else {
              return Center(
                key: Key('empty'),
                child: Text(''),
              );
            }
          },
        ),
      ),
    );
  }
}
