import 'package:dartz/dartz.dart';
import 'package:gas/core/utils/error.dart';
import 'package:gas/core/utils/usecase.dart';
import 'package:gas/features/consumer/domain/repositories/consumer_repo.dart';

class DeleteConsumer implements UseCase<void, DeleteConsumerParams> {
  final ConsumerRepo _repo;

  DeleteConsumer({required ConsumerRepo repo}) : _repo = repo;
  @override
  Future<Either<CommonError, void>> call(DeleteConsumerParams params) async {
    return await _repo.deleteConsumer(id: params.id);
  }
}

class DeleteConsumerParams {
  final String id;

  DeleteConsumerParams({required this.id});
}
