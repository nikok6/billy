//redirect to home_screen.dart
import 'package:flutter/material.dart';
import 'package:splitbill/screens/confirm_scanned_receipt.dart';
import 'package:splitbill/screens/sign_up_screen.dart';
import 'package:splitbill/screens/tabs.dart';


void main() {
  runApp(const App());
}

class App extends StatelessWidget {
  const App({Key? key}) : super(key: key);
  static const String _title = 'Split Bill';

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: _title,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: const ColorScheme.dark(
          // primary: Color(0xFFA0E871),
          // secondary: Color(0xFF173301),
          primary: Color(0xFF64CCC5),
          secondary: Color(0xFF001C30),
          background: Color(0xFF121212),
          onBackground: Color(0xFFFFFFFF),
          surface: Color(0xFF1E1E1E),
          onSurface: Color(0xFFFFFFFF),
          onSurfaceVariant: Color(0xFF2C2C2C),
          brightness: Brightness.dark,
          error: Color(0xFFFFB4AB),
          errorContainer: Color(0xFF93000A),
          inversePrimary: Color(0xFF2F6C00),
          inverseSurface: Color(0xFFE3E3DC),
          onError: Color(0xFF690005),
          onErrorContainer: Color(0xFFFFB4AB),
          onInverseSurface: Color(0xFF2F312C),
          onPrimary: Color(0xFF173301),
          onPrimaryContainer: Color(0xFF2E2E2E),
          onSecondary: Color(0xFFFFFFFF),
          onSecondaryContainer: Color(0xFF0A2100),
          shadow: Color(0xFF000000),
          surfaceTint: Color(0xFF1E1E1E),
        ),
        textTheme: const TextTheme(
          bodyLarge: TextStyle(color: Colors.white, fontFamily: 'Poppins', fontSize: 25, fontWeight: FontWeight.w600),
          bodyMedium: TextStyle(color: Colors.white, fontFamily: 'Poppins', fontSize: 16),
          bodySmall: TextStyle(color: Colors.white, fontFamily: 'Poppins', fontSize: 12),
          titleLarge: TextStyle(color: Colors.white, fontFamily: 'Poppins', fontSize: 20),

          //button
          titleMedium: TextStyle(color: Color(0xFF001C30), fontFamily: 'Poppins', fontSize: 14, fontWeight: FontWeight.w500),
          labelMedium: TextStyle(color: Color(0xFF64CCC5), fontFamily: 'Poppins', fontSize: 14, fontWeight: FontWeight.w500),

          //gray text
          labelSmall: TextStyle(color: Color(0xFFDDDDDD), fontFamily: 'Poppins', fontSize: 12),
          labelLarge: TextStyle(color: Color(0xFFDDDDDD), fontFamily: 'Poppins', fontSize: 16), 
        ),
      ),
      home: const TabsScreen(),
    );
  }
}
