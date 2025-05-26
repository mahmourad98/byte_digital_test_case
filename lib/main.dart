import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'main_app.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  ErrorWidget.builder = _buildErrorWidget;
  if(Platform.isAndroid) HttpOverrides.global = _GeneralHttpOverrides();
  runApp(ProviderScope(child: const MainApp()));
}

Widget _buildErrorWidget(FlutterErrorDetails details) {
  return FractionallySizedBox(
    child: Center(
      child: Text(
        'An error occurred: ${details.exception}',
        style: TextStyle(color: Colors.red),
      ),
    ),
  );
}

class _GeneralHttpOverrides extends HttpOverrides {
  @override HttpClient createHttpClient(SecurityContext? context,) {
    return super.createHttpClient(context,)..badCertificateCallback = (_, __, ___,) => true;
  }
}