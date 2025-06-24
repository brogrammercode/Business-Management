part of 'home_cubit.dart';

class HomeState extends Equatable {
  final Position? position;
  final List<UserLocationModel> lastLocation;
  final bool locationEnabled;
  final StateStatus getLocationStatus;
  final StateStatus getLocationFromDatabaseStatus;
  final StateStatus updateLocationToDatabaseStatus;
  final CommonError error;

  const HomeState({
    this.position,
    this.lastLocation = const [],
    this.locationEnabled = false,
    this.getLocationStatus = StateStatus.initial,
    this.getLocationFromDatabaseStatus = StateStatus.initial,
    this.updateLocationToDatabaseStatus = StateStatus.initial,
    this.error = const CommonError(),
  });

  HomeState copyWith({
    Position? position,
    List<UserLocationModel>? lastLocation,
    bool? locationEnabled,
    StateStatus? getLocationStatus,
    StateStatus? getLocationFromDatabaseStatus,
    StateStatus? updateLocationToDatabaseStatus,
    CommonError? error,
  }) {
    return HomeState(
      position: position ?? this.position,
      lastLocation: lastLocation ?? this.lastLocation,
      locationEnabled: locationEnabled ?? this.locationEnabled,
      getLocationStatus: getLocationStatus ?? this.getLocationStatus,
      getLocationFromDatabaseStatus:
          getLocationFromDatabaseStatus ?? this.getLocationFromDatabaseStatus,
      updateLocationToDatabaseStatus:
          updateLocationToDatabaseStatus ?? this.updateLocationToDatabaseStatus,
      error: error ?? this.error,
    );
  }

  @override
  List<Object?> get props => [
        position,
        lastLocation,
        locationEnabled,
        getLocationStatus,
        getLocationFromDatabaseStatus,
        updateLocationToDatabaseStatus,
        error
      ];
}
