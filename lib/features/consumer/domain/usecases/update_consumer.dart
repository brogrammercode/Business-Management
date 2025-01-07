import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:gas/core/utils/error.dart';
import 'package:gas/core/utils/usecase.dart';
import 'package:gas/features/consumer/data/models/consumer_model.dart';
import 'package:gas/features/consumer/domain/repositories/consumer_repo.dart';

class UpdateConsumer implements UseCase<void, UpdateConsumerParams> {
  final ConsumerRepo _repo;

  UpdateConsumer({required ConsumerRepo repo}) : _repo = repo;
  @override
  Future<Either<CommonError, void>> call(UpdateConsumerParams params) async {
    return await _repo.updateConsumer(
        consumer: params.consumer, profileImage: params.profileImage);
  }
}

class UpdateConsumerParams {
  final ConsumerModel consumer;
  final File? profileImage;
  UpdateConsumerParams({required this.consumer, required this.profileImage});
}
