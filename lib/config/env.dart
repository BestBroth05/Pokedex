import 'package:flutter_dotenv/flutter_dotenv.dart';

mixin Environment {
  // Keys required
  static String get fileName => '.env';
  static String get baseUrl => dotenv.env['BASE_URL'] ?? '';
}
