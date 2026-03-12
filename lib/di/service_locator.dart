import 'package:get_it/get_it.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../core/network/api_client.dart';
import '../features/auth/data/datasources/auth_remote_datasource.dart';
import '../features/auth/data/repositories/auth_repository_impl.dart';
import '../features/auth/domain/repositories/auth_repository.dart';
import '../features/auth/domain/usecases/login_usecase.dart';
import '../features/auth/domain/usecases/register_usecase.dart';
import '../features/auth/domain/usecases/logout_usecase.dart';
import '../features/auth/domain/usecases/check_logged_in_usecase.dart';
import '../features/auth/presentation/bloc/auth_bloc.dart';

// Events Feature
import '../features/events/data/datasources/event_remote_datasource.dart';
import '../features/events/data/repositories/event_repository_impl.dart';
import '../features/events/domain/repositories/event_repository.dart';
import '../features/events/domain/usecases/get_events_usecase.dart';
import '../features/events/domain/usecases/get_event_by_id_usecase.dart';
import '../features/events/domain/usecases/create_event_usecase.dart';
import '../features/events/domain/usecases/update_event_usecase.dart';
import '../features/events/domain/usecases/publish_event_usecase.dart';
import '../features/events/domain/usecases/delete_event_usecase.dart';
import '../features/events/domain/usecases/get_tiers_usecase.dart';
import '../features/events/domain/usecases/create_tier_usecase.dart';
import '../features/events/presentation/bloc/event_list_bloc.dart';
import '../features/events/presentation/bloc/event_detail_bloc.dart';
import '../features/events/presentation/bloc/organizer_bloc.dart';
import '../features/events/presentation/bloc/create_event_bloc.dart';
import '../features/events/presentation/bloc/update_event_bloc.dart';
import '../features/events/presentation/bloc/ticket_tier_bloc.dart';

// Bookings Feature
import '../features/bookings/data/datasources/booking_remote_datasource.dart';
import '../features/bookings/data/repositories/booking_repository_impl.dart';
import '../features/bookings/domain/repositories/booking_repository.dart';
import '../features/bookings/domain/usecases/create_booking_usecase.dart';
import '../features/bookings/domain/usecases/get_booking_by_id_usecase.dart';
import '../features/bookings/domain/usecases/get_my_bookings_usecase.dart';
import '../features/bookings/domain/usecases/payment_success_usecase.dart';
import '../features/bookings/domain/usecases/cancel_booking_usecase.dart';
import '../features/bookings/presentation/bloc/booking_bloc.dart';

// CheckIn Feature
import '../features/qr_checkin/data/datasources/checkin_remote_datasource.dart';
import '../features/qr_checkin/data/repositories/checkin_repository_impl.dart';
import '../features/qr_checkin/domain/repositories/checkin_repository.dart';
import '../features/qr_checkin/domain/usecases/scan_qrcode_usecase.dart';
import '../features/qr_checkin/presentation/bloc/checkin_bloc.dart';

// Analytics Feature
import '../features/analytics/data/datasources/analytics_remote_datasource.dart';
import '../features/analytics/data/repositories/analytics_repository_impl.dart';
import '../features/analytics/domain/repositories/analytics_repository.dart';
import '../features/analytics/domain/usecases/get_analytics_usecase.dart';
import '../features/analytics/presentation/bloc/analytics_bloc.dart';

final sl = GetIt.instance;

