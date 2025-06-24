import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:gas/core/utils/location.dart';
import 'package:gas/features/employee/domain/entities/track.dart';

class TrackModel extends Track {
  const TrackModel({
    required super.id,
    required super.employeeID,
    required super.tracks,
    required super.creationTD,
    required super.createdBy,
    required super.deactivate,
  });

  TrackModel copyWith({
    String? id,
    String? employeeID,
    List<UserLocationModel>? tracks,
    Timestamp? creationTD,
    String? createdBy,
    bool? deactivate,
  }) {
    return TrackModel(
      id: id ?? this.id,
      employeeID: employeeID ?? this.employeeID,
      tracks: tracks ?? this.tracks,
      creationTD: creationTD ?? this.creationTD,
      createdBy: createdBy ?? this.createdBy,
      deactivate: deactivate ?? this.deactivate,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'employeeID': employeeID,
      'tracks': tracks.map((e) => e.toJson()).toList(),
      'creationTD': creationTD,
      'createdBy': createdBy,
      'deactivate': deactivate,
    };
  }

  factory TrackModel.fromJson(Map<String, dynamic>? json) {
    if (json == null) {
      return throw ArgumentError('Invalid JSON: null value found');
    }

    return TrackModel(
      id: json['id'] as String? ?? '',
      employeeID: json['employeeID'] as String? ?? '',
      tracks: (json['tracks'] as List<dynamic>?)
              ?.map(
                  (e) => UserLocationModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      creationTD: json['creationTD'] as Timestamp? ?? Timestamp.now(),
      createdBy: json['createdBy'] as String? ?? '',
      deactivate: json['deactivate'] as bool? ?? false,
    );
  }
}
