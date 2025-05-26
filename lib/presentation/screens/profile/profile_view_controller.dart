import 'package:byte_digital_test_case/data/entities/customer.dart';
import 'package:byte_digital_test_case/data/repository/auth_repository.dart';
import 'package:byte_digital_test_case/services/shared_prefs_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ProfileState {
  final bool isLoading;
  final Customer? customer;
  final String? error;

  ProfileState({
    this.isLoading = false,
    this.customer,
    this.error,
  });

  ProfileState copyWith({
    bool? isLoading,
    Customer? customer,
    String? error,
  }) {
    return ProfileState(
      isLoading: isLoading ?? this.isLoading,
      customer: customer ?? this.customer,
      error: error,
    );
  }
}

// The view controller using StateNotifier
class ProfileViewController extends StateNotifier<ProfileState> {
  final AuthRepository repository;

  ProfileViewController(this.repository) : super(ProfileState());

  Future<void> fetchCustomer() async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      final accessToken = await _getAccessToken();
      final customer = await repository.fetchCustomer(accessToken,);
      state = state.copyWith(isLoading: false, customer: customer, error: null);
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
    }
  }

  Future<String> _getAccessToken() async {
    final token = await SharedPrefsService.getToken();
    if (token == null || token.isEmpty) {
      throw Exception('Access token is not available.');
    }
    return token;
  }
}