import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/usecases/get_event_by_id_usecase.dart';
import '../../domain/usecases/get_tiers_usecase.dart';
import 'event_detail_event.dart';
import 'event_detail_state.dart';

class EventDetailBloc extends Bloc<EventDetailEvent, EventDetailState> {
  final GetEventByIdUseCase getEventByIdUseCase;
  final GetTiersForEventUseCase getTiersForEventUseCase;

  EventDetailBloc({
    required this.getEventByIdUseCase,
    required this.getTiersForEventUseCase,
  }) : super(EventDetailInitial()) {
    on<FetchEventDetail>(_onFetchEventDetail);
  }

  Future<void> _onFetchEventDetail(FetchEventDetail event, Emitter<EventDetailState> emit) async {
    emit(EventDetailLoading());

    final eventResult = await getEventByIdUseCase(EventIdParams(id: event.eventId));

    await eventResult.fold(
      (failure) async => emit(EventDetailError(failure.message)),
      (eventData) async {
        final tiersResult = await getTiersForEventUseCase(EventIdParams(id: event.eventId));
        
        tiersResult.fold(
          (failure) => emit(EventDetailError(failure.message)),
          (tiers) => emit(EventDetailLoaded(event: eventData, tiers: tiers)),
        );
      },
    );
  }
}
