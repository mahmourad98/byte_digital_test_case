class Customer {
  final String firstName;
  final String lastName;
  final String email;
  final String phone;
  final String? createdAt;
  final bool acceptsMarketing;

  Customer({
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.phone,
    this.createdAt,
    this.acceptsMarketing = true,
  });

  factory Customer.fromJson(Map<String, dynamic> json) {
    return Customer(
      firstName: json['firstName'] ?? '',
      lastName: json['lastName'] ?? '',
      email: json['email'] ?? '',
      phone: json['phone'] ?? '',
      createdAt: json['createdAt'],
      acceptsMarketing: json['acceptsMarketing'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'firstName': firstName,
      'lastName': lastName,
      'email': email,
      'phone': phone,
      'createdAt': createdAt,
      'acceptsMarketing': acceptsMarketing,
    };
  }
}