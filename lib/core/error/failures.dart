import 'package:equatable/equatable.dart';

abstract class Failure extends Equatable {
  final String message;

  const Failure(this.message);

  @override
  List<Object> get props => [message];
}

class ServerFailure extends Failure {
  const ServerFailure([super.message = 'A server error occurred']);
}

class NetworkFailure extends Failure {
  const NetworkFailure([super.message = 'Check your internet connection']);
}

class AuthFailure extends Failure {
  const AuthFailure([super.message = 'Authentication failed. Please login again.']);
}

class ValidationFailure extends Failure {
  const ValidationFailure([super.message = 'Invalid input provided.']);
}

class CacheFailure extends Failure {
  const CacheFailure([super.message = 'Failed to load local data.']);
}
