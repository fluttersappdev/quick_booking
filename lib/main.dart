import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:quick_booking/screens/route_stops_screen.dart';
import 'package:quick_booking/screens/splash_screen.dart';
import 'package:quick_booking/utils/app_theme.dart';

void main() {
  runApp(
    const ProviderScope(  // Add ProviderScope here
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Route Stops & Booking',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      initialRoute: SplashScreen.routeName,
      routes: {
        SplashScreen.routeName: (context) => const SplashScreen(),
        RouteStopsScreen.routeName: (context) => const RouteStopsScreen(),
      },
    );
  }
}