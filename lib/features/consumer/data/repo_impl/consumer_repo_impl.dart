import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:gas/core/utils/error.dart';
import 'package:gas/features/consumer/data/data_source/consumer_data_source.dart';
import 'package:gas/features/consumer/data/models/consumer_model.dart';
import 'package:gas/features/consumer/domain/repositories/consumer_repo.dart';

class ConsumerRepoImpl implements ConsumerRepo {
  final ConsumerDataSource _consumerDataSource;

  ConsumerRepoImpl({required ConsumerDataSource consumerDataSource})
      : _consumerDataSource = consumerDataSource;

  @override
  Future<Either<CommonError, void>> addConsumer(
      {required ConsumerModel consumer, required File? profileImage}) async {
    try {
      await _consumerDataSource.addConsumer(
          consumer: consumer, profileImage: profileImage);
      return const Right(null);
    } on Exception catch (e) {
      return Left(
          CommonError(code: 'ADD_CONSUMER_ERROR', message: e.toString()));
    }
  }

  @override
  Future<Either<CommonError, List<ConsumerModel>>> getAllConsumers() async {
    try {
      final consumers = await _consumerDataSource.getAllConsumers();
      return Right(consumers); // Return the list of consumers on success
    } on Exception catch (e) {
      return Left(
          CommonError(code: 'GET_ALL_CONSUMERS_ERROR', message: e.toString()));
    }
  }

  @override
  Future<Either<CommonError, void>> updateConsumer(
      {required ConsumerModel consumer, required File? profileImage}) async {
    try {
      await _consumerDataSource.updateConsumer(
          consumer: consumer, profileImage: profileImage);
      return const Right(null);
    } on Exception catch (e) {
      return Left(
          CommonError(code: 'UPDATE_CONSUMER_ERROR', message: e.toString()));
    }
  }

  @override
  Future<Either<CommonError, void>> deleteConsumer({required String id}) async {
    try {
      await _consumerDataSource.deleteConsumer(id: id);
      return const Right(null);
    } on Exception catch (e) {
      return Left(
          CommonError(code: 'DELETE_CONSUMER_ERROR', message: e.toString()));
    }
  }
}
