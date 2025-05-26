// ignore_for_file: constant_identifier_names
import 'dart:convert';
import 'dart:io';
import 'dart:developer' as dev;
import 'package:http/http.dart' as http;
import '../entities/customer.dart';

class AuthRepository {
  static const String _storefrontAccessToken = '588cbc282ac14029ba9be06b811e8fcc';

  static String get _baseUrl => 'https://mahmourad.myshopify.com/api/2025-04/graphql.json';

  static const String CUSTOMER_REGISTER_MUTATION = '''
    mutation customerCreate(\$input: CustomerCreateInput!) {
      customerCreate(input: \$input) {
        customer {
          firstName
          lastName
          email
          phone
          acceptsMarketing
        }
        customerUserErrors {
          field
          message
          code
        }
      }
    }
  ''';

  static const String CUSTOMER_LOGIN_MUTATION = '''
    mutation customerAccessTokenCreate(\$email: String!, \$password: String!) { 
      customerAccessTokenCreate(input: {email: \$email, password: \$password}) { 
        customerAccessToken { accessToken } 
        customerUserErrors { message } 
      } 
    }
  ''';

  static const String CUSTOMER_DATA_MUTATION = '''
    query customer(\$accessToken: String!) {
      customer(customerAccessToken: \$accessToken) {
        id
        firstName
        lastName
        acceptsMarketing
        email
        phone
      }
    }
  ''';

  static Future<String> loginCustomer(String email, String password,) async{
    try {
      final response = await http.post(
        Uri.parse(_baseUrl),
        headers: {
          'Content-Type': 'application/json',
          'X-Shopify-Storefront-Access-Token': _storefrontAccessToken,
        },
        body: json.encode({
          'query': CUSTOMER_LOGIN_MUTATION,
          'variables': {
            'email': email,
            'password': password,
          },
        }),
      );

      if (response.statusCode == HttpStatus.ok && response.body.isNotEmpty) {
        final body = Map.of(json.decode(response.body)).cast<String, dynamic>();
        body.handleErrorIfExist();

       final customerUserErrors = List.of(body['data']?['customerAccessTokenCreate']?['customerUserErrors'] ?? []).map((e) => Map.of(e).cast<String, dynamic>()).toList();
        if (customerUserErrors.isNotEmpty) {
          throw Exception(customerUserErrors.map((e) => e['message']).join(', '));
        }

        dev.log('customer login success.', name: "Auth Repo - loginCustomer()",);
        final customerAccessToken = Map.of(body['data']!['customerAccessTokenCreate']!['customerAccessToken']!).cast<String, dynamic>();
        final token = customerAccessToken['accessToken'] as String;
        return token;
      } else {
        throw Exception('HTTP Error: ${response.statusCode}');
      }
    } catch (e, stackTrace) {
      dev.log('', name: "Auth Repo - loginCustomer()", error: e, stackTrace: stackTrace,);
      throw Error.throwWithStackTrace(e, stackTrace,);
    }
  }

  static Future<Customer> registerCustomer(Customer input, String password) async{
    try {
      final response = await http.post(
        Uri.parse(_baseUrl),
        headers: {
          'Content-Type': 'application/json',
          'X-Shopify-Storefront-Access-Token': _storefrontAccessToken,
        },
        body: json.encode({
          'query': CUSTOMER_REGISTER_MUTATION,
          'variables': {
            'input': input.toJson()..addAll({
              'password': password,
            }),
          },
        }),
      );

      if (response.statusCode == HttpStatus.ok && response.body.isNotEmpty) {
        final body = Map.of(json.decode(response.body)).cast<String, dynamic>();
        body.handleErrorIfExist();

        final customerUserErrors = List.of(body['data']?['customerCreate']?['customerUserErrors'] ?? []).map((e) => Map.of(e).cast<String, dynamic>()).toList();
        if (customerUserErrors.isNotEmpty) {
          throw Exception(customerUserErrors.map((e) => e['message']).join(', '));
        }

        dev.log('customer register success.', name: "Auth Repo - registerCustomer()",);
        final customerRaw = Map.of(body['data']!['customerCreate']!['customer']!).cast<String, dynamic>();
        final customer = Customer.fromJson(customerRaw,);
        return customer;
      } else {
        throw Exception('HTTP Error: ${response.statusCode}');
      }
    } catch (e, stackTrace) {
      dev.log('', name: "Auth Repo - registerCustomer()", error: e, stackTrace: stackTrace,);
      throw Error.throwWithStackTrace(e, stackTrace,);
    }
  }

  static Future<Customer> fetchCustomer(String accessToken,) async{
    try {
      final response = await http.post(
        Uri.parse(_baseUrl),
        headers: {
          'Content-Type': 'application/json',
          'X-Shopify-Storefront-Access-Token': _storefrontAccessToken,
        },
        body: json.encode({
          'query': CUSTOMER_DATA_MUTATION,
          'variables': {
            'accessToken': accessToken,
          },
        }),
      );

      if (response.statusCode == HttpStatus.ok && response.body.isNotEmpty) {
        final body = Map.of(json.decode(response.body)).cast<String, dynamic>();
        body.handleErrorIfExist();

        if (body['data']?['customer'] == null) {
          throw Exception('Customer not found or access token is invalid.');
        }

        dev.log('customer fetch success.', name: "Auth Repo - fetchCustomer()",);
        final customerRaw = Map.of(body['data']!['customer']!).cast<String, dynamic>();
        final customer = Customer.fromJson(customerRaw,);
        return customer;
      } else {
        throw Exception('HTTP Error: ${response.statusCode}');
      }
    } catch (e, stackTrace) {
      dev.log('', name: "Auth Repo - fetchCustomer()", error: e, stackTrace: stackTrace,);
      throw Error.throwWithStackTrace(e, stackTrace,);
    }
  }
}

extension _ErrorHandling on Map<String, dynamic> {
  void handleErrorIfExist() {
    if (containsKey('errors') && this['errors'] != null) {
      final errors = List.of(this['errors']).map((e) => Map.of(e).cast<String, dynamic>()).toList();
      throw Exception(errors.map((e) => e['message']).join(', '));
    }
  }
}