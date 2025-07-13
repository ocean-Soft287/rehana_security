import 'package:bloc/bloc.dart';
import 'package:rehana_security/feature/accept_and_refuse/data/repo/acceptrepo.dart';

import '../../data/model/guest_model.dart';
import '../../data/model/security_invitation.dart';

part 'entre_exit_state.dart';

class EntreExitCubit extends Cubit<EntreExitState> {
  EntreExitCubit(this.acceptrepo) : super(EntreExitInitial());
final Acceptrepo acceptrepo;

  Future<void>  decryption(String data)async{

  final response= await acceptrepo.decryption(data);

  response.fold(
        (failure) {
      emit(Invitationdatafaliure(failure.message));

    },
        (data) {

      emit(Invitationsuccess(guestInvitationModel:  data,));
    },
  );

}

Future<void>isvalid(bool isvalidid,String id)async{
    final response=await acceptrepo.isvalid(isvalidid, id);

    response.fold((faliure){

      emit(Isvaliderror(message:faliure.message));
    },
            (data){
      emit(Isvalidsuccess(securityInvitation: data));
            });
}


}
