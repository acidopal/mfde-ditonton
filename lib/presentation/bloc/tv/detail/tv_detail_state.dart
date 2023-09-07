part of 'tv_detail_bloc.dart';

class TVSeriesDetailState extends Equatable {
  const TVSeriesDetailState({
    required this.statusDetail,
    required this.statusRecommendation,
    required this.tvSeries,
    required this.tvSeriesRecommendation,
    required this.isAddedToWatchlist,
    required this.failureMessage,
    required this.watchlistMessage,
  });

  factory TVSeriesDetailState.initial() {
    return TVSeriesDetailState(
      statusDetail: RequestState.Empty,
      statusRecommendation: RequestState.Empty,
      tvSeries: null,
      tvSeriesRecommendation: [],
      isAddedToWatchlist: false,
      failureMessage: null,
      watchlistMessage: null,
    );
  }

  final RequestState statusDetail;
  final RequestState statusRecommendation;
  final List<TVSeries> tvSeriesRecommendation;
  final TVSeriesDetail? tvSeries;
  final bool isAddedToWatchlist;
  final String? failureMessage;
  final String? watchlistMessage;

  TVSeriesDetailState copyWith({
    RequestState? statusDetail,
    RequestState? statusRecommendation,
    List<TVSeries>? tvSeriesRecommendation,
    TVSeriesDetail? tvSeries,
    bool? isAddedToWatchlist,
    String? failureMessage,
    String? watchlistMessage,
  }) {
    return TVSeriesDetailState(
      statusDetail: statusDetail ?? this.statusDetail,
      statusRecommendation: statusRecommendation ?? this.statusRecommendation,
      tvSeriesRecommendation: tvSeriesRecommendation ?? this.tvSeriesRecommendation,
      tvSeries: tvSeries ?? this.tvSeries,
      isAddedToWatchlist: isAddedToWatchlist ?? this.isAddedToWatchlist,
      failureMessage: failureMessage ?? this.failureMessage,
      watchlistMessage: watchlistMessage ?? this.watchlistMessage,
    );
  }

  @override
  List<Object?> get props => [
    statusDetail,
    statusRecommendation,
    tvSeriesRecommendation,
    tvSeries,
    isAddedToWatchlist,
    failureMessage,
    watchlistMessage,
  ];
}
