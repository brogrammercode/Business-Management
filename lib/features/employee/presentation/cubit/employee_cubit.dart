import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gas/core/utils/error.dart';
import 'package:gas/features/employee/domain/repo/employee_remote_repo.dart';

part 'employee_state.dart';

class EmployeeCubit extends Cubit<EmployeeState> {
  final EmployeeRemoteRepo _repo;
  StreamSubscription? _userSubscription;
  EmployeeCubit({required EmployeeRemoteRepo repo})
      : _repo = repo,
        super(const EmployeeState()) {
    initEmployeeSubscription();
  }

  @override
  Future<void> close() async {
    await _userSubscription?.cancel();
    super.close();
  }

  Future<bool> signOut() async {
    try {
      emit(state.copyWith(signOutStatus: StateStatus.loading));
      await _repo.signOut();
      emit(state.copyWith(signOutStatus: StateStatus.success));
      return true;
    } catch (e) {
      emit(state.copyWith(signOutStatus: StateStatus.failure));
      return false;
    }
  }

  Future<void> initEmployeeSubscription() async {
    try {
      emit(state.copyWith(streamEmployeeStatus: StateStatus.loading));
      _userSubscription = _repo.streamEmployee().listen((user) {
        emit(state
            .copyWith(user: [user], streamEmployeeStatus: StateStatus.success));
      });
    } catch (e) {
      emit(state.copyWith(
          streamEmployeeStatus: StateStatus.failure,
          error: CommonError(consoleMessage: e.toString())));
    }
  }
}
