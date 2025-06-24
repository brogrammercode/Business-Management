import 'dart:io';

import 'package:gas/features/delivery/data/models/consumer_model.dart';
import 'package:gas/features/delivery/data/models/delivery_model.dart';

abstract interface class DeliveryRepo {
  Stream<List<DeliveryModel>> streamDeliveries({required String businessID});
  Stream<List<ConsumerModel>> streamConsumers({required String businessID});
  Future<bool> addConsumer({required ConsumerModel consumer, File? image});
  Future<bool> updateConsumer({required ConsumerModel consumer, File? image});
  Future<bool> addDelivery({required DeliveryModel delivery});
  Future<bool> updateDelivery({required DeliveryModel delivery, File? image});
}
