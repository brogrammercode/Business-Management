import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:gas/core/utils/location.dart';

class Track extends Equatable {
  final String id;
  final String employeeID;
  final List<UserLocationModel> tracks;
  final Timestamp creationTD;
  final String createdBy;
  final bool deactivate;

  const Track(
      {required this.id,
      required this.employeeID,
      required this.tracks,
      required this.creationTD,
      required this.createdBy,
      required this.deactivate});

  @override
  List<Object?> get props =>
      [id, employeeID, tracks, creationTD, createdBy, deactivate];
}
