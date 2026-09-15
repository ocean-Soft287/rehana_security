import 'package:bloc/bloc.dart';

import '../../data/model/manual_invitation_request.dart';
import '../../data/model/villa_model.dart';
import '../../data/repo/manual_invitation_repo.dart';

part 'manual_invitation_state.dart';

class ManualInvitationCubit extends Cubit<ManualInvitationState> {
  ManualInvitationCubit(this.manualInvitationRepo)
    : super(ManualInvitationInitial());

  final ManualInvitationRepo manualInvitationRepo;

  List<VillaModel> villas = [];

  Future<void> getVillas() async {
    emit(VillasLoading());

    final response = await manualInvitationRepo.getVillas();

    response.fold((failure) => emit(VillasFailure(failure.message)), (data) {
      villas = data;
      emit(VillasSuccess(villas: data));
    });
  }

  Future<void> sendInvitation({
    required String villaNumber,
    String? visitorName,
    required String carPlateNumber,
    required DateTime visitTime,
    String? notes,
  }) async {
    emit(SendInvitationLoading());

    final response = await manualInvitationRepo.sendOneTimeInvitation(
      ManualInvitationRequest(
        villaNumber: villaNumber,
        visitorName: visitorName,
        carPlateNumber: carPlateNumber,
        visitTime: visitTime,
        notes: notes,
      ),
    );

    response.fold(
      (failure) => emit(SendInvitationFailure(failure.message)),
      (message) => emit(SendInvitationSuccess(message)),
    );
  }
}
