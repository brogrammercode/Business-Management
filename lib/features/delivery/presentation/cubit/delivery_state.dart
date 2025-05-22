part of 'delivery_cubit.dart';

class DeliveryState extends Equatable {
  final List<DeliveryModel> deliveries;
  final List<ConsumerModel> consumers;
  final StateStatus streamDeliveriesStatus;
  final StateStatus streamConsumersStatus;
  final StateStatus addConsumerStatus;
  final StateStatus updateConsumerStatus;
  final StateStatus addDeliveryStatus;
  final StateStatus updateDeliveryStatus;
  final CommonError error;
  const DeliveryState({
    this.deliveries = const [],
    this.consumers = const [],
    this.streamDeliveriesStatus = StateStatus.initial,
    this.streamConsumersStatus = StateStatus.initial,
    this.addConsumerStatus = StateStatus.initial,
    this.updateConsumerStatus = StateStatus.initial,
    this.addDeliveryStatus = StateStatus.initial,
    this.updateDeliveryStatus = StateStatus.initial,
    this.error = const CommonError(),
  });
  DeliveryState copyWith({
    List<DeliveryModel>? deliveries,
    List<ConsumerModel>? consumers,
    StateStatus? streamDeliveriesStatus,
    StateStatus? streamConsumersStatus,
    StateStatus? addConsumerStatus,
    StateStatus? updateConsumerStatus,
    StateStatus? addDeliveryStatus,
    StateStatus? updateDeliveryStatus,
    CommonError? error,
  }) {
    return DeliveryState(
      deliveries: deliveries ?? this.deliveries,
      consumers: consumers ?? this.consumers,
      streamDeliveriesStatus:
          streamDeliveriesStatus ?? this.streamDeliveriesStatus,
      streamConsumersStatus:
          streamConsumersStatus ?? this.streamConsumersStatus,
      addConsumerStatus: addConsumerStatus ?? this.addConsumerStatus,
      updateConsumerStatus: updateConsumerStatus ?? this.updateConsumerStatus,
      addDeliveryStatus: addDeliveryStatus ?? this.addDeliveryStatus,
      updateDeliveryStatus: updateDeliveryStatus ?? this.updateDeliveryStatus,
      error: error ?? this.error,
    );
  }

  @override
  List<Object> get props => [
        deliveries,
        consumers,
        streamDeliveriesStatus,
        streamConsumersStatus,
        addConsumerStatus,
        updateConsumerStatus,
        addDeliveryStatus,
        updateDeliveryStatus,
        error,
      ];
}
