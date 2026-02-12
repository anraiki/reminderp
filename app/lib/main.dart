import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'providers/reminder_provider.dart';
import 'screens/home_screen.dart';
import 'services/db_service.dart';
import 'services/notification_service.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await NotificationService.instance.initialize();
  final dbService = DbService();
  await dbService.init();

  runApp(
    ProviderScope(
      overrides: [dbServiceProvider.overrideWithValue(dbService)],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Reminderp',
      theme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: const Color(0xFF1A202C),
        colorScheme: const ColorScheme.dark(
          surface: Color(0xFF1A202C),
          primary: Color(0xFF319795),
          onPrimary: Colors.white,
          secondary: Color(0xFF805AD5),
          onSecondary: Colors.white,
          tertiary: Color(0xFF48BB78),
          surfaceContainerHighest: Color(0xFF2D3748),
          onSurface: Color(0xFFE2E8F0),
          onSurfaceVariant: Color(0xFFA0AEC0),
          outline: Color(0xFF4A5568),
          error: Color(0xFFFC8181),
          onError: Color(0xFF1A202C),
        ),
        cardTheme: const CardThemeData(
          color: Color(0xFF2D3748),
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(8)),
          ),
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF2D3748),
          foregroundColor: Color(0xFFE2E8F0),
          elevation: 0,
        ),
        floatingActionButtonTheme: const FloatingActionButtonThemeData(
          backgroundColor: Color(0xFF319795),
          foregroundColor: Colors.white,
        ),
        chipTheme: ChipThemeData(
          backgroundColor: const Color(0xFF2D3748),
          selectedColor: const Color(0xFF319795),
          labelStyle: const TextStyle(color: Color(0xFFE2E8F0)),
          side: BorderSide(color: const Color(0xFF4A5568)),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: const Color(0xFF2D3748),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: const BorderSide(color: Color(0xFF4A5568)),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: const BorderSide(color: Color(0xFF4A5568)),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: const BorderSide(color: Color(0xFF319795), width: 2),
          ),
          labelStyle: const TextStyle(color: Color(0xFFA0AEC0)),
          hintStyle: const TextStyle(color: Color(0xFF718096)),
          prefixIconColor: const Color(0xFFA0AEC0),
          suffixIconColor: const Color(0xFFA0AEC0),
        ),
        filledButtonTheme: FilledButtonThemeData(
          style: FilledButton.styleFrom(
            backgroundColor: const Color(0xFF319795),
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        ),
        drawerTheme: const DrawerThemeData(
          backgroundColor: Color(0xFF1A202C),
          surfaceTintColor: Colors.transparent,
        ),
        dividerTheme: const DividerThemeData(color: Color(0xFF4A5568)),
        textTheme: const TextTheme(
          titleMedium: TextStyle(
            color: Color(0xFFE2E8F0),
            fontWeight: FontWeight.w600,
          ),
          bodyLarge: TextStyle(color: Color(0xFFE2E8F0)),
          bodyMedium: TextStyle(color: Color(0xFFA0AEC0)),
        ),
      ),
      home: const HomeScreen(),
    );
  }
}
