part of 'manual_invitation_cubit.dart';

sealed class ManualInvitationState {}

final class ManualInvitationInitial extends ManualInvitationState {}

/// villas list states
final class VillasLoading extends ManualInvitationState {}

final class VillasSuccess extends ManualInvitationState {
  final List<VillaModel> villas;

  VillasSuccess({required this.villas});
}

final class VillasFailure extends ManualInvitationState {
  final String message;

  VillasFailure(this.message);
}

/// send invitation states
final class SendInvitationLoading extends ManualInvitationState {}

final class SendInvitationSuccess extends ManualInvitationState {
  final String message;

  SendInvitationSuccess(this.message);
}

final class SendInvitationFailure extends ManualInvitationState {
  final String message;

  SendInvitationFailure(this.message);
}
