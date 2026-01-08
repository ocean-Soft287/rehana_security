import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:rehana_security/core/router/app_router.dart';
import 'package:rehana_security/core/widget/loading_button.dart';
import 'package:rehana_security/feature/Home/Presentaion/view/Screen/home.dart';
import '../../../../../core/color/colors.dart';
import '../../../../Auth/presentation/views/screen/password_changed.dart';
import '../../constants/accept_refuse_constants.dart';
import '../../manger/entre_exit_cubit.dart';
import '../widget/user_info_screen.dart';

class EnterandExit extends StatelessWidget {
  const EnterandExit({super.key, required this.name, required this.qrData});

  final String name;
  final String qrData;

  @override
  Widget build(BuildContext context) {
    // Extract encrypted data from QR code JSON
    String encryptedText;
    try {
      final dynamic decodedData = jsonDecode(qrData);

      // If the decoded data is a Map, extract the EncryptedData field
      if (decodedData is Map<String, dynamic>) {
        encryptedText = decodedData["EncryptedData"] as String? ?? qrData;
      } else {
        // If it's not a map, use the decoded data as-is
        encryptedText = decodedData.toString();
      }
    } catch (e) {
      // If JSON decoding fails, use the raw QR data
      encryptedText = qrData;
    }

    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(0),
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
              SizedBox(height: AcceptRefuseConstants.topSpacingLarge),
              SizedBox(height: AcceptRefuseConstants.topSpacingMedium.r),
              Center(
                child: BlocConsumer<EntreExitCubit, EntreExitState>(
                  listener: (context, state) {
                    // Handle successful accept/cancel
                    if (state is Isvalidsuccess) {
                      final message = name != AcceptRefuseConstants.exitActionName
                          ? AcceptRefuseConstants.invitationAcceptedMessage
                          : AcceptRefuseConstants.exitCompletedMessage;

                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => PasswordChanged(message: message),
                        ),
                      );
                    }

                    // Handle decryption error
                    if (state is InvitationFailure) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(state.message),
                          backgroundColor: AppColors.red,
                          duration: const Duration(seconds: 3),
                        ),
                      );
                      // Navigate back to home after error
                      Future.delayed(const Duration(seconds: 3), () {
                        if (context.mounted) {
                          context.go(AppRouter.home);
                        }
                      });
                    }

                    // Handle accept/cancel error
                    if (state is Isvaliderror) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(state.message),
                          backgroundColor: AppColors.red,
                          duration: const Duration(seconds: 3),
                        ),
                      );
                    }
                  },
                  buildWhen: (previous, current) =>
                      current is InvitationLoading ||
                      current is InvitationFailure ||
                      current is Invitationsuccess ||
                      current is IsvalidLoading ||
                      current is Isvaliderror,
                  builder: (context, state) {
                    // Show loading during decryption
                    if (state is InvitationLoading) {
                      return const LoadingButton();
                    }

                    // Show user info with loading state for buttons
                    if (state is Invitationsuccess) {
                      final cubit = context.read<EntreExitCubit>();
                      final isButtonLoading = context
                          .select((EntreExitCubit c) => c.state is IsvalidLoading);

                      return UserInfoScreen(
                        guestInvitationModel: state.guestInvitationModel,
                        name: name,
                        onexit: () => context.go(AppRouter.home),
                        onaccept: () => cubit.isvalid(
                          true,
                          state.guestInvitationModel.id,
                        ),
                        onexitentre: () => cubit.isvalid(
                          false,
                          state.guestInvitationModel.id,
                        ),
                        isLoading: isButtonLoading,
                      );
                    }

                    // Show loading if currently validating
                    if (state is IsvalidLoading) {
                      return const LoadingButton();
                    }

                    // Handle validation error - stay on the screen to show error
                    if (state is Isvaliderror) {
                      // Return empty container as we'll navigate back or show error
                      return Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.error_outline,
                              color: AppColors.red,
                              size: 60,
                            ),
                            const SizedBox(height: 16),
                            Text(
                              state.message,
                              style: TextStyle(
                                color: AppColors.red,
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 24),
                            ElevatedButton(
                              onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context)=> Home())),

                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.bIcon,
                              ),
                              child: const Text('العودة للرئيسية'),
                            ),
                          ],
                        ),
                      );
                    }

                    return Container();
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
