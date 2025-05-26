import 'package:flutter/material.dart';

class UserInfoItem extends StatelessWidget {
  final String label;
  final String value;

  const UserInfoItem({super.key, required this.label, required this.value});

  @override Widget build(BuildContext context) {
    return ListTile(
      title: Text(label),
      subtitle: Text(value),
    );
  }
}