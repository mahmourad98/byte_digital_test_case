import 'dart:async';

import 'package:byte_digital_test_case/data/entities/customer.dart';
import 'package:byte_digital_test_case/data/repository/auth_repository.dart';
import 'package:byte_digital_test_case/main_app.dart';
import 'package:byte_digital_test_case/utils/presentation/dialog_helper.dart';
import 'package:byte_digital_test_case/utils/presentation/toast_helper.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  late final _formKey = GlobalKey<FormBuilderState>();
  late final _hidePassword = ValueNotifier<bool>(true);
  late final _firstNameController = TextEditingController();
  late final _lastNameController = TextEditingController();
  late final _emailController = TextEditingController();
  late final _phoneNumberController = TextEditingController();
  late final _passwordController = TextEditingController();

  @override void dispose() {
    _hidePassword.dispose();
    _firstNameController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();
    _phoneNumberController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override Widget build(BuildContext context) {
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
                  name: 'firstName',
                  decoration: InputDecoration(labelText: 'First Name'),
                  controller: _firstNameController,
                  validator: FormBuilderValidators.compose([
                    FormBuilderValidators.required(),
                    FormBuilderValidators.alphabetical(),
                  ]),
                ),
                FormBuilderTextField(
                  name: 'lastName',
                  decoration: InputDecoration(labelText: 'Last Name'),
                  controller: _lastNameController,
                  validator: FormBuilderValidators.compose([
                    FormBuilderValidators.required(),
                    FormBuilderValidators.alphabetical(),
                  ]),
                ),
                FormBuilderTextField(
                  name: 'email',
                  controller: _emailController,
                  decoration: InputDecoration(labelText: 'Email'),
                  validator: FormBuilderValidators.compose([
                    FormBuilderValidators.required(),
                    FormBuilderValidators.email(),
                  ]),
                ),
                FormBuilderTextField(
                  name: 'phoneNumber',
                  decoration: InputDecoration(labelText: 'Phone Number'),
                  controller: _phoneNumberController,
                  validator: FormBuilderValidators.compose([
                    FormBuilderValidators.required(),
                    FormBuilderValidators.phoneNumber(),
                    FormBuilderValidators.minLength(8, errorText: 'Password must be at least 8 characters long'),
                  ]),
                ),
                ValueListenableBuilder<bool>(
                  valueListenable: _hidePassword,
                  builder: (_, showPassword, __) {
                    return FormBuilderTextField(
                      name: 'password',
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
                      controller: _passwordController,
                      obscureText: showPassword,
                      validator: FormBuilderValidators.compose([
                        FormBuilderValidators.required(),
                        FormBuilderValidators.password(minLength: 8,),
                      ]),
                    );
                  },
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    _formKey.currentState!.save();
                    if (_formKey.currentState!.validate()) {
                      return unawaited(
                        showLoadingDialog(
                          future: () => AuthRepository().registerCustomer(
                            Customer(
                              firstName: _firstNameController.text,
                              lastName: _lastNameController.text,
                              email: _emailController.text,
                              phone: _phoneNumberController.text,
                            ),
                            _passwordController.text,
                          ),
                          dialogBuilder: (_,) => AlertDialog(
                            content: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                CircularProgressIndicator(),
                                SizedBox(width: 20),
                                Text('Registering...'),
                              ],
                            ),
                          ),
                        ).then((Customer customer) {
                          ToastHelper.showSuccessToast('Registration successful!, please login.');
                          navigatorKey.currentState!.pop();
                        }).onError((error, stackTrace) {
                          ToastHelper.showErrorToast(error.toString());
                        }),
                      );
                    } else {
                      // Handle validation errors
                      _formKey.currentState?.validate();
                    }
                  },
                  child: Text(
                    'Register',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                SizedBox(height: 20),
                Text.rich(
                  TextSpan(
                    text: 'Have an account? ',
                    style: TextStyle(fontSize: 16,),
                    children: [
                      TextSpan(
                        text: 'Login',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.blue,
                        ),
                        recognizer: TapGestureRecognizer()
                          ..onTap = () {
                            navigatorKey.currentState!.pop();
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
