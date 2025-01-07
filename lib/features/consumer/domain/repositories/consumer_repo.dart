import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:gas/core/utils/error.dart';
import 'package:gas/features/consumer/data/models/consumer_model.dart';

abstract interface class ConsumerRepo {
  Future<Either<CommonError, List<ConsumerModel>>> getAllConsumers();
  Future<Either<CommonError, void>> addConsumer(
      {required ConsumerModel consumer, required File? profileImage});
  Future<Either<CommonError, void>> updateConsumer(
      {required ConsumerModel consumer, required File? profileImage});
  Future<Either<CommonError, void>> deleteConsumer({required String id});
}
