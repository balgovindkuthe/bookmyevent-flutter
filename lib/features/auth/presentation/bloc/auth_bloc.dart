import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../../../../core/usecase/usecase.dart';
import '../../../../core/constants/app_constants.dart';
import '../../domain/entities/user_entity.dart';
import '../../domain/usecases/login_usecase.dart';
import '../../domain/usecases/register_usecase.dart';
import '../../domain/usecases/logout_usecase.dart';
import '../../domain/usecases/check_logged_in_usecase.dart';
import 'auth_event.dart';
import 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final LoginUseCase loginUseCase;
  final RegisterUseCase registerUseCase;
  final LogoutUseCase logoutUseCase;
  final CheckLoggedInUseCase checkLoggedInUseCase;
  final FlutterSecureStorage secureStorage;

  AuthBloc({
    required this.loginUseCase,
    required this.registerUseCase,
    required this.logoutUseCase,
    required this.checkLoggedInUseCase,
    required this.secureStorage,
  }) : super(AuthInitial()) {
    on<LoginRequested>(_onLoginRequested);
    on<RegisterRequested>(_onRegisterRequested);
    on<LogoutRequested>(_onLogoutRequested);
    on<CheckAuthStatus>(_onCheckAuthStatus);
  }

  Future<void> _onLoginRequested(LoginRequested event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    final result = await loginUseCase(LoginParams(email: event.email, password: event.password));
    result.fold(
      (failure) => emit(AuthError(failure.message)),
      (user) => emit(Authenticated(user)),
    );
  }

  Future<void> _onRegisterRequested(RegisterRequested event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    final result = await registerUseCase(
      RegisterParams(name: event.name, email: event.email, password: event.password, role: event.role),
    );
    result.fold(
      (failure) => emit(AuthError(failure.message)),
      (user) => emit(Authenticated(user)),
    );
  }

  Future<void> _onLogoutRequested(LogoutRequested event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    await logoutUseCase(NoParams());
    emit(Unauthenticated());
  }

  Future<void> _onCheckAuthStatus(CheckAuthStatus event, Emitter<AuthState> emit) async {
    final result = await checkLoggedInUseCase(NoParams());
    await result.fold(
      (failure) async => emit(Unauthenticated()),
      (isLoggedIn) async {
        if (isLoggedIn) {
          // Restore user info from secure storage
          final token = await secureStorage.read(key: AppConstants.tokenKey) ?? '';
          final id = int.tryParse(await secureStorage.read(key: AppConstants.userIdKey) ?? '0') ?? 0;
          final name = await secureStorage.read(key: AppConstants.userNameKey) ?? '';
          final email = await secureStorage.read(key: AppConstants.userEmailKey) ?? '';
          final role = await secureStorage.read(key: AppConstants.userRoleKey) ?? '';
          emit(Authenticated(UserEntity(id: id, name: name, email: email, role: role, token: token)));
        } else {
          emit(Unauthenticated());
        }
      },
    );
  }
}
