import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../core/color/colors.dart';
import '../../../../../core/images/font.dart';
import '../../../../../core/services/services_locator.dart';
import '../../../../../core/widget/context_show.dart';
import '../../../data/model/registered_invitation_model.dart';
import '../../manger/registered_invitations_cubit.dart';
import '../widget/invitations_tab_view.dart';

class RegisteredInvitationsScreen extends StatelessWidget {
  const RegisteredInvitationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<RegisteredInvitationsCubit>(),
      child: const RegisteredInvitationsView(),
    );
  }
}

class RegisteredInvitationsView extends StatelessWidget {
  const RegisteredInvitationsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: DefaultTabController(
        length: 2,
        child: Scaffold(
          backgroundColor: AppColors.white,
          appBar: AppBar(
            backgroundColor: AppColors.bIcon,
            elevation: 0,
            centerTitle: true,
            iconTheme: IconThemeData(color: AppColors.black),
            title: Text(
              'الدعاوى المسجلة',
              style: TextStyle(
                fontSize: 18.sp,
                fontWeight: FontWeight.w500,
                fontFamily: Font.alex,
                color: AppColors.black,
              ),
            ),
            bottom: TabBar(
              indicatorColor: AppColors.black,
              indicatorWeight: 3,
              labelColor: AppColors.black,
              unselectedLabelColor: AppColors.black.withValues(alpha: 0.6),
              labelStyle: TextStyle(
                fontSize: 15.sp,
                fontWeight: FontWeight.w600,
                fontFamily: Font.alex,
              ),
              unselectedLabelStyle: TextStyle(
                fontSize: 15.sp,
                fontWeight: FontWeight.w400,
                fontFamily: Font.alex,
              ),
              tabs: const [
                Tab(text: 'دعاوى نشطة'),
                Tab(text: 'دعاوى منتهية'),
              ],
            ),
          ),
          body: BlocListener<
            RegisteredInvitationsCubit,
            RegisteredInvitationsState
          >(
            listenWhen:
                (previous, current) =>
                    current.endSuccessMessage != null ||
                    current.endErrorMessage != null,
            listener: (context, state) {
              if (state.endSuccessMessage != null) {
                context.showSuccessMessage(state.endSuccessMessage!);
              } else if (state.endErrorMessage != null) {
                context.showErrorMessage(state.endErrorMessage!);
              }
              context.read<RegisteredInvitationsCubit>().consumeEndMessages();
            },
            child: const SafeArea(
              child: TabBarView(
                children: [
                  InvitationsTabView(status: InvitationStatus.active),
                  InvitationsTabView(status: InvitationStatus.expired),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
