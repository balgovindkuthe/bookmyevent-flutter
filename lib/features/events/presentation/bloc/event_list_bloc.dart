import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/event_entity.dart';
import '../../domain/usecases/get_events_usecase.dart';
import 'event_list_event.dart';
import 'event_list_state.dart';

class EventListBloc extends Bloc<EventListEvent, EventListState> {
  final GetEventsUseCase getEventsUseCase;

  EventListBloc({required this.getEventsUseCase}) : super(EventListInitial()) {
    on<FetchEvents>(_onFetchEvents);
    on<RefreshEvents>(_onRefreshEvents);
  }

  Future<void> _onFetchEvents(FetchEvents event, Emitter<EventListState> emit) async {
    if (state is EventListLoading) return;

    final currentState = state;
    var oldEvents = <EventEntity>[];
    if (currentState is EventListLoaded && event.page > 0) {
      oldEvents = currentState.events;
    } else {
      emit(EventListLoading());
    }

    final result = await getEventsUseCase(GetEventsParams(page: event.page, size: event.size));

    result.fold(
      (failure) => emit(EventListError(failure.message)),
      (pageEvent) {
        final newEvents = [...oldEvents, ...pageEvent.content];
        emit(EventListLoaded(
          events: newEvents,
          hasReachedMax: pageEvent.last,
        ));
      },
    );
  }

  Future<void> _onRefreshEvents(RefreshEvents event, Emitter<EventListState> emit) async {
    emit(EventListLoading());
    final result = await getEventsUseCase(const GetEventsParams(page: 0, size: 10));
    result.fold(
      (failure) => emit(EventListError(failure.message)),
      (pageEvent) {
        emit(EventListLoaded(
          events: pageEvent.content,
          hasReachedMax: pageEvent.last,
        ));
      },
    );
  }
}
