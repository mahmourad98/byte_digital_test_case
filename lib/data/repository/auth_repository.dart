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
        final data = json.decode(response.body);

        if (data['errors'] != null) {
          throw Exception('GraphQL Error: ${data['errors']}');
        }

        final customerAccessToken = Map.of(data['data']['customerAccessTokenCreate']['customerAccessToken']).cast<String, dynamic>();
        dev.log('customer login success.', name: "Auth Repo - loginCustomer()",);
        return customerAccessToken['accessToken'] as String;
      } else {
        throw Exception('HTTP Error: ${response.statusCode}');
      }
    } catch (e, stackTrace) {
      dev.log('', name: "Auth Repo - loginCustomer()", error: e, stackTrace: stackTrace,);
      throw Error.throwWithStackTrace(e, stackTrace,);
    }
  }

  static Future<Customer> registerCustomer(Customer input,) async{
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
            'input': input.toJson(),
          },
        }),
      );

      if (response.statusCode == HttpStatus.ok && response.body.isNotEmpty) {
        final data = Map.of(json.decode(response.body)).cast<String, dynamic>();

        if (data['errors'] != null) {
          throw Exception('GraphQL Error: ${data['errors']}');
        }

        final customerRaw = Map.of(data['data']['customerCreate']['customer']).cast<String, dynamic>();
        dev.log('customer register success.', name: "Auth Repo - registerCustomer()",);
        return Customer.fromJson(customerRaw,);
      } else {
        throw Exception('HTTP Error: ${response.statusCode}');
      }
    } catch (e, stackTrace) {
      dev.log('', name: "Auth Repo - registerCustomer()", error: e, stackTrace: stackTrace,);
      throw Error.throwWithStackTrace(e, stackTrace,);
    }
  }
}