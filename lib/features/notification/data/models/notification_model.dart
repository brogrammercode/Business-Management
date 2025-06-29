import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:gas/features/notification/domain/entities/notification.dart';

class NotificationModel extends Notification {
  const NotificationModel({
    required super.id,
    required super.businessID,
    required super.bigAvatar,
    required super.smallAvatar,
    required super.description,
    required super.boldTexts,
    required super.module,
    required super.refID,
    required super.seen,
    required super.createdBy,
    required super.creationTD,
  });

  factory NotificationModel.fromJson(Map<String, dynamic>? json) {
    if (json == null) {
      throw ArgumentError('NOTIFICATION_MODEL_ISSUE: JSON IS NULL');
    }

    return NotificationModel(
      id: json['id']?.toString() ?? '',
      businessID: json['businessID']?.toString() ?? '',
      bigAvatar: json['bigAvatar']?.toString() ?? '',
      smallAvatar: json['smallAvatar']?.toString() ?? '',
      description: json['description']?.toString() ?? '',
      boldTexts:
          (json['boldTexts'] as List?)?.map((e) => e.toString()).toList() ?? [],
      module: json['module']?.toString() ?? '',
      refID: json['refID']?.toString() ?? '',
      seen:
          (json['seen'] as List?)
              ?.map((e) => SeenModel.fromJson(Map<String, dynamic>.from(e)))
              .toList() ??
          [],
      createdBy: json['createdBy']?.toString() ?? '',
      creationTD: json['creationTD'] is Timestamp
          ? json['creationTD']
          : Timestamp.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'businessID': businessID,
      'bigAvatar': bigAvatar,
      'smallAvatar': smallAvatar,
      'description': description,
      'boldTexts': boldTexts,
      'module': module,
      'refID': refID,
      'seen': seen.map((e) => (e).toJson()).toList(),
      'createdBy': createdBy,
      'creationTD': creationTD,
    };
  }

  NotificationModel copyWith({
    String? id,
    String? businessID,
    String? bigAvatar,
    String? smallAvatar,
    String? description,
    List<String>? boldTexts,
    String? module,
    String? refID,
    List<SeenModel>? seen,
    String? createdBy,
    Timestamp? creationTD,
  }) {
    return NotificationModel(
      id: id ?? this.id,
      businessID: businessID ?? this.businessID,
      bigAvatar: bigAvatar ?? this.bigAvatar,
      smallAvatar: smallAvatar ?? this.smallAvatar,
      description: description ?? this.description,
      boldTexts: boldTexts ?? this.boldTexts,
      module: module ?? this.module,
      refID: refID ?? this.refID,
      seen: seen ?? this.seen,
      createdBy: createdBy ?? this.createdBy,
      creationTD: creationTD ?? this.creationTD,
    );
  }

  @override
  String toString() {
    return 'NotificationModel(id: $id, businessID: $businessID, bigAvatar: $bigAvatar, smallAvatar: $smallAvatar, description: $description, boldTexts: $boldTexts, module: $module, refID: $refID, seen: $seen, createdBy: $createdBy, creationTD: $creationTD)';
  }
}

class SeenModel extends Seen {
  const SeenModel({required super.uid, required super.td});

  factory SeenModel.fromJson(Map<String, dynamic>? json) {
    if (json == null) {
      throw ArgumentError("SEEN_MODEL_ISSUE: JSON IS NULL");
    }

    return SeenModel(
      uid: json['uid']?.toString() ?? '',
      td: json['td'] is Timestamp ? json['td'] : Timestamp.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {'uid': uid, 'td': td};
  }

  SeenModel copyWith({String? uid, Timestamp? td}) {
    return SeenModel(uid: uid ?? this.uid, td: td ?? this.td);
  }

  @override
  String toString() {
    return 'SeenModel(uid: $uid, td: $td)';
  }
}
