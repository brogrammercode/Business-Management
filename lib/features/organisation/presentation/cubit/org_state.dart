part of 'org_cubit.dart';

class OrgState extends Equatable {
  final String orgID;
  final List<OrgParams> orgs;
  final StateStatus getOrgStatus;
  final StateStatus addOrgStatus;
  final StateStatus requestToJoinOrgStatus;
  final CommonError error;

  const OrgState({
    this.orgID = "",
    this.orgs = const [],
    this.getOrgStatus = StateStatus.initial,
    this.addOrgStatus = StateStatus.initial,
    this.requestToJoinOrgStatus = StateStatus.initial,
    this.error = const CommonError(),
  });

  OrgState copyWith({
    String? orgID,
    List<OrgParams>? orgs,
    StateStatus? getOrgStatus,
    StateStatus? addOrgStatus,
    StateStatus? requestToJoinOrgStatus,
    CommonError? error,
  }) {
    return OrgState(
      orgID: orgID ?? this.orgID,
      orgs: orgs ?? this.orgs,
      getOrgStatus: getOrgStatus ?? this.getOrgStatus,
      addOrgStatus: addOrgStatus ?? this.addOrgStatus,
      requestToJoinOrgStatus:
          requestToJoinOrgStatus ?? this.requestToJoinOrgStatus,
      error: error ?? this.error,
    );
  }

  @override
  List<Object?> get props => [
        orgID,
        orgs,
        getOrgStatus,
        addOrgStatus,
        requestToJoinOrgStatus,
        error,
      ];
}
