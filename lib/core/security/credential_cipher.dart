import 'dart:convert';
import 'dart:math';
import 'dart:typed_data';

import 'package:cryptography/cryptography.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class PasswordHash {
  const PasswordHash({required this.hash, required this.salt});

  final String hash;
  final String salt;
}

class CredentialCipher {
  CredentialCipher({FlutterSecureStorage? secureStorage})
    : _secureStorage = secureStorage ?? const FlutterSecureStorage();

  static const _encryptionKeyStorageKey = 'auth_encryption_key';
  static final _cipher = AesGcm.with256bits();
  static final _pbkdf2 = Pbkdf2(
    macAlgorithm: Hmac.sha256(),
    iterations: 100000,
    bits: 256,
  );
  static final _random = Random.secure();

  final FlutterSecureStorage _secureStorage;
  SecretKey? _encryptionKey;

  Future<PasswordHash> hashPassword(String password, {String? salt}) async {
    final saltBytes = salt != null ? base64Decode(salt) : _randomBytes(16);
    final secretKey = await _pbkdf2.deriveKeyFromPassword(
      password: password,
      nonce: saltBytes,
    );
    final hashBytes = await secretKey.extractBytes();
    return PasswordHash(
      hash: base64Encode(hashBytes),
      salt: base64Encode(saltBytes),
    );
  }

  Future<bool> verifyPassword({
    required String password,
    required String expectedHash,
    required String salt,
  }) async {
    final passwordHash = await hashPassword(password, salt: salt);
    return _constantTimeCompare(passwordHash.hash, expectedHash);
  }

  Future<String> encrypt(String value) async {
    final key = await _loadOrCreateEncryptionKey();
    final nonce = _randomBytes(12);
    final clearBytes = utf8.encode(value);
    final secretBox = await _cipher.encrypt(
      clearBytes,
      secretKey: key,
      nonce: nonce,
    );
    final payload = jsonEncode({
      'n': base64Encode(secretBox.nonce),
      'c': base64Encode(secretBox.cipherText),
      'm': base64Encode(secretBox.mac.bytes),
    });
    return payload;
  }

  Future<String> decrypt(String payload) async {
    final key = await _loadOrCreateEncryptionKey();
    final map = jsonDecode(payload) as Map<String, dynamic>;
    final nonce = base64Decode(map['n'] as String);
    final cipherText = base64Decode(map['c'] as String);
    final mac = Mac(base64Decode(map['m'] as String));
    final secretBox = SecretBox(cipherText, nonce: nonce, mac: mac);
    final clearBytes = await _cipher.decrypt(secretBox, secretKey: key);
    return utf8.decode(clearBytes);
  }

  Future<SecretKey> _loadOrCreateEncryptionKey() async {
    if (_encryptionKey != null) {
      return _encryptionKey!;
    }
    final stored = await _secureStorage.read(key: _encryptionKeyStorageKey);
    if (stored != null) {
      final bytes = base64Decode(stored);
      _encryptionKey = SecretKey(bytes);
      return _encryptionKey!;
    }
    final bytes = _randomBytes(32);
    await _secureStorage.write(
      key: _encryptionKeyStorageKey,
      value: base64Encode(bytes),
    );
    _encryptionKey = SecretKey(bytes);
    return _encryptionKey!;
  }

  Uint8List _randomBytes(int length) {
    final data = List<int>.generate(length, (_) => _random.nextInt(256));
    return Uint8List.fromList(data);
  }

  bool _constantTimeCompare(String a, String b) {
    final aBytes = utf8.encode(a);
    final bBytes = utf8.encode(b);
    if (aBytes.length != bBytes.length) {
      return false;
    }
    var diff = 0;
    for (var i = 0; i < aBytes.length; i++) {
      diff |= aBytes[i] ^ bBytes[i];
    }
    return diff == 0;
  }
}
