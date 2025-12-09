import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'providers/transactions_provider.dart';
import 'services/transactions_service.dart';
import 'services/streak_service.dart';
import 'screens/home_screen.dart';
import 'styles/colors.dart';

/// Inicialización de la app
///
/// Flujo de inicio:
/// 1. Inicializa Hive y abre las boxes necesarias (TransactionsService + StreakService)
/// 2. Inicializa formato de fechas en español
/// 3. Crea el Provider con los servicios ya inicializados
/// 4. Lanza la app
void main() async {
  // Necesario para operaciones asíncronas antes de runApp
  WidgetsFlutterBinding.ensureInitialized();

  // Inicializar servicios de storage local (Hive)
  await TransactionsService.instance.init();
  await StreakService.instance.init();

  // Inicializar formato de fechas en español
  await initializeDateFormatting('es_ES', null);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Envolver la app con Provider para gestión de estado global
    return ChangeNotifierProvider(
      create: (_) => TransactionsProvider(),
      child: MaterialApp(
        title: 'Miauni',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(
            seedColor: AppColors.teal,
            surface: AppColors.background,
          ),
          useMaterial3: true,
          fontFamily: 'Roboto',
        ),
        // Configuración de locale para español
        locale: const Locale('es', 'ES'),
        home: const HomeScreen(),
      ),
    );
  }
}
