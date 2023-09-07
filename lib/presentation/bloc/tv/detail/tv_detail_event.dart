part of 'tv_detail_bloc.dart';

abstract class TVSeriesDetailEvent extends Equatable {
  const TVSeriesDetailEvent();

  @override
  List<Object> get props => [];
}

class OnResetStateTVSeries extends TVSeriesDetailEvent {}

class OnFetchDetailTVSeries extends TVSeriesDetailEvent {
  final int id;

  OnFetchDetailTVSeries({required this.id});

  @override
  List<Object> get props => [id];
}

class OnAddWatchListTVSeries extends TVSeriesDetailEvent {
  final TVSeriesDetail tvSeriesDetail;

  OnAddWatchListTVSeries({required this.tvSeriesDetail});

  @override
  List<Object> get props => [tvSeriesDetail];
}

class OnRemoveWatchListTVSeries extends TVSeriesDetailEvent {
  final TVSeriesDetail tvSeriesDetail;

  OnRemoveWatchListTVSeries({required this.tvSeriesDetail});

  @override
  List<Object> get props => [tvSeriesDetail];
}

class OnLoadWatchListStatusTVSeries extends TVSeriesDetailEvent {
  final int id;

  OnLoadWatchListStatusTVSeries({required this.id});

  @override
  List<Object> get props => [id];
}