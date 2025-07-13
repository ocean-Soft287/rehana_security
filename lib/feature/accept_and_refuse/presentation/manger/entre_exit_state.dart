part of 'entre_exit_cubit.dart';

sealed class EntreExitState {}

final class EntreExitInitial extends EntreExitState {}

final class Invitationdatafaliure extends EntreExitState{
  final String message;

  Invitationdatafaliure(this.message);

}
final class Invitationsuccess extends EntreExitState{
  final GuestInvitationModel guestInvitationModel;

  Invitationsuccess({required this.guestInvitationModel});
}
final class Isvalidsuccess extends EntreExitState{
  final SecurityInvitation securityInvitation;

  Isvalidsuccess({required this.securityInvitation});
}
final class Isvaliderror extends EntreExitState{
  final String message;

  Isvaliderror({required this.message});

}