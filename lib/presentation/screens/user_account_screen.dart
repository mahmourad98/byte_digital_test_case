import 'package:flutter/material.dart';
import '../widgets/user_info_item.dart';

class UserAccountScreen extends StatelessWidget {
  // Sample user data for UI demonstration
  final String firstName = 'John';
  final String lastName = 'Doe';
  final String email = 'john@example.com';
  final String registrationDate = '2023-01-01';

  const UserAccountScreen({super.key});

  @override Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('My Account')),
      body: ListView(
        children: [
          UserInfoItem(label: 'First Name', value: firstName),
          UserInfoItem(label: 'Last Name', value: lastName),
          UserInfoItem(label: 'Email', value: email),
          UserInfoItem(label: 'Registration Date', value: registrationDate),
        ],
      ),
    );
  }
}