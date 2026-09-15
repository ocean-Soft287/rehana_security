import 'package:go_router/go_router.dart';
import 'package:rehana_security/feature/Home/Presentaion/view/Screen/home.dart';
import '../../feature/Auth/presentation/views/login_screen.dart';
import '../../feature/manual_invitation/presentation/views/screen/manual_invitation_screen.dart';
import '../../feature/registered_invitations/presentation/views/screen/registered_invitations_screen.dart';
import '../../feature/splash/splashscreen.dart';

abstract class AppRouter {
  static const kLoginview = '/loginView';
  static const kforgetView = '/forgetView';
  static const kentreandexit="/kentreandexit";
  static const invtationuser = '/invtationuser';
  static const home = '/home';
  static const kotpView = '/otpView';
  static const manualInvitation = '/manualInvitation';
  static const registeredInvitations = '/registeredInvitations';

  static final router = GoRouter(
    routes: [
      GoRoute(path: '/', builder: (context, state) => const Splashscreen()),
      GoRoute(
        path: kLoginview,
        builder: (context, state) => const LoginScreen(),
      ),

//       GoRoute(path: kotpView,
//           builder: (context, state) => const OtpScreen()),
// GoRoute(path: kforgetView,
//
// builder: (context,state)=>const ForgetPassword()),
      GoRoute(
        path: home,
        builder: (context, state) => const Home(),
      ),
      GoRoute(
        path: manualInvitation,
        builder: (context, state) => const ManualInvitationScreen(),
      ),
      GoRoute(
        path: registeredInvitations,
        builder: (context, state) => const RegisteredInvitationsScreen(),
      ),
    ],
  );
}
