import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/usecases/get_analytics_usecase.dart';
import 'analytics_event.dart';
import 'analytics_state.dart';

class AnalyticsBloc extends Bloc<AnalyticsEvent, AnalyticsState> {
  final GetEventAnalyticsUseCase getEventAnalyticsUseCase;

  AnalyticsBloc({required this.getEventAnalyticsUseCase}) : super(AnalyticsInitial()) {
    on<FetchEventAnalytics>(_onFetchEventAnalytics);
  }

  Future<void> _onFetchEventAnalytics(FetchEventAnalytics event, Emitter<AnalyticsState> emit) async {
    emit(AnalyticsLoading());
    final result = await getEventAnalyticsUseCase(EventIdParams(eventId: event.eventId));
    
    result.fold(
      (failure) => emit(AnalyticsError(failure.message)),
      (analytics) => emit(AnalyticsLoaded(analytics)),
    );
  }
}
