import 'dart:io';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gas/core/utils/error.dart';
import 'package:gas/features/organisation/data/models/org_model.dart';
import 'package:gas/features/organisation/domain/repositories/org_repo.dart';

part 'org_state.dart';

class OrgCubit extends Cubit<OrgState> {
  final OrgRepo _repo;

  OrgCubit({required OrgRepo repo})
      : _repo = repo,
        super(const OrgState());

  Future<void> getOrgs() async {
    try {
      emit(state.copyWith(getOrgStatus: StateStatus.loading));
      final orgs = await _repo.getOrgs();
      emit(state.copyWith(orgs: orgs, getOrgStatus: StateStatus.success));
    } catch (e) {
      emit(state.copyWith(
          getOrgStatus: StateStatus.failure,
          error: CommonError(consoleMessage: e.toString())));
    }
  }

  Future<void> addOrg({required OrgModel org, required File? avatar}) async {
    try {
      emit(state.copyWith(addOrgStatus: StateStatus.loading));
      await _repo.addOrg(org: org, avatar: avatar);
      emit(state.copyWith(addOrgStatus: StateStatus.success));
    } catch (e) {
      emit(state.copyWith(
          addOrgStatus: StateStatus.failure,
          error: CommonError(consoleMessage: e.toString())));
    }
  }

  Future<void> requestToJoinOrg({required String orgID}) async {
    try {
      emit(state.copyWith(requestToJoinOrgStatus: StateStatus.loading));
      await _repo.requestToJoinOrg(orgID: orgID);
      emit(state.copyWith(requestToJoinOrgStatus: StateStatus.success));
    } catch (e) {
      emit(state.copyWith(
          requestToJoinOrgStatus: StateStatus.failure,
          error: CommonError(consoleMessage: e.toString())));
    }
  }

  Future<void> updateOrgID({required String orgID}) async =>
      emit(state.copyWith(orgID: orgID));
}
