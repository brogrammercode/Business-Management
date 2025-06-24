import 'package:gas/core/utils/location.dart';

abstract class HomeRemoteRepo {
  Future<UserLocationModel?> getLocationFromDatabase();
  Future<bool> updateLocationToDatabase({required UserLocationModel location});
}
