import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/event_entity.dart';
import '../../domain/usecases/get_events_usecase.dart';
import '../../domain/usecases/delete_event_usecase.dart';
import '../../domain/usecases/publish_event_usecase.dart';
import '../../domain/usecases/cancel_event_usecase.dart';
import 'organizer_event.dart';
import 'organizer_state.dart';

class OrganizerBloc extends Bloc<OrganizerEvent, OrganizerState> {
  final GetEventsUseCase getEventsUseCase;
  final DeleteEventUseCase deleteEventUseCase;
  final PublishEventUseCase publishEventUseCase;
  final CancelEventUseCase cancelEventUseCase;

  OrganizerBloc({
    required this.getEventsUseCase,
    required this.deleteEventUseCase,
    required this.publishEventUseCase,
    required this.cancelEventUseCase,
  }) : super(OrganizerInitial()) {
    on<FetchOrganizerEvents>(_onFetchOrganizerEvents);
    on<DeleteEventRequested>(_onDeleteEventRequested);
    on<PublishEventRequested>(_onPublishEventRequested);
    on<CancelEventRequested>(_onCancelEventRequested);
  }

  Future<void> _onFetchOrganizerEvents(FetchOrganizerEvents event, Emitter<OrganizerState> emit) async {
    if (state is OrganizerLoading) return;

    final currentState = state;
    var oldEvents = <EventEntity>[];
    if (currentState is OrganizerLoaded && event.page > 0) {
      oldEvents = currentState.events;
    } else {
      emit(OrganizerLoading());
    }

    final result = await getEventsUseCase(GetEventsParams(page: event.page, size: event.size));

    result.fold(
      (failure) => emit(OrganizerError(failure.message)),
      (pageEvent) {
        final newEvents = [...oldEvents, ...pageEvent.content];
        emit(OrganizerLoaded(
          events: newEvents,
          hasReachedMax: pageEvent.last,
        ));
      },
    );
  }

  Future<void> _onDeleteEventRequested(DeleteEventRequested event, Emitter<OrganizerState> emit) async {
    final result = await deleteEventUseCase(DeleteEventParams(eventId: event.eventId));
    result.fold(
      (failure) => emit(OrganizerError(failure.message)),
      (_) => emit(EventDeletedSuccess()),
    );
  }

  Future<void> _onPublishEventRequested(PublishEventRequested event, Emitter<OrganizerState> emit) async {
    final result = await publishEventUseCase(PublishEventParams(eventId: event.eventId));
    result.fold(
      (failure) => emit(OrganizerError(failure.message)),
      (eventData) => emit(EventPublishedSuccess(eventData)),
    );
  }

  Future<void> _onCancelEventRequested(CancelEventRequested event, Emitter<OrganizerState> emit) async {
    final result = await cancelEventUseCase(CancelEventParams(eventId: event.eventId, organizerId: event.organizerId));
    result.fold(
      (failure) => emit(OrganizerError(failure.message)),
      (_) => emit(EventCancelledSuccess()),
    );
  }
}
