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
  final Timestamp updateTD;

  UserLocationEntity({
    String? city,
    String? area,
    String? pincode,
    String? locality,
    String? state,
    String? country,
    String? continent,
    GeoPoint? geopoint,
    Timestamp? updateTD,
  })  : city = city ?? "",
        area = area ?? "",
        pincode = pincode ?? "",
        locality = locality ?? "",
        state = state ?? "",
        country = country ?? "",
        continent = continent ?? "",
        geopoint = geopoint ?? const GeoPoint(0, 0),
        updateTD = updateTD ?? Timestamp.now();

}

class UserLocationModel extends UserLocationEntity {
  UserLocationModel({
    super.city,
    super.area,
    super.pincode,
    super.locality,
    super.state,
    super.country,
    super.continent,
    super.geopoint,
    super.updateTD,
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
      updateTD: json['updateTD'] ?? Timestamp.now(),
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
      'updateTD': updateTD,
    };
  }

  @override
  String toString() {
    return 'UserLocationModel(city: $city, area: $area, pincode: $pincode, locality: $locality, state: $state, country: $country, continent: $continent, geopoint: $geopoint, updateTD: $updateTD)';
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
    Timestamp? updateTD,
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
      updateTD: updateTD ?? this.updateTD,
    );
  }
}
