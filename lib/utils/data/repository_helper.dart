import 'package:flutter_dotenv/flutter_dotenv.dart';

mixin RepositoryHelper {
   String get baseUrl => dotenv.get('BASE_URL');
   String get storefrontAccessToken => dotenv.get('STORE_ACCESS_TOKEN');
}