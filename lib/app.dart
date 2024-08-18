
import 'package:book_store/ui/screens/authen/splash_screen.dart';
import 'package:flutter/material.dart';
import 'ui/utility/app_color.dart';


class OldBookSellingApp extends StatelessWidget {
  const OldBookSellingApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const SplashScreen(),
      theme: lightThemeData(),
    );
  }
  ThemeData lightThemeData(){
    return ThemeData(
        inputDecorationTheme: InputDecorationTheme(
            fillColor: Colors.white,
            filled: true,
            hintStyle: TextStyle(color: Colors.grey.shade400),
            border: const OutlineInputBorder(
                borderSide: BorderSide.none),
        ),
        textTheme: const TextTheme(
          titleLarge: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: Colors.deepPurpleAccent,
          ),
          bodyLarge: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: Colors.black,
          ),
          titleMedium: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: Colors.black,
          ),
          titleSmall: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: Colors.grey,
            letterSpacing: 0.4,
          ),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.themeColor,
              padding: const EdgeInsets.symmetric(vertical: 12),
              foregroundColor: AppColors.white,
              fixedSize: const Size.fromWidth(double.maxFinite),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8)
              ),
            ),
        ),
    );
  }
}

