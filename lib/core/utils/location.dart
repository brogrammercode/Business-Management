import 'package:cloud_firestore/cloud_firestore.dart';

class UserLocationEntity {
  final String city;
  final String area;
  final String pincode;
  final String locality;
  final String state;
  final String country;
  final String continent;
  final GeoPoint geopoint;

  UserLocationEntity(
      {required this.city,
      required this.area,
      required this.pincode,
      required this.locality,
      required this.state,
      required this.country,
      required this.continent,
      required this.geopoint});
}

class UserLocationModel extends UserLocationEntity {
  UserLocationModel({
    super.city = "",
    super.area = "",
    super.pincode = "",
    super.locality = "",
    super.state = "",
    super.country = "",
    super.continent = "",
    super.geopoint = const GeoPoint(0, 0),
  });

  factory UserLocationModel.fromJson(Map<String, dynamic> json) {
    return UserLocationModel(
      city: json['city'] ?? '',
      area: json['area'] ?? '',
      pincode: json['pincode'] ?? '',
      locality: json['locality'] ?? '',
      state: json['state'] ?? '',
      country: json['country'] ?? '',
      continent: json['continent'] ?? '',
      geopoint: json['geopoint'] ?? const GeoPoint(0, 0),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'city': city,
      'area': area,
      'pincode': pincode,
      'locality': locality,
      'state': state,
      'country': country,
      'continent': continent,
      'geopoint': geopoint,
    };
  }

  @override
  String toString() {
    return 'UserLocationModel(city: $city, area: $area, pincode: $pincode, locality: $locality, state: $state, country: $country, continent: $continent, geopoint: $geopoint)';
  }

  UserLocationModel copyWith({
    String? city,
    String? area,
    String? pincode,
    String? locality,
    String? state,
    String? country,
    String? continent,
    GeoPoint? geopoint,
  }) {
    return UserLocationModel(
      city: city ?? this.city,
      area: area ?? this.area,
      pincode: pincode ?? this.pincode,
      locality: locality ?? this.locality,
      state: state ?? this.state,
      country: country ?? this.country,
      continent: continent ?? this.continent,
      geopoint: geopoint ?? this.geopoint,
    );
  }
}
