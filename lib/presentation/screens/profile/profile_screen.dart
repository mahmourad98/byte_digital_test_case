import 'dart:async';

import 'package:byte_digital_test_case/data/repository/auth_repository.dart';
import 'package:byte_digital_test_case/main_app.dart';
import 'package:byte_digital_test_case/presentation/screens/login/login_screen.dart';
import 'package:byte_digital_test_case/presentation/widgets/user_info_item.dart';
import 'package:byte_digital_test_case/services/shared_prefs_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'profile_view_controller.dart';

final profileViewControllerProvider = StateNotifierProvider<ProfileViewController, ProfileState>((ref) {
  final repository = AuthRepository();
  return ProfileViewController(repository);
});

class UserAccountScreen extends ConsumerStatefulWidget {

  const UserAccountScreen({super.key,});

  @override ConsumerState<UserAccountScreen> createState() => _UserAccountScreenState();
}

class _UserAccountScreenState extends ConsumerState<UserAccountScreen> {

  @override void initState() {
    super.initState();
    // Fetch products when the screen is initialized
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(profileViewControllerProvider.notifier).fetchCustomer();
    });
  }

  @override Widget build(BuildContext context) {
    final state = ref.watch(profileViewControllerProvider);
    return Scaffold(
      appBar: AppBar(
        title: Text('My Account', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
      ),
      body: Builder(
        builder: (_) {
          if(state.isLoading) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else if(state.error != null) {
            return Center(
              child: Text(
                'Error: ${state.error}',
                style: TextStyle(
                  color: Colors.red,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            );
          } else if(state.customer == null) {
            return Center(
              child: Text(
                'No user data available!',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey[700],
                ),
              ),
            );
          } else {
            final dateFormatted = DateFormat('yyyy-MM-dd HH:mm').format(
              DateTime.parse(state.customer!.createdAt!).toLocal(),
            );
            return ListView(
              children: [
                UserInfoItem(
                  label: 'First Name',
                    value: state.customer!.firstName,
                ),
                UserInfoItem(
                  label: 'Last Name',
                  value: state.customer!.lastName
                ),
                UserInfoItem(
                  label: 'Email',
                  value: state.customer!.email
                ),
                UserInfoItem(
                  label: 'Registration Date',
                  value: dateFormatted,
                ),
                SizedBox(height: 20),
                Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        return unawaited(SharedPrefsService.clearToken().then((_) {
                          navigatorKey.currentState!.pushAndRemoveUntil(
                            MaterialPageRoute(builder: (_,) => LoginScreen(),),
                            (Route route) => false,
                          );
                        }));
                      },
                      child: Text(
                        'Logout',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            );
          }
        },
      ),
    );
  }
}