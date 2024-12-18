part of 'consumer_bloc.dart';

sealed class ConsumerEvent extends Equatable {
  const ConsumerEvent();

  @override
  List<Object> get props => [];
}

final class GetAllConsumersEvent extends ConsumerEvent {}

final class AddConsumerEvent extends ConsumerEvent {
  final AddConsumerParams params;

  const AddConsumerEvent({required this.params});
}

final class UpdateConsumerEvent extends ConsumerEvent {
  final UpdateConsumerParams params;

  const UpdateConsumerEvent({required this.params});
}

final class DeleteConsumerEvent extends ConsumerEvent {
  final DeleteConsumerParams params;

  const DeleteConsumerEvent({required this.params});
}
