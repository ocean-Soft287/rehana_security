import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:rehana_security/core/router/app_router.dart';
import '../../../../../core/color/colors.dart';
import '../../../../Auth/presentation/views/screen/password_changed.dart';
import '../../manger/entre_exit_cubit.dart';
import '../widget/user_info_screen.dart';

class EnterandExit extends StatelessWidget {
  const EnterandExit({super.key, required this.name, required this.qrData});

  final String name;
  final String qrData;

  @override
  Widget build(BuildContext context) {
    final Map<String, dynamic> rawData = jsonDecode(qrData);
    final encryptedText = rawData["EncryptedData"];
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(0),
        child: AppBar(
          backgroundColor: AppColors.white,
          elevation: 0,
          centerTitle: true,
        ),
      ),
      body: BlocProvider(
        create: (context) {
          final cubit = GetIt.instance<EntreExitCubit>();
          cubit.decryption(encryptedText);
          return cubit;
        },
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SizedBox(height: 90),
              SizedBox(height: 60.r),
              Center(
                child: BlocConsumer<EntreExitCubit, EntreExitState>(
                  listener: (context, state) {
                    if (state is Isvalidsuccess && name != 'خروج') {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const PasswordChanged(message: 'تم قبول الدعوة'),
                        ),
                      );
                    } else if (state is Isvalidsuccess && name == 'خروج') {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const PasswordChanged(message: 'تم الخروج'),
                        ),
                      );
                    }
                  },

                  // ✅ صحح ترتيب البراميترين
                  buildWhen: (previous, current) => current is Invitationsuccess,

                  builder: (context, state) {
                    if (state is Invitationsuccess) {
                      final cubit = context.read<EntreExitCubit>();
                      return UserInfoScreen(
                        guestInvitationModel: state.guestInvitationModel,
                        name: name,
                        onexit: () =>
                            context.go(AppRouter.home),                        onaccept: () =>
                            cubit.isvalid(true, state.guestInvitationModel.id),
                        onexitentre: () =>
                            cubit.isvalid(false, state.guestInvitationModel.id),

                      );
                    } else if (state is Invitationdatafaliure) {
                      return Text('Error: ${state.message}');
                    }

                    return const Center(child: CircularProgressIndicator());
                  },
                )
                ,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