Future<void> init() async {
  // Core
  sl.registerLazySingleton(() => const FlutterSecureStorage());
  sl.registerLazySingleton(() => ApiClient(secureStorage: sl()));

  // Auth Feature
  // Datasource
  sl.registerLazySingleton<AuthRemoteDataSource>(
    () => AuthRemoteDataSourceImpl(apiClient: sl()),
  );

  // Repository
  sl.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(
      remoteDataSource: sl(),
      secureStorage: sl(),
    ),
  );

  // UseCases
  sl.registerLazySingleton(() => LoginUseCase(sl()));
  sl.registerLazySingleton(() => RegisterUseCase(sl()));
  sl.registerLazySingleton(() => LogoutUseCase(sl()));
  sl.registerLazySingleton(() => CheckLoggedInUseCase(sl()));

  // Bloc
  sl.registerFactory(
    () => AuthBloc(
      loginUseCase: sl(),
      registerUseCase: sl(),
      logoutUseCase: sl(),
      checkLoggedInUseCase: sl(),
      secureStorage: sl(),
    ),
  );

  // Events Feature
  // Datasource
  sl.registerLazySingleton<EventRemoteDataSource>(
    () => EventRemoteDataSourceImpl(apiClient: sl()),
  );

  // Repository
  sl.registerLazySingleton<EventRepository>(
    () => EventRepositoryImpl(remoteDataSource: sl()),
  );

  // UseCases
  sl.registerLazySingleton(() => GetEventsUseCase(sl()));
  sl.registerLazySingleton(() => GetEventByIdUseCase(sl()));
  sl.registerLazySingleton(() => CreateEventUseCase(sl()));
  sl.registerLazySingleton(() => UpdateEventUseCase(sl()));
  sl.registerLazySingleton(() => PublishEventUseCase(sl()));
  sl.registerLazySingleton(() => DeleteEventUseCase(sl()));
  sl.registerLazySingleton(() => GetTiersForEventUseCase(sl()));
  sl.registerLazySingleton(() => CreateTicketTierUseCase(sl()));

  sl.registerFactory(() => EventListBloc(getEventsUseCase: sl()));
  sl.registerFactory(
    () => EventDetailBloc(
      getEventByIdUseCase: sl(),
      getTiersForEventUseCase: sl(),
    ),
  );
  sl.registerFactory(
    () => OrganizerBloc(
      getEventsUseCase: sl(),
      deleteEventUseCase: sl(),
      publishEventUseCase: sl(),
    ),
  );
  sl.registerFactory(() => CreateEventBloc(createEventUseCase: sl()));
  sl.registerFactory(() => UpdateEventBloc(updateEventUseCase: sl()));
  sl.registerFactory(
    () => TicketTierBloc(
      getTiersUseCase: sl(),
      createTierUseCase: sl(),
    ),
  );

  // Bookings Feature
  // Datasource
  sl.registerLazySingleton<BookingRemoteDataSource>(
    () => BookingRemoteDataSourceImpl(apiClient: sl()),
  );

  // Repository
  sl.registerLazySingleton<BookingRepository>(
    () => BookingRepositoryImpl(remoteDataSource: sl()),
  );

  // UseCases
  sl.registerLazySingleton(() => CreateBookingUseCase(sl()));
  sl.registerLazySingleton(() => GetBookingByIdUseCase(sl()));
  sl.registerLazySingleton(() => GetMyBookingsUseCase(sl()));
  sl.registerLazySingleton(() => PaymentSuccessUseCase(sl()));
  sl.registerLazySingleton(() => CancelBookingUseCase(sl()));

  // Bloc
  sl.registerFactory(
    () => BookingBloc(
      createBookingUseCase: sl(),
      getMyBookingsUseCase: sl(),
      paymentSuccessUseCase: sl(),
      cancelBookingUseCase: sl(),
    ),
  );

  // CheckIn Feature
  sl.registerLazySingleton<CheckInRemoteDataSource>(
    () => CheckInRemoteDataSourceImpl(apiClient: sl()),
  );
  sl.registerLazySingleton<CheckInRepository>(
    () => CheckInRepositoryImpl(remoteDataSource: sl()),
  );
  sl.registerLazySingleton(() => ScanQrCodeUseCase(sl()));
  sl.registerFactory(() => CheckInBloc(scanQrCodeUseCase: sl()));

  // Analytics Feature
  sl.registerLazySingleton<AnalyticsRemoteDataSource>(
    () => AnalyticsRemoteDataSourceImpl(apiClient: sl()),
  );
  sl.registerLazySingleton<AnalyticsRepository>(
    () => AnalyticsRepositoryImpl(remoteDataSource: sl()),
  );
  sl.registerLazySingleton(() => GetEventAnalyticsUseCase(sl()));
  sl.registerFactory(() => AnalyticsBloc(getEventAnalyticsUseCase: sl()));
}
