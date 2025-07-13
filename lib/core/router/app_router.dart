import 'package:go_router/go_router.dart';
import 'package:rehana_security/feature/Home/Presentaion/view/Screen/home.dart';
import '../../feature/Auth/presentation/views/login_screen.dart';
import '../../feature/invitation/Presentaion/view/Screen/invtaion_user.dart';
import '../../feature/splash/splashscreen.dart';

abstract class AppRouter {
  static const kLoginview = '/loginView';
  static const kforgetView = '/forgetView';
  static const kentreandexit="/kentreandexit";
  static const invtation = '/invtation';
  static const oneTimeInvitation="/OneTimeInvitation";
  static const invtationuser = '/invtationuser';
  static const home = '/home';
  static const kotpView = '/otpView';

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
      GoRoute(path: invtation,
      builder: (context, state) => const InvtaionUser()),

      GoRoute(path: oneTimeInvitation,
          builder: (context, state) => const InvtaionUser()),
    ],
  );
}
