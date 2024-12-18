import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:gas/core/utils/error.dart';
import 'package:gas/features/consumer/data/models/consumer_model.dart';

abstract interface class ConsumerRepo {
  Future<Either<Failure, List<ConsumerModel>>> getAllConsumers();
  Future<Either<Failure, void>> addConsumer(
      {required ConsumerModel consumer, required File? profileImage});
  Future<Either<Failure, void>> updateConsumer(
      {required ConsumerModel consumer, required File? profileImage});
  Future<Either<Failure, void>> deleteConsumer({required String id});
}
