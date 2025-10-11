import 'package:dart_jsonwebtoken/dart_jsonwebtoken.dart';

class TokenGenerator {
  TokenGenerator._();
  static final TokenGenerator _instance = TokenGenerator._();
  static TokenGenerator get instance => _instance;

  final _secretKey =
      'f5aeb76da1c1205c9d64bccf34333f98d9a1fbf313137abaa9bc0fa275bdba86';

  String generateJwtToken(String address) {
    final expiresAt = DateTime.now().add(Duration(hours: 1));

    final payload = {
      'address': address,
      'timestamp': DateTime.now().millisecondsSinceEpoch,
      'exp': expiresAt.millisecondsSinceEpoch ~/ 1000,
    };

    final jwt = JWT(payload);
    return jwt.sign(SecretKey(_secretKey));
  }

  Duration? getRemainingDuration(String token) {
    try {
      final jwt = JWT.verify(token, SecretKey(_secretKey));
      final exp = jwt.payload['exp'];
      final expiryTime = DateTime.fromMillisecondsSinceEpoch(exp * 1000);
      final remaining = expiryTime.difference(DateTime.now());
      return remaining.isNegative ? Duration.zero : remaining;
    } catch (e) {
      return null; // invalid or expired
    }
  }

  bool isTokenValid(String token) {
    try {
      JWT.verify(token, SecretKey(_secretKey));
      return true;
    } catch (e) {
      return false;
    }
  }
}
