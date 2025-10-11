import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecureStorageService {
  static final SecureStorageService instance = SecureStorageService._internal();
  factory SecureStorageService() => instance;
  SecureStorageService._internal();

  final FlutterSecureStorage _storage = const FlutterSecureStorage();

  static const String _walletAddressKey = 'wallet_address';
  static const String _jwtTokenKey = 'jwt_token';
  static const String _walletUriKey = 'wallet_uri';
  static const String _verificationStatusKey =
      'verification_status'; // ✅ New key

  // Save wallet address
  Future<void> saveWalletAddress(String address) async {
    await _storage.write(key: _walletAddressKey, value: address);
  }

  // Get wallet address
  Future<String?> getWalletAddress() async {
    return await _storage.read(key: _walletAddressKey);
  }

  // Save JWT token
  Future<void> saveJwtToken(String token) async {
    await _storage.write(key: _jwtTokenKey, value: token);
  }

  // Get JWT token
  Future<String?> getJwtToken() async {
    return await _storage.read(key: _jwtTokenKey);
  }

  // ✅ Save wallet URI
  Future<void> saveWalletUri(String uri) async {
    await _storage.write(key: _walletUriKey, value: uri);
  }

  // ✅ Get wallet URI
  Future<String?> getWalletUri() async {
    return await _storage.read(key: _walletUriKey);
  }

  // Clear all stored data
  Future<void> clearAll() async {
    await _storage.deleteAll();
  }

  // Save verification status
  Future<void> saveVerificationStatus(bool isVerified) async {
    await _storage.write(
      key: _verificationStatusKey,
      value: isVerified.toString(),
    );
  }

  // Get verification status
  Future<String?> getVerificationStatus() async {
    return await _storage.read(key: _verificationStatusKey);
  }
}
