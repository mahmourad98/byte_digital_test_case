import 'dart:io';

import 'package:byte_digital_test_case/services/shared_prefs_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'main_app.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  ErrorWidget.builder = _buildErrorWidget;
  if(Platform.isAndroid) HttpOverrides.global = _GeneralHttpOverrides();
  final token = await SharedPrefsService.getToken();

  runApp(
    ProviderScope(
      child: MainApp(
        isLoggedIn: token != null && token.isNotEmpty,
      ),
    ),
  );
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