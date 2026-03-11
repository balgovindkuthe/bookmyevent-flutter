import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/event_entity.dart';
import '../../domain/usecases/get_events_usecase.dart';
import 'organizer_event.dart';
import 'organizer_state.dart';

class OrganizerBloc extends Bloc<OrganizerEvent, OrganizerState> {
  final GetEventsUseCase getEventsUseCase;

  OrganizerBloc({required this.getEventsUseCase}) : super(OrganizerInitial()) {
    on<FetchOrganizerEvents>(_onFetchOrganizerEvents);
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
}
