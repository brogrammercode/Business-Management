import 'dart:async';
import 'dart:io';

import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gas/core/utils/error.dart';
import 'package:gas/features/business/presentation/cubit/business_cubit.dart';
import 'package:gas/features/delivery/data/models/consumer_model.dart';
import 'package:gas/features/delivery/data/models/delivery_model.dart';
import 'package:gas/features/delivery/domain/repo/delivery_repo.dart';
import 'package:gas/main.dart';

part 'delivery_state.dart';

class DeliveryCubit extends Cubit<DeliveryState> {
  final DeliveryRepo _repo;
  StreamSubscription? _deliveriesSubscription;
  StreamSubscription? _consumersSubscription;
  DeliveryCubit({required DeliveryRepo repo})
    : _repo = repo,
      super(const DeliveryState()) {
    initDeliveriesSubscription();
    initConsumersSubscription();
  }

  @override
  Future<void> close() async {
    await _deliveriesSubscription?.cancel();
    await _consumersSubscription?.cancel();
    super.close();
  }

  Future<void> initDeliveriesSubscription() async {
    try {
      emit(state.copyWith(streamDeliveriesStatus: StateStatus.loading));
      final BuildContext? buildContext = navigatorKey.currentContext;
      final String businessID =
          buildContext?.read<BusinessCubit>().state.businessID ?? '';
      _deliveriesSubscription = _repo
          .streamDeliveries(businessID: businessID)
          .listen((deliveries) {
            emit(
              state.copyWith(
                deliveries: deliveries,
                streamDeliveriesStatus: StateStatus.success,
              ),
            );
          });
    } catch (e) {
      emit(
        state.copyWith(
          streamDeliveriesStatus: StateStatus.failure,
          error: CommonError(consoleMessage: e.toString()),
        ),
      );
    }
  }

  Future<void> initConsumersSubscription() async {
    try {
      emit(state.copyWith(streamConsumersStatus: StateStatus.loading));
      final BuildContext? buildContext = navigatorKey.currentContext;
      final String businessID =
          buildContext?.read<BusinessCubit>().state.businessID ?? '';

      _consumersSubscription = _repo
          .streamConsumers(businessID: businessID)
          .listen((consumers) {
            emit(
              state.copyWith(
                consumers: consumers,
                streamConsumersStatus: StateStatus.success,
              ),
            );
          });
    } catch (e) {
      debugPrint(e.toString());
      emit(
        state.copyWith(
          streamConsumersStatus: StateStatus.failure,
          error: CommonError(consoleMessage: e.toString()),
        ),
      );
    }
  }

  Future<bool> addConsumer({
    required ConsumerModel consumer,
    File? image,
  }) async {
    try {
      emit(state.copyWith(addConsumerStatus: StateStatus.loading));
      await _repo.addConsumer(consumer: consumer, image: image);
      emit(state.copyWith(addConsumerStatus: StateStatus.success));
      return true;
    } catch (e) {
      emit(
        state.copyWith(
          addConsumerStatus: StateStatus.failure,
          error: CommonError(consoleMessage: e.toString()),
        ),
      );
      return false;
    }
  }

  Future<bool> updateConsumer({required ConsumerModel consumer}) async {
    try {
      emit(state.copyWith(updateConsumerStatus: StateStatus.loading));
      await _repo.updateConsumer(consumer: consumer);
      emit(state.copyWith(updateConsumerStatus: StateStatus.success));
      return true;
    } catch (e) {
      emit(
        state.copyWith(
          updateConsumerStatus: StateStatus.failure,
          error: CommonError(consoleMessage: e.toString()),
        ),
      );
      return false;
    }
  }

  Future<bool> addDelivery({required DeliveryModel delivery}) async {
    try {
      emit(state.copyWith(addDeliveryStatus: StateStatus.loading));
      await _repo.addDelivery(delivery: delivery);
      emit(state.copyWith(addDeliveryStatus: StateStatus.success));
      return true;
    } catch (e) {
      emit(
        state.copyWith(
          addDeliveryStatus: StateStatus.failure,
          error: CommonError(consoleMessage: e.toString()),
        ),
      );
      return false;
    }
  }

  Future<bool> updateDelivery({required DeliveryModel delivery}) async {
    try {
      emit(state.copyWith(updateDeliveryStatus: StateStatus.loading));
      await _repo.updateDelivery(delivery: delivery);
      emit(state.copyWith(updateDeliveryStatus: StateStatus.success));
      return true;
    } catch (e) {
      emit(
        state.copyWith(
          updateDeliveryStatus: StateStatus.failure,
          error: CommonError(consoleMessage: e.toString()),
        ),
      );
      return false;
    }
  }

  Future<bool> deleteDelivery({required DeliveryModel delivery}) async {
    try {
      emit(state.copyWith(updateDeliveryStatus: StateStatus.loading));
      await _repo.updateDelivery(delivery: delivery.copyWith(deactivate: true));
      emit(state.copyWith(updateDeliveryStatus: StateStatus.success));
      return true;
    } catch (e) {
      emit(
        state.copyWith(
          updateDeliveryStatus: StateStatus.failure,
          error: CommonError(consoleMessage: e.toString()),
        ),
      );
      return false;
    }
  }

  Future<bool> deleteConsumer({required ConsumerModel consumer}) async {
    try {
      emit(state.copyWith(updateConsumerStatus: StateStatus.loading));
      await _repo.updateConsumer(consumer: consumer.copyWith(deactivate: true));
      emit(state.copyWith(updateConsumerStatus: StateStatus.success));
      return true;
    } catch (e) {
      emit(
        state.copyWith(
          updateConsumerStatus: StateStatus.failure,
          error: CommonError(consoleMessage: e.toString()),
        ),
      );
      return false;
    }
  }
}
