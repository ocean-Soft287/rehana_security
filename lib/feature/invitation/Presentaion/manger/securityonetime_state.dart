part of 'securityonetime_cubit.dart';

sealed class SecurityonetimeState {}

final class SecurityonetimeInitial extends SecurityonetimeState {}

final class SecurityonetimeLoading extends SecurityonetimeState {}

final class SecurityonetimeSuccess extends SecurityonetimeState {
  final Invitation invitation;
  SecurityonetimeSuccess(this.invitation);
}

final class SecurityonetimeFailure extends SecurityonetimeState {
  final String error;
  SecurityonetimeFailure(this.error);
}
class EditImagePickerProfileViewSuccess extends SecurityonetimeState{}

class EditImagePickerProfileViewError extends SecurityonetimeState{}

class EditImagePickerProfileViewLoading extends SecurityonetimeState{}

class GetVillaNumberLoading extends SecurityonetimeState {}

class GetVillaNumberSuccess extends SecurityonetimeState {
  final List<int> villaNumbers;
  GetVillaNumberSuccess(this.villaNumbers);
}

class GetVillaNumberError extends SecurityonetimeState {
  final String error;
  GetVillaNumberError(this.error);
}
