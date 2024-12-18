import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:gas/core/utils/error.dart';
import 'package:gas/core/utils/usecase.dart';
import 'package:gas/features/consumer/data/models/consumer_model.dart';
import 'package:gas/features/consumer/domain/repositories/consumer_repo.dart';

class AddConsumer implements UseCase<void, AddConsumerParams> {
  final ConsumerRepo _repo;

  AddConsumer({required ConsumerRepo repo}) : _repo = repo;
  @override
  Future<Either<Failure, void>> call(AddConsumerParams params) async {
    return await _repo.addConsumer(
        consumer: params.consumer, profileImage: params.profileImage);
  }
}

class AddConsumerParams {
  final ConsumerModel consumer;
  final File? profileImage;
  AddConsumerParams({required this.consumer, required this.profileImage});
}
