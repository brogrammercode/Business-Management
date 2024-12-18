part of 'consumer_bloc.dart';

sealed class ConsumerState extends Equatable {
  const ConsumerState();

  @override
  List<Object> get props => [];
}

final class ConsumerInitial extends ConsumerState {}

final class ConsumerGettingAllConsumers extends ConsumerState {}

final class ConsumerUploadingDetails extends ConsumerState {}

final class ConsumerError extends ConsumerState {
  final String message;

  const ConsumerError({required this.message});
  @override
  List<Object> get props => [message];
}

final class ConsumerAllConsumersFetched extends ConsumerState {
  final List<ConsumerModel> consumers;

  const ConsumerAllConsumersFetched({required this.consumers});

  @override
  List<Object> get props => [consumers];
}
