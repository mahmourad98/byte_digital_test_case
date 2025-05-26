import 'package:byte_digital_test_case/data/repository/auth_repository.dart';
import 'package:byte_digital_test_case/main_app.dart';
import 'package:flutter/material.dart';
import 'product_listing/product_listing_screen.dart';


class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key,});
  @override State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  late final emailController = TextEditingController();
  late final passwordController = TextEditingController();

  @override void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override Widget build(BuildContext context,) {
    return Scaffold(
      appBar: AppBar(title: Text('Login')),
      body: Center(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextFormField(
                controller: emailController,
                decoration: InputDecoration(labelText: 'Email'),
              ),
              TextFormField(
                controller: passwordController,
                decoration: InputDecoration(labelText: 'Password'),
                obscureText: true,
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  AuthRepository.loginCustomer(
                    emailController.text,
                    passwordController.text,
                  ).then((_) {
                    navigatorKey.currentState!.pushReplacement(
                      MaterialPageRoute(builder: (_,) => ProductListingScreen(),),
                    );
                  });
                },
                child: Text('Login'),
              ),
              Text('', style: TextStyle(color: Colors.red)), // Placeholder for error messages
            ],
          ),
        ),
      ),
    );
  }
}