part of 'business_cubit.dart';

class BusinessState extends Equatable {
  final String businessID;
  final List<BusinessParams> businesses;
  final List<MyBusinessParams> myBusiness;
  final StateStatus getBusinessStatus;
  final StateStatus addBusinessStatus;
  final StateStatus updateBusinessStatus;
  final StateStatus requestToJoinBusinessStatus;
  final CommonError error;

  const BusinessState({
    this.businessID = "",
    this.businesses = const [],
    this.myBusiness = const [],
    this.getBusinessStatus = StateStatus.initial,
    this.addBusinessStatus = StateStatus.initial,
    this.updateBusinessStatus = StateStatus.initial,
    this.requestToJoinBusinessStatus = StateStatus.initial,
    this.error = const CommonError(),
  });

  BusinessState copyWith({
    String? businessID,
    List<BusinessParams>? businesses,
    List<MyBusinessParams>? myBusiness,
    StateStatus? getBusinessStatus,
    StateStatus? addBusinessStatus,
    StateStatus? updateBusinessStatus,
    StateStatus? requestToJoinBusinessStatus,
    CommonError? error,
  }) {
    return BusinessState(
      businessID: businessID ?? this.businessID,
      businesses: businesses ?? this.businesses,
      myBusiness: myBusiness ?? this.myBusiness,
      getBusinessStatus: getBusinessStatus ?? this.getBusinessStatus,
      addBusinessStatus: addBusinessStatus ?? this.addBusinessStatus,
      updateBusinessStatus: updateBusinessStatus ?? this.updateBusinessStatus,
      requestToJoinBusinessStatus:
          requestToJoinBusinessStatus ?? this.requestToJoinBusinessStatus,
      error: error ?? this.error,
    );
  }

  @override
  List<Object?> get props => [
    businessID,
    businesses,
    myBusiness,
    getBusinessStatus,
    addBusinessStatus,
    updateBusinessStatus,
    requestToJoinBusinessStatus,
    error,
  ];
}

class MyBusinessParams {
  final BusinessModel business;
  final String myRole;

  MyBusinessParams({required this.business, required this.myRole});
}
