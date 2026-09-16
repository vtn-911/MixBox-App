import 'package:flutter/material.dart';
import 'package:mixboxapp/screens/signin_screen.dart';
import 'package:mixboxapp/service/auth_service.dart';

class AuthGuard {
  static Future<bool> requireAuth(BuildContext context) async {
    final token = await AuthService.getToken();

    final isLoggedIn = token != null && token.isNotEmpty;

    if (isLoggedIn) {
      return true;
    }

    if (!context.mounted) {
      return false;
    }

    final shouldSignIn = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('Login required'),
          content: const Text('You need to sign in to view document details.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(dialogContext, false);
              },
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(dialogContext, true);
              },
              child: const Text('Sign in'),
            ),
          ],
        );
      },
    );

    if (shouldSignIn == true) {
      if (!context.mounted) {
        return false;
      }

      await Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const SigninScreen()),
      );

      // Kiểm tra lại sau khi quay về từ SigninScreen
      final newToken = await AuthService.getToken();

      return newToken != null && newToken.isNotEmpty;
    }

    return false;
  }
}
