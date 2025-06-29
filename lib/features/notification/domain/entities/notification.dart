import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:gas/features/notification/data/models/notification_model.dart';

class Notification extends Equatable {
  final String id;
  final String businessID;
  final String bigAvatar;
  final String smallAvatar;
  final String description;
  final List<String> boldTexts;
  final String module;
  final String refID;
  final List<SeenModel> seen;
  final String createdBy;
  final Timestamp creationTD;

  const Notification({
    required this.id,
    required this.businessID,
    required this.bigAvatar,
    required this.smallAvatar,
    required this.description,
    required this.boldTexts,
    required this.module,
    required this.refID,
    required this.seen,
    required this.createdBy,
    required this.creationTD,
  });
  @override
  List<Object?> get props => [
    id,
    businessID,
    bigAvatar,
    smallAvatar,
    description,
    boldTexts,
    module,
    refID,
    seen,
    createdBy,
    creationTD,
  ];
}

class Seen extends Equatable {
  final String uid;
  final Timestamp td;

  const Seen({required this.uid, required this.td});
  @override
  List<Object?> get props => [uid, td];
}
