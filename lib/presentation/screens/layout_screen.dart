import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:kontrol_app/config/utils/helper.dart';
// import 'package:kontrol_app/domain/entities/user_session.dart';
// import 'package:kontrol_app/presentation/providers/logbook/logbook_provider.dart';
import 'package:kontrol_app/presentation/providers/providers.dart';
import 'package:kontrol_app/presentation/views/views.dart';
import 'package:kontrol_app/presentation/widgets/widgets.dart';
import 'package:kontrol_app/service/pending_request_service.dart';

class LayoutScreen extends ConsumerStatefulWidget {
  static const name = 'home-screen';

  const LayoutScreen({super.key});

  @override
  ConsumerState<LayoutScreen> createState() => _LayoutScreenState();
}

class _LayoutScreenState extends ConsumerState<LayoutScreen> {
  final viewRoutes = const <Widget>[LayoutView(), Placeholder(), Placeholder()];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(AppLifecycleObserver());
    Future.microtask(() {
      ref.read(homeTabProvider.notifier).state = 0;
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // ref.listen<AsyncValue<User?>>(userSessionProvider, (previous, next) {
    //   if (previous?.value != null && next.value == null) {
    //     ScaffoldMessenger.of(context).showSnackBar(
    //       const SnackBar(
    //         content: Text('Sesión no válida. Vuelva a iniciar sesión'),
    //       ),
    //     );

    //     context.go('/login');
    //   }
    // });

    
    ref.listen<GlobalInterceptorDioProvider?>(globalMessageProvider, (prev, next) {
      if (next != null) {
        scaffoldMessengerKey.currentState?.showSnackBar(
          SnackBar(
            content: Text(next.text),
            backgroundColor: next.isError ? Colors.red : Colors.green,
            duration: const Duration(seconds: 7),
          ),
        );

        ref.read(globalMessageProvider.notifier).clear();
      }
    });

    final index = ref.watch(homeTabProvider);
    return Scaffold(
      // appBar: PreferredSize(
      //   preferredSize: const Size.fromHeight(300),
      //   child: const CustomAppbar(),
      // ),
      // resizeToAvoidBottomInset: false,
      backgroundColor: const Color.fromARGB(255, 255, 255, 255),
      body: SafeArea(
        top: false,
        // bottom: false,
        child: IndexedStack(
          //Widget para conservar el estado de la pagina (ej Si hace scroll dejarlo tal cual)
          index: index,
          children: viewRoutes,
        ),
      ),
      bottomNavigationBar: CustomBottomNavigation(
        currentIndex: index,
        onTap: (i) {
          ref.read(homeTabProvider.notifier).state = i;
          
          // if (i == 0) {
          //   ref.read(getHistoryLogbooks.notifier).load();
          // }
        },
      ),
    );
  }
}
