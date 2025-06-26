import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:gas/core/utils/common.dart';
import 'package:gas/features/delivery/data/models/consumer_model.dart';
import 'package:gas/features/delivery/data/models/delivery_model.dart';
import 'package:gas/features/delivery/domain/repo/delivery_repo.dart';

class DeliveryRemoteDs implements DeliveryRepo {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String consumerPath = 'consumers';
  final String deliveryPath = 'deliveries';

  @override
  Future<bool> addConsumer(
      {required ConsumerModel consumer, File? image}) async {
    try {
      final docRef = _firestore.collection(consumerPath).doc(consumer.id);

      String imageUrl = consumer.image;
      if (image != null) {
        imageUrl = await uploadImage(
          id: consumer.id,
          image: image,
          storageChild: 'Consumers',
        );
      }

      final updated = consumer.copyWith(image: imageUrl);
      await docRef.set(updated.toJson());
      return true;
    } catch (_) {
      return false;
    }
  }

  @override
  Future<bool> updateConsumer(
      {required ConsumerModel consumer, File? image}) async {
    try {
      final docRef = _firestore.collection(consumerPath).doc(consumer.id);

      String imageUrl = consumer.image;
      if (image != null) {
        imageUrl = await uploadImage(
          id: consumer.id,
          image: image,
          storageChild: 'Consumers',
        );
      }

      final updated = consumer.copyWith(image: imageUrl);
      await docRef.update(updated.toJson());
      return true;
    } catch (_) {
      return false;
    }
  }

  @override
  Future<bool> addDelivery({required DeliveryModel delivery}) async {
    try {
      final docRef = _firestore.collection(deliveryPath).doc(delivery.id);
      await docRef.set(delivery.toJson());
      return true;
    } catch (_) {
      return false;
    }
  }

  @override
  Future<bool> updateDelivery(
      {required DeliveryModel delivery, File? image}) async {
    try {
      String imageUrl = delivery.deliveryImage;
      if (image != null) {
        imageUrl = await uploadImage(
          id: delivery.id,
          image: image,
          storageChild: 'Deliveries',
        );
      }

      final updated = delivery.copyWith(deliveryImage: imageUrl);
      final docRef = _firestore.collection(deliveryPath).doc(delivery.id);
      await docRef.update(updated.toJson());
      return true;
    } catch (_) {
      return false;
    }
  }

  @override
  Stream<List<ConsumerModel>> streamConsumers({required String businessID}) {
    return _firestore
        .collection(consumerPath)
        .where('businessID', isEqualTo: businessID)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => ConsumerModel.fromJson(doc.data()))
            .toList());
  }

  @override
  Stream<List<DeliveryModel>> streamDeliveries({required String businessID}) {
    return _firestore
        .collection(deliveryPath)
        .where('businessID', isEqualTo: businessID)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => DeliveryModel.fromJson(doc.data()))
            .toList());
  }
}
