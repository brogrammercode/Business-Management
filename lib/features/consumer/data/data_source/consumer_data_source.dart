import 'dart:developer';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:gas/features/consumer/data/models/consumer_model.dart';

abstract interface class ConsumerDataSource {
  Future<List<ConsumerModel>> getAllConsumers();
  Future<void> addConsumer(
      {required ConsumerModel consumer, required File? profileImage});
  Future<void> updateConsumer(
      {required ConsumerModel consumer, required File? profileImage});
  Future<void> deleteConsumer({required String id});
}

class ConsumerDataSourceImpl implements ConsumerDataSource {
  final _consumers = FirebaseFirestore.instance.collection("consumers");

  // Method to upload image to Firebase Storage and get the URL
  Future<String> uploadImage({required String id, required File image}) async {
    try {
      final ref = FirebaseStorage.instance
          .ref()
          .child("Consumer Profile Images")
          .child(id)
          .child("${DateTime.now().millisecondsSinceEpoch}.jpg");

      final uploadTask = await ref.putFile(image);
      final imageUrl = await uploadTask.ref.getDownloadURL();
      return imageUrl;
    } catch (e) {
      throw Exception("Failed to upload image: $e");
    }
  }

  @override
  Future<void> addConsumer(
      {required ConsumerModel consumer, required File? profileImage}) async {
    try {
      var updatedConsumer = consumer;

      if (profileImage != null) {
        final String imageUrl =
            await uploadImage(id: updatedConsumer.id, image: profileImage);
        updatedConsumer = updatedConsumer.copyWith(image: imageUrl);
      }

      await _consumers.doc(updatedConsumer.id).set(updatedConsumer.toJson());
    } catch (e) {
      throw Exception("Failed to add consumer: $e");
    }
  }

  @override
  Future<void> updateConsumer(
      {required ConsumerModel consumer, required File? profileImage}) async {
    try {
      var updatedConsumer = consumer;

      if (profileImage != null) {
        final String imageUrl =
            await uploadImage(id: updatedConsumer.id, image: profileImage);

        updatedConsumer = updatedConsumer.copyWith(image: imageUrl);
      }

      await _consumers.doc(updatedConsumer.id).update(updatedConsumer.toJson());
    } catch (e) {
      throw Exception("Failed to update consumer: $e");
    }
  }

  @override
  Future<void> deleteConsumer({required String id}) async {
    try {
      await _consumers.doc(id).update({'deactivate': true});
    } catch (e) {
      throw Exception("Failed to deactivate consumer: $e");
    }
  }

  @override
  Future<List<ConsumerModel>> getAllConsumers() async {
    try {
      final snapshot = await _consumers.get();
      if (snapshot.docs.isEmpty) {
        return [];
      }

      return snapshot.docs
          .map((doc) {
            try {
              return ConsumerModel.fromJson(doc.data());
            } catch (e) {
              log('Error parsing document ${doc.id}: $e');
              return null;
            }
          })
          .whereType<ConsumerModel>() // Filter out null values
          .toList();
    } catch (e) {
      throw Exception("Failed to fetch consumers: $e");
    }
  }
}
