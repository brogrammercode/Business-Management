import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gas/core/utils/usecase.dart';
import 'package:gas/features/consumer/data/models/consumer_model.dart';
import 'package:gas/features/consumer/domain/usecases/add_consumer.dart';
import 'package:gas/features/consumer/domain/usecases/delete_consumer.dart';
import 'package:gas/features/consumer/domain/usecases/get_all_consumers.dart';
import 'package:gas/features/consumer/domain/usecases/update_consumer.dart';

part 'consumer_event.dart';
part 'consumer_state.dart';

/// Business logic component for managing consumer-related functionality.
class ConsumerBloc extends Bloc<ConsumerEvent, ConsumerState> {
  final GetAllConsumers _getAllConsumers;
  final AddConsumer _addConsumer;
  final UpdateConsumer _updateConsumer;
  final DeleteConsumer _deleteConsumer;

  /// Constructor for ConsumerBloc.
  ///
  /// [getAllConsumers] is the use case for retrieving all consumers.
  /// [addConsumer] is the use case for adding a consumer.
  /// [updateConsumer] is the use case for updating a consumer.
  /// [deleteConsumer] is the use case for deleting a consumer.
  ConsumerBloc({
    required GetAllConsumers getAllConsumers,
    required AddConsumer addConsumer,
    required UpdateConsumer updateConsumer,
    required DeleteConsumer deleteConsumer,
  })  : _getAllConsumers = getAllConsumers,
        _addConsumer = addConsumer,
        _updateConsumer = updateConsumer,
        _deleteConsumer = deleteConsumer,
        super(ConsumerInitial()) {
    on<ConsumerEvent>(_handleEvent);
  }

  /// Handles incoming ConsumerEvent and emits corresponding ConsumerState.
  Future<void> _handleEvent(
      ConsumerEvent event, Emitter<ConsumerState> emit) async {
    if (event is GetAllConsumersEvent) {
      await _getAllConsumersHandler(event, emit);
    } else if (event is AddConsumerEvent) {
      await _addConsumerHandler(event, emit);
    } else if (event is UpdateConsumerEvent) {
      await _updateConsumerHandler(event, emit);
    } else if (event is DeleteConsumerEvent) {
      await _deleteConsumerHandler(event, emit);
    }
  }

  /// Handles fetching all consumers.
  Future<void> _getAllConsumersHandler(
      GetAllConsumersEvent event, Emitter<ConsumerState> emit) async {
    emit(ConsumerGettingAllConsumers());
    try {
      final consumersResult = await _getAllConsumers(NoParams());
      final consumers = consumersResult.getOrElse(() => throw Exception());
      emit(ConsumerAllConsumersFetched(consumers: consumers));
    } catch (e) {
      emit(const ConsumerError(message: 'Failed to get consumers'));
    }
  }

  /// Handles adding a consumer.
  Future<void> _addConsumerHandler(
      AddConsumerEvent event, Emitter<ConsumerState> emit) async {
    emit(ConsumerUploadingDetails());
    try {
      await _addConsumer(AddConsumerParams(
          consumer: event.params.consumer,
          profileImage: event.params.profileImage));
      final consumersResult = await _getAllConsumers(NoParams());
      final consumers = consumersResult.getOrElse(() => throw Exception());
      emit(ConsumerAllConsumersFetched(consumers: consumers));
    } catch (e) {
      emit(const ConsumerError(message: 'Failed to add consumer'));
    }
  }

  /// Handles updating a consumer.
  Future<void> _updateConsumerHandler(
      UpdateConsumerEvent event, Emitter<ConsumerState> emit) async {
    emit(ConsumerUploadingDetails());
    try {
      await _updateConsumer(UpdateConsumerParams(
          consumer: event.params.consumer,
          profileImage: event.params.profileImage));
      final consumersResult = await _getAllConsumers(NoParams());
      final consumers = consumersResult.getOrElse(() => throw Exception());
      emit(ConsumerAllConsumersFetched(consumers: consumers));
    } catch (e) {
      emit(const ConsumerError(message: 'Failed to update consumer'));
    }
  }

  /// Handles deleting a consumer.
  Future<void> _deleteConsumerHandler(
      DeleteConsumerEvent event, Emitter<ConsumerState> emit) async {
    emit(ConsumerUploadingDetails());
    try {
      await _deleteConsumer(DeleteConsumerParams(id: event.params.id));
      final consumersResult = await _getAllConsumers(NoParams());
      final consumers = consumersResult.getOrElse(() => throw Exception());
      emit(ConsumerAllConsumersFetched(consumers: consumers));
    } catch (e) {
      emit(const ConsumerError(message: 'Failed to add consumer'));
    }
  }
}
