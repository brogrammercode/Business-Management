part of 'auth_cubit.dart';

class AuthState extends Equatable {
  final CommonError error;
  final StateStatus status;

  const AuthState({
    this.error = const CommonError(),
    this.status = StateStatus.initial,
  });

  AuthState copyWith({
    CommonError? error,
    StateStatus? status,
  }) {
    return AuthState(
      error: error ?? this.error,
      status: status ?? this.status,
    );
  }

  @override
  List<Object?> get props => [error, status];
}
