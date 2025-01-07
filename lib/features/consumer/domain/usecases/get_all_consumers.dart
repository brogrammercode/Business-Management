import 'package:dartz/dartz.dart';
import 'package:gas/core/utils/error.dart';
import 'package:gas/core/utils/usecase.dart';
import 'package:gas/features/consumer/data/models/consumer_model.dart';
import 'package:gas/features/consumer/domain/repositories/consumer_repo.dart';

class GetAllConsumers implements UseCase<List<ConsumerModel>, NoParams> {
  final ConsumerRepo _repo;

  GetAllConsumers({required ConsumerRepo repo}) : _repo = repo;
  @override
  Future<Either<CommonError, List<ConsumerModel>>> call(NoParams params) async {
    return await _repo.getAllConsumers();
  }
}
