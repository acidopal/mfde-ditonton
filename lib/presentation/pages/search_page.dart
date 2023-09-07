import 'package:ditonton/common/constants.dart';
import 'package:ditonton/presentation/bloc/bloc.dart';
import 'package:ditonton/presentation/widgets/movie_card_list.dart';
import 'package:ditonton/presentation/widgets/tv_series_card_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SearchPage extends StatelessWidget {
  static const ROUTE_NAME = '/search';

  final bool isMovie;

  SearchPage({required this.isMovie});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(isMovie ? 'Search Movies' : 'Search TV Series'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              onChanged: (query) {
                context.read<SearchBloc>().add(OnQueryChanged(query, isMovie));
              },
              decoration: InputDecoration(
                hintText: 'Search title',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
              ),
              textInputAction: TextInputAction.search,
            ),
            SizedBox(height: 16),
            Text(
              'Search Result',
              style: kHeading6,
            ),
            BlocBuilder<SearchBloc, SearchState>(
              builder: (context, state) {
                if (state is SearchLoading) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                } else if (state is SearchHasData) {
                  final movies = state.resultMovie;
                  final tvSeriesList = state.resultTVSeries;
                  if (isMovie) {
                    if (movies.isEmpty)
                      return Expanded(
                        child: Center(
                          key: Key('empty_search'),
                          child:
                              Text('What you are looking for was not found :('),
                        ),
                      );
                    return Expanded(
                      child: ListView.builder(
                        padding: const EdgeInsets.all(8),
                        itemBuilder: (context, index) {
                          final movie = movies[index];
                          return MovieCard(movie);
                        },
                        itemCount: movies.length,
                      ),
                    );
                  } else {
                    if (tvSeriesList.isEmpty)
                      return Expanded(
                        child: Center(
                          key: Key('empty_search'),
                          child:
                              Text('What you are looking for was not found :('),
                        ),
                      );
                    return Expanded(
                      child: ListView.builder(
                        padding: const EdgeInsets.all(8),
                        itemBuilder: (context, index) {
                          final tvSeries = tvSeriesList[index];
                          return TVSeriesCard(tvSeries);
                        },
                        itemCount: tvSeriesList.length,
                      ),
                    );
                  }
                } else if (state is SearchError) {
                  return Expanded(
                    child: Center(
                      key: Key('error_search'),
                      child:
                      Text(state.message),
                    ),
                  );
                } else {
                  return Expanded(
                    child: Container(),
                  );
                }
              },
            )
          ],
        ),
      ),
    );
  }
}
