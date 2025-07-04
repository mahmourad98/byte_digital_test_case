import 'package:flutter/material.dart';

import 'presentation/screens/login/login_screen.dart';
import 'presentation/screens/product-listing/product_listing_screen.dart';

final navigatorKey = GlobalKey<NavigatorState>();

class MainApp extends StatelessWidget {
  final bool isLoggedIn;
  const MainApp({super.key, this.isLoggedIn = false});

  @override Widget build(BuildContext context,) {
    return MaterialApp(
      navigatorKey: navigatorKey,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.blue,
          brightness: Brightness.light,
        ),
        useMaterial3: true,
      ),
      home: isLoggedIn ? ProductListingScreen() : const LoginScreen(),
    );
  }
}