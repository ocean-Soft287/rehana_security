part of 'entre_exit_cubit.dart';

sealed class EntreExitState {}

final class EntreExitInitial extends EntreExitState {}

// Invitation decryption states
final class InvitationLoading extends EntreExitState {}

final class InvitationFailure extends EntreExitState {
  final String message;

  InvitationFailure(this.message);
}

final class Invitationsuccess extends EntreExitState {
  final GuestInvitationModel guestInvitationModel;

  Invitationsuccess({required this.guestInvitationModel});
}

// Accept/Cancel validation states
final class IsvalidLoading extends EntreExitState {}

final class Isvalidsuccess extends EntreExitState {
  final SecurityInvitation securityInvitation;

  Isvalidsuccess({required this.securityInvitation});
}

final class Isvaliderror extends EntreExitState {
  final String message;

  Isvaliderror({required this.message});
}