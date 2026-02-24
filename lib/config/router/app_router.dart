import 'package:kontrol_app/presentation/screens/screens.dart';
import 'package:go_router/go_router.dart';

final appRouter = GoRouter(
  initialLocation: '/',
  routes: [
    // GoRoute(
    //   path: '/splash',
    //   name: SplashScreen.name,
    //   builder: (context, state) => const SplashScreen(),
    // ),
    // GoRoute(
    //   path: '/login',
    //   name: 'login-screen',
    //   builder: (context, state) => const LoginScreen(),
    // ),
    GoRoute(
      path: '/',
      name: LayoutScreen.name,
      builder: (context, state) => const LayoutScreen(),
      routes: [
        
      ]
    ),

    GoRoute(
      path: '/',
      redirect: (_, __) => '/',
    )

  ]
);