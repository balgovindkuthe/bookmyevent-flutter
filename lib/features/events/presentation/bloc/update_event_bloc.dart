import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/usecases/update_event_usecase.dart';
import 'update_event_event.dart';
import 'update_event_state.dart';

class UpdateEventBloc extends Bloc<UpdateEventEvent, UpdateEventState> {
  final UpdateEventUseCase updateEventUseCase;

  UpdateEventBloc({required this.updateEventUseCase}) : super(UpdateEventInitial()) {
    on<SubmitEventUpdate>(_onSubmitEventUpdate);
  }

  Future<void> _onSubmitEventUpdate(SubmitEventUpdate event, Emitter<UpdateEventState> emit) async {
    emit(UpdateEventLoading());
    final result = await updateEventUseCase(UpdateEventParams(
      eventId: event.eventId,
      title: event.title,
      description: event.description,
      location: event.location,
      eventDate: event.date,
      capacity: event.capacity,
    ));

    result.fold(
      (failure) => emit(UpdateEventError(failure.message)),
      (eventData) => emit(UpdateEventSuccess(eventData)),
    );
  }
}
