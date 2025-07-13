import 'dart:convert';
import 'package:flutter/material.dart';


import 'package:encrypt/encrypt.dart' as encrypt;

String decodeEscapedBase64(String escapedBase64) {
  // لو فيه \uXXXX أو escape chars نحلها بنفس فكرة JSON.parse من JS
  // في Dart ممكن نستبدل بطريقة بسيطة:
  // لكن لو النص عادي Base64 مش escaped، نرجع النص كما هو.
  try {
    // JSON decode will convert escaped unicode sequences
    return json.decode('"$escapedBase64"');
  } catch (_) {
    return escapedBase64;
  }
}

String decryptAesCbc({
  required String encryptedTextEscapedBase64,
  required String base64Key,
  required String base64IV,
}) {
  try {
    final encryptedBase64 = decodeEscapedBase64(encryptedTextEscapedBase64);

    final key = encrypt.Key.fromBase64(base64Key);
    final iv = encrypt.IV.fromBase64(base64IV);

    final encrypter = encrypt.Encrypter(
      encrypt.AES(key, mode: encrypt.AESMode.cbc, padding: 'PKCS7'),
    );

    final encryptedBytes = encrypt.Encrypted.fromBase64(encryptedBase64);

    final decrypted = encrypter.decrypt(encryptedBytes, iv: iv);

    return decrypted.isNotEmpty ? decrypted : '[❌ Empty or invalid output]';
  } catch (e) {
    return '[❌ Error] ${e.toString()}';
  }
}

class DecryptScreen extends StatefulWidget {
  const DecryptScreen({super.key});

  @override
  State<DecryptScreen> createState() => _DecryptScreenState();
}

class _DecryptScreenState extends State<DecryptScreen> {
  final TextEditingController _encryptedController = TextEditingController();
  final TextEditingController _keyController = TextEditingController(text: 'kX4t8zL7pQ9rW3mB2vN6yF0xJ5hK1cG8eD9aT2uR4sV=');
  final TextEditingController _ivController = TextEditingController(text: 'GawgguFyGrWKav7AX4VKUg==');

  String _decryptedText = '';

  String decodeEscapedBase64(String escapedBase64) {
    try {
      return json.decode('"$escapedBase64"');
    } catch (_) {
      return escapedBase64;
    }
  }

  void decrypt() {
    final encryptedInput = _encryptedController.text.trim();
    final keyInput = _keyController.text.trim();
    final ivInput = _ivController.text.trim();

    try {
      final encryptedBase64 = decodeEscapedBase64(encryptedInput);

      final key = encrypt.Key.fromBase64(keyInput);
      final iv = encrypt.IV.fromBase64(ivInput);

      final encrypter = encrypt.Encrypter(
        encrypt.AES(key, mode: encrypt.AESMode.cbc, padding: 'PKCS7'),
      );

      final encryptedBytes = encrypt.Encrypted.fromBase64(encryptedBase64);

      final decrypted = encrypter.decrypt(encryptedBytes, iv: iv);

      setState(() {
        _decryptedText = decrypted.isNotEmpty ? decrypted : '[❌ Empty or invalid output]';
      });
    } catch (e) {
      setState(() {
        _decryptedText = '[❌ Error] ${e.toString()}';
      });
    }
  }

  @override
  void dispose() {
    _encryptedController.dispose();
    _keyController.dispose();
    _ivController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('AES-CBC Decryptor')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: _encryptedController,
              maxLines: 5,
              decoration: const InputDecoration(
                labelText: 'Encrypted Data (Base64, escaped)',
                border: OutlineInputBorder(),
                hintText: r'Paste encrypted text (escaped Base64) here...',
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _keyController,
              decoration: const InputDecoration(
                labelText: 'Encryption Key (Base64)',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _ivController,
              decoration: const InputDecoration(
                labelText: 'IV (Base64)',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: decrypt,
              icon: const Icon(Icons.lock_open),
              label: const Text('Decrypt'),
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 48),
              ),
            ),
            const SizedBox(height: 24),
            Align(
              alignment: Alignment.centerLeft,
              child: const Text(
                'Decrypted Output:',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
            ),
            const SizedBox(height: 8),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey.shade400),
                borderRadius: BorderRadius.circular(6),
                color: Colors.grey.shade100,
              ),
              child: SelectableText(
                _decryptedText,
                style: TextStyle(
                  color: _decryptedText.startsWith('[❌ Error]')
                      ? Colors.red
                      : Colors.green.shade700,
                  fontSize: 14,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}