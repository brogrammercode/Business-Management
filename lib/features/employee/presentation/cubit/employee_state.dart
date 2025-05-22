part of 'employee_cubit.dart';

class EmployeeState extends Equatable {
  final List<EmployeeParam> user;
  final StateStatus streamEmployeeStatus;
  final StateStatus signOutStatus;
  final CommonError error;

  const EmployeeState({
    this.user = const [],
    this.streamEmployeeStatus = StateStatus.initial,
    this.signOutStatus = StateStatus.initial,
    this.error = const CommonError(),
  });

  EmployeeState copyWith({
    List<EmployeeParam>? user,
    StateStatus? streamEmployeeStatus,
    StateStatus? signOutStatus,
    CommonError? error,
  }) {
    return EmployeeState(
      user: user ?? this.user,
      streamEmployeeStatus: streamEmployeeStatus ?? this.streamEmployeeStatus,
      signOutStatus: signOutStatus ?? this.signOutStatus,
      error: error ?? this.error,
    );
  }

  @override
  List<Object> get props => [user, streamEmployeeStatus, signOutStatus, error];
}
