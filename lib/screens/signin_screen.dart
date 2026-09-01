import 'package:flutter/material.dart';
import 'package:mixboxapp/screens/signup_screen.dart';
import 'package:mixboxapp/screens/user_screen.dart';

import '../service/auth_service.dart';

class SigninScreen extends StatefulWidget {
  const SigninScreen({super.key});

  @override
  State<SigninScreen> createState() => _SigninScreenState();
}

class _SigninScreenState extends State<SigninScreen> {
  bool _obscurePassword = true;
  bool _rememberMe = false;

  TextEditingController emailController = TextEditingController();

  TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF8F9FA),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            child: Container(
              constraints: const BoxConstraints(maxWidth: 400),
              padding: const EdgeInsets.all(32),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.04),
                    blurRadius: 24,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Title & Subtitle
                  const Text(
                    'MixBox',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Color(0xff3525CD),
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Sign in to continue to your workspace.',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Color(0xff464555), fontSize: 14),
                  ),
                  const SizedBox(height: 28),
                  // Email Input
                  const Text(
                    'Email address',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: Color(0xff1E1E24),
                    ),
                  ),
                  const SizedBox(height: 8),
                  _inputEmail(),
                  const SizedBox(height: 20),
                  // Password Input
                  const Text(
                    'Password',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: Color(0xff1E1E24),
                    ),
                  ),
                  const SizedBox(height: 8),
                  _inputPassword(),
                  const SizedBox(height: 16),
                  // Remember Me & Forgot Password
                  _remember_forgotPass(),
                  const SizedBox(height: 24),
                  // Sign In Button
                  _signInBtn(),
                  const SizedBox(height: 24),
                  // Sign Up Link
                  _signUpLink(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  TextField _inputPassword() {
    return TextField(
      controller: passwordController,
      obscureText: _obscurePassword,
      decoration: InputDecoration(
        hintText: '••••••••',
        hintStyle: const TextStyle(color: Color(0xff8E8E93), letterSpacing: 2),
        filled: true,
        fillColor: const Color(0xffF8F9FA),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 14,
        ),
        suffixIcon: IconButton(
          icon: Icon(
            _obscurePassword
                ? Icons.visibility_outlined
                : Icons.visibility_off_outlined,
            color: const Color(0xff464555),
          ),
          onPressed: () {
            setState(() {
              _obscurePassword = !_obscurePassword;
            });
          },
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: Color(0xffE2E4E9)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: Color(0xffE2E4E9)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: Color(0xffC7C4D8), width: 1.5),
        ),
      ),
    );
  }

  TextField _inputEmail() {
    return TextField(
      controller: emailController,
      keyboardType: TextInputType.emailAddress,
      decoration: InputDecoration(
        hintText: 'you@example.com',
        hintStyle: const TextStyle(color: Color(0xff8E8E93)),
        filled: true,
        fillColor: const Color(0xffF8F9FA),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 14,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: Color(0xffE2E4E9)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: Color(0xffE2E4E9)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: Color(0xffC7C4D8), width: 1.5),
        ),
      ),
    );
  }

  Row _remember_forgotPass() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            SizedBox(
              width: 20,
              height: 20,
              child: Checkbox(
                value: _rememberMe,
                activeColor: const Color(0xff3525CD),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(4),
                ),
                side: const BorderSide(color: Color(0xffD0D5DD)),
                onChanged: (value) {
                  setState(() {
                    _rememberMe = value ?? false;
                  });
                },
              ),
            ),
            const SizedBox(width: 8),
            const Text(
              'Remember me',
              style: TextStyle(fontSize: 14, color: Color(0xff464555)),
            ),
          ],
        ),
        GestureDetector(
          onTap: () {},
          child: const Text(
            'Forgot password?',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Color(0xff3525CD),
            ),
          ),
        ),
      ],
    );
  }

  Future<void> login() async {
    try {
      final result = await AuthService.login(
        emailController.text.trim(),
        passwordController.text,
      );
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => UserScreen(user: result.user)),
      );
    } catch (e) {
      print('LOGIN ERROR: $e');
    }
  }

  ElevatedButton _signInBtn() {
    return ElevatedButton(
      onPressed: login,
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xff3525CD),
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(vertical: 14),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        elevation: 0,
      ),
      child: const Text(
        'Sign In',
        style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
      ),
    );
  }

  Row _signUpLink() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text(
          "Don't have an account? ",
          style: TextStyle(color: Color(0xff464555), fontSize: 14),
        ),
        GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const SignupScreen()),
            );
          },
          child: const Text(
            'Create one',
            style: TextStyle(
              color: Color(0xff3525CD),
              fontWeight: FontWeight.w600,
              fontSize: 14,
            ),
          ),
        ),
      ],
    );
  }
}
