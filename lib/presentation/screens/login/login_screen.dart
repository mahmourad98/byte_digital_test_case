import 'dart:async';

import 'package:byte_digital_test_case/data/repository/auth_repository.dart';
import 'package:byte_digital_test_case/main_app.dart';
import 'package:byte_digital_test_case/presentation/screens/register/register_screen.dart';
import 'package:byte_digital_test_case/services/shared_prefs_service.dart';
import 'package:byte_digital_test_case/utils/presentation/dialog_helper.dart';
import 'package:byte_digital_test_case/utils/presentation/toast_helper.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';

import '../product-listing/product_listing_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key,});
  @override State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  late final _formKey = GlobalKey<FormBuilderState>();
  late final _hidePassword = ValueNotifier<bool>(true);
  late final _emailController = TextEditingController();
  late final _passwordController = TextEditingController();

  @override void dispose() {
    _hidePassword.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override Widget build(BuildContext context,) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Login',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(16.0),
          child: FormBuilder(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                FormBuilderTextField(
                  name: 'email',
                  controller: _emailController,
                  decoration: InputDecoration(labelText: 'Email'),
                  validator: FormBuilderValidators.compose([
                    FormBuilderValidators.required(),
                    FormBuilderValidators.email(),
                  ]),
                ),
                ValueListenableBuilder<bool>(
                  valueListenable: _hidePassword,
                  builder: (_, showPassword, __) {
                    return FormBuilderTextField(
                      name: 'password',
                      controller: _passwordController,
                      decoration: InputDecoration(
                        labelText: 'Password',
                        suffixIcon: Builder(
                          builder: (_) {
                            return IconButton(
                              icon: Icon(
                                showPassword ? Icons.visibility : Icons.visibility_off,
                              ),
                              onPressed: () => _hidePassword.value = !_hidePassword.value,
                            );
                          },
                        ),
                      ),
                      obscureText: _hidePassword.value,
                      validator: FormBuilderValidators.compose([
                        FormBuilderValidators.required(),
                        FormBuilderValidators.password(),
                        FormBuilderValidators.minLength(8, errorText: 'Password must be at least 8 characters long'),
                      ]),
                    );
                  },
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    _formKey.currentState!.save();
                    if (_formKey.currentState!.validate()) {
                      FocusScope.of(context).unfocus();
                      return unawaited(
                        showLoadingDialog<String>(
                          future: () => AuthRepository().loginCustomer(
                            _emailController.text,
                            _passwordController.text,
                          ),
                          dialogBuilder: (_,) => AlertDialog(
                            content: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                CircularProgressIndicator(),
                                SizedBox(width: 20),
                                Text('Logging in...'),
                              ],
                            ),
                          ),
                        ).then((String token) {
                          return SharedPrefsService.saveToken(token).then((_) {
                            ToastHelper.showSuccessToast('Logged in successfully!');
                            navigatorKey.currentState!.pushReplacement(
                              MaterialPageRoute(builder: (_,) => ProductListingScreen(),),
                            );
                          });
                        }).onError((error, stackTrace) {
                          return ToastHelper.showErrorToast(error.toString());
                        }),
                      );
                    }
                  },
                  child: Text(
                    'Login',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                SizedBox(height: 20),
                Text.rich(
                  TextSpan(
                    text: 'Don\'t have an account? ',
                    style: TextStyle(fontSize: 16,),
                    children: [
                      TextSpan(
                        text: 'Register',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.blue,
                        ),
                        recognizer: TapGestureRecognizer()
                          ..onTap = () {
                            navigatorKey.currentState!.push(
                              MaterialPageRoute(builder: (_,) => RegisterScreen(),),
                            );
                          },
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}