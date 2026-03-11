import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/usecases/get_tiers_usecase.dart';
import '../../domain/usecases/create_tier_usecase.dart';
import '../../domain/usecases/get_event_by_id_usecase.dart';
import 'ticket_tier_event.dart';
import 'ticket_tier_state.dart';

class TicketTierBloc extends Bloc<TicketTierEvent, TicketTierState> {
  final GetTiersForEventUseCase getTiersUseCase;
  final CreateTicketTierUseCase createTierUseCase;

  TicketTierBloc({
    required this.getTiersUseCase,
    required this.createTierUseCase,
  }) : super(TicketTierInitial()) {
    on<FetchTicketTiers>(_onFetchTicketTiers);
    on<CreateTicketTierRequested>(_onCreateTicketTierRequested);
  }

  Future<void> _onFetchTicketTiers(FetchTicketTiers event, Emitter<TicketTierState> emit) async {
    emit(TicketTierLoading());
    final result = await getTiersUseCase(EventIdParams(id: event.eventId));
    result.fold(
      (failure) => emit(TicketTierError(failure.message)),
      (tiers) => emit(TicketTiersLoaded(tiers)),
    );
  }

  Future<void> _onCreateTicketTierRequested(CreateTicketTierRequested event, Emitter<TicketTierState> emit) async {
    emit(TicketTierLoading());
    final result = await createTierUseCase(
      CreateTierParams(eventId: event.eventId, name: event.name, price: event.price, capacity: event.capacity),
    );
    result.fold(
      (failure) => emit(TicketTierError(failure.message)),
      (_) {
        emit(TicketTierCreationSuccess());
        add(FetchTicketTiers(event.eventId));
      },
    );
  }
}
