import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:kontrol_app/config/router/app_router.dart';
import 'package:kontrol_app/config/theme/app_theme.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kontrol_app/config/utils/helper.dart';
import 'package:kontrol_app/service/local_storage.dart';
import 'package:kontrol_app/service/pending_request_service.dart';
import 'package:kontrol_app/presentation/widgets/shared/sync_listener.dart';
import 'package:kontrol_app/presentation/providers/sync_pending/sync_pending_provider.dart';

final syncService = SyncService();

Future<void> main() async {
  await dotenv.load(fileName: '.env');
  WidgetsFlutterBinding.ensureInitialized();
  await initHive();
  
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent, // no pinta fondo
      statusBarIconBrightness: Brightness.dark, // Android
      statusBarBrightness: Brightness.dark, // iOS
    ),
  );

    runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends ConsumerStatefulWidget {
  const MyApp({super.key});

  @override
  ConsumerState<MyApp> createState() => _MyAppState();
}

class _MyAppState extends ConsumerState<MyApp> {
  late AppLifecycleObserver _lifecycleObserver;
  // final scaffoldMessengerKeyy = GlobalKey<ScaffoldMessengerState>();

  @override
  void initState() {
    super.initState();

    // 🔄 Callback para sincronizar cuando hay internet
    void onSyncNeeded() {
      print('📡 Internet disponible, iniciando sincronización...');
      ref.read(syncPendingProvider.notifier).sync();
    }

    // 🔄 Inicializar el SyncService con el callback
    // syncService.start(onSyncNeeded: onSyncNeeded);

    // 👁️ Registrar el lifecycle observer para sincronizar cuando el app vuelve a primer plano
    _lifecycleObserver = AppLifecycleObserver(
      onResume: () {
      print('📱 App resumed, verificando sincronización...');
      onSyncNeeded;
    });
    WidgetsBinding.instance.addObserver(_lifecycleObserver);
  }

  @override
  void dispose() {
    // syncService.dispose();
    WidgetsBinding.instance.removeObserver(_lifecycleObserver);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SyncListener(
      child: MaterialApp.router(
        scaffoldMessengerKey: scaffoldMessengerKey,
        routerConfig: appRouter,
        debugShowCheckedModeBanner: false,
        theme: AppTheme().getTheme(),
      ),
    );
  }
}
