import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/usecases/create_event_usecase.dart';
import 'create_event_event.dart';
import 'create_event_state.dart';

class CreateEventBloc extends Bloc<CreateEventEvent, CreateEventState> {
  final CreateEventUseCase createEventUseCase;

  CreateEventBloc({required this.createEventUseCase}) : super(CreateEventInitial()) {
    on<SubmitEventCreation>(_onSubmitEventCreation);
  }

  Future<void> _onSubmitEventCreation(SubmitEventCreation event, Emitter<CreateEventState> emit) async {
    emit(CreateEventLoading());
    final result = await createEventUseCase(CreateEventParams(
      organizerId: event.organizerId, // Use the ID from the event
      title: event.title,
      description: event.description,
      location: event.location,
      eventDate: event.date,
      capacity: event.capacity,
    ));

    result.fold(
          (failure) => emit(CreateEventError(failure.message)),
          (eventData) => emit(CreateEventSuccess(eventData)),
    );
  }
}