import 'dart:async';
import 'dart:developer';
import 'dart:io';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gas/core/utils/error.dart';
import 'package:gas/features/business/data/models/business_model.dart';
import 'package:gas/features/business/domain/repositories/business_repo.dart';

part 'business_state.dart';

class BusinessCubit extends Cubit<BusinessState> {
  final BusinessRepo _repo;
  StreamSubscription? _businessSubscription;

  BusinessCubit({required BusinessRepo repo})
    : _repo = repo,
      super(const BusinessState()) {
    initBusinessSubscription();
  }

  Future<void> initBusinessSubscription() async {
    try {
      emit(state.copyWith(getBusinessStatus: StateStatus.loading));
      _businessSubscription = _repo.getBusinesses().listen((businesses) {
        emit(
          state.copyWith(
            businesses: businesses,
            getBusinessStatus: StateStatus.success,
          ),
        );
      });
    } catch (e) {
      log("STREAM_BUSINESS_ERROR: $e");
      emit(
        state.copyWith(
          getBusinessStatus: StateStatus.failure,
          error: CommonError(consoleMessage: e.toString()),
        ),
      );
    }
  }

  Future<bool> addBusiness({
    required BusinessModel business,
    required File? avatar,
  }) async {
    try {
      emit(state.copyWith(addBusinessStatus: StateStatus.loading));

      final success = await _repo.addBusiness(
        business: business,
        avatar: avatar,
      );

      if (success) {
        emit(state.copyWith(addBusinessStatus: StateStatus.success));
        return true;
      } else {
        emit(state.copyWith(addBusinessStatus: StateStatus.failure));
        return false;
      }
    } catch (e) {
      emit(
        state.copyWith(
          addBusinessStatus: StateStatus.failure,
          error: CommonError(consoleMessage: e.toString()),
        ),
      );
      return false;
    }
  }

  Future<bool> updateBusiness({
    required BusinessModel business,
    required File? avatar,
  }) async {
    try {
      emit(state.copyWith(updateBusinessStatus: StateStatus.loading));

      final success = await _repo.updateBusiness(
        business: business,
        avatar: avatar,
      );

      if (success) {
        emit(state.copyWith(updateBusinessStatus: StateStatus.success));
        return true;
      } else {
        emit(state.copyWith(updateBusinessStatus: StateStatus.failure));
        return false;
      }
    } catch (e) {
      emit(
        state.copyWith(
          updateBusinessStatus: StateStatus.failure,
          error: CommonError(consoleMessage: e.toString()),
        ),
      );
      return false;
    }
  }

  Future<void> requestToJoinBusiness({required String businessID}) async {
    try {
      emit(state.copyWith(requestToJoinBusinessStatus: StateStatus.loading));
      await _repo.requestToJoinBusiness(businessID: businessID);
      emit(state.copyWith(requestToJoinBusinessStatus: StateStatus.success));
    } catch (e) {
      emit(
        state.copyWith(
          requestToJoinBusinessStatus: StateStatus.failure,
          error: CommonError(consoleMessage: e.toString()),
        ),
      );
    }
  }

  Future<void> updateBusinessID({required String businessID}) async =>
      emit(state.copyWith(businessID: businessID));
  Future<void> updateMyBusinessParams({
    required List<MyBusinessParams> myBusiness,
  }) async => emit(state.copyWith(myBusiness: myBusiness));

  @override
  Future<void> close() async {
    await _businessSubscription?.cancel();
    return super.close();
  }
}
