part of 'tv_bloc.dart';

class TVState extends Equatable {
  const TVState({
    required this.statusAiringToday,
    required this.statusPopular,
    required this.statusTopRated,
    required this.resultAiringToday,
    required this.resultPopular,
    required this.resultTopRated,
    required this.failureMessage,
  });

  factory TVState.initial() {
    return const TVState(
      statusAiringToday: RequestState.Empty,
      statusPopular: RequestState.Empty,
      statusTopRated: RequestState.Empty,
      resultAiringToday: [],
      resultPopular: [],
      resultTopRated: [],
      failureMessage: null,
    );
  }

  final RequestState statusAiringToday;
  final RequestState statusPopular;
  final RequestState statusTopRated;
  final List<TVSeries> resultAiringToday;
  final List<TVSeries> resultPopular;
  final List<TVSeries> resultTopRated;
  final String? failureMessage;

  TVState copyWith({
    RequestState? statusAiringToday,
    RequestState? statusPopular,
    RequestState? statusTopRated,
    List<TVSeries>? resultAiringToday,
    List<TVSeries>? resultPopular,
    List<TVSeries>? resultTopRated,
    String? failureMessage,
  }) {
    return TVState(
      statusAiringToday: statusAiringToday ?? this.statusAiringToday,
      statusPopular: statusPopular ?? this.statusPopular,
      statusTopRated: statusTopRated ?? this.statusTopRated,
      resultAiringToday: resultAiringToday ?? this.resultAiringToday,
      resultPopular: resultPopular ?? this.resultPopular,
      resultTopRated: resultTopRated ?? this.resultTopRated,
      failureMessage: failureMessage ?? this.failureMessage,
    );
  }

  @override
  List<Object?> get props => [
    statusAiringToday,
    statusPopular,
    statusTopRated,
    resultAiringToday,
    resultPopular,
    resultTopRated,
    failureMessage,
  ];
}
