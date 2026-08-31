import 'package:flutter/material.dart';
import 'package:mixboxapp/screens/signin_screen.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  bool _agreeToTerms = false;
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;

  InputDecoration _buildInputDecoration({
    required String hintText,
    required IconData prefixIcon,
    Widget? suffixIcon,
  }) {
    return InputDecoration(
      hintText: hintText,
      hintStyle: const TextStyle(color: Color(0xffA0AEC0), fontSize: 14),
      prefixIcon: Icon(prefixIcon, color: const Color(0xffA0AEC0), size: 20),
      suffixIcon: suffixIcon,
      filled: true,
      fillColor: const Color(0xffF8F9FA),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
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
        borderSide: const BorderSide(color: Color(0xff3525CD), width: 1.5),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF8F9FA),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            child: Container(
              constraints: const BoxConstraints(maxWidth: 420),
              padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 32),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 20,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Title & Description
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
                    'Create an account to start organizing your studies.',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Color(0xff464555), fontSize: 14),
                  ),
                  const SizedBox(height: 20),

                  // Avatar Picker Button
                  _avatarPickerBtn(),
                  const SizedBox(height: 24),
                  // Full Name
                  const Text(
                    'Full Name',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: Color(0xff1E1E24),
                    ),
                  ),
                  const SizedBox(height: 6),
                  TextField(
                    decoration: _buildInputDecoration(
                      hintText: 'Jane Doe',
                      prefixIcon: Icons.person_outline,
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Email Address
                  const Text(
                    'Email Address',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: Color(0xff1E1E24),
                    ),
                  ),
                  const SizedBox(height: 6),
                  TextField(
                    keyboardType: TextInputType.emailAddress,
                    decoration: _buildInputDecoration(
                      hintText: 'jane@example.com',
                      prefixIcon: Icons.mail_outline,
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Password
                  const Text(
                    'Password',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: Color(0xff1E1E24),
                    ),
                  ),
                  const SizedBox(height: 6),
                  TextField(
                    obscureText: _obscurePassword,
                    decoration: _buildInputDecoration(
                      hintText: '••••••••',
                      prefixIcon: Icons.lock_outline,
                    ),
                  ),
                  const SizedBox(height: 6),
                  const Text(
                    'Must be at least 8 characters with numbers and symbols.',
                    style: TextStyle(fontSize: 12, color: Color(0xff464555)),
                  ),
                  const SizedBox(height: 16),

                  // Confirm Password
                  const Text(
                    'Confirm Password',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: Color(0xff1E1E24),
                    ),
                  ),
                  const SizedBox(height: 6),
                  TextField(
                    obscureText: _obscureConfirmPassword,
                    decoration: _buildInputDecoration(
                      hintText: '••••••••',
                      prefixIcon: Icons.history,
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Terms & Conditions Checkbox
                  _policyCheckbox(),
                  const SizedBox(height: 20),

                  // Create Account Button
                  _btnCreateAcc(),
                  const SizedBox(height: 20),

                  // Already have an account? Sign In
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        'Already have an account? ',
                        style: TextStyle(
                          color: Color(0xff464555),
                          fontSize: 14,
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const SigninScreen(),
                            ),
                          );
                        },
                        child: const Text(
                          'Sign In',
                          style: TextStyle(
                            color: Color(0xff3525CD),
                            fontWeight: FontWeight.w600,
                            fontSize: 14,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  ElevatedButton _btnCreateAcc() {
    return ElevatedButton(
      onPressed: () {},
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xff3525CD),
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(vertical: 14),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        elevation: 0,
      ),
      child: const Text(
        'Create Account',
        style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
      ),
    );
  }

  Row _policyCheckbox() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 20,
          height: 20,
          child: Checkbox(
            value: _agreeToTerms,
            activeColor: const Color(0xff3525CD),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(4),
            ),
            side: const BorderSide(color: Color(0xffD0D5DD)),
            onChanged: (value) {
              setState(() {
                _agreeToTerms = value ?? false;
              });
            },
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: RichText(
            text: const TextSpan(
              style: TextStyle(
                fontSize: 13,
                color: Color(0xff464555),
                height: 1.4,
              ),
              children: [
                TextSpan(text: 'I agree to the '),
                TextSpan(
                  text: 'Terms and Conditions',
                  style: TextStyle(
                    color: Color(0xff3525CD),
                    fontWeight: FontWeight.w500,
                  ),
                ),
                TextSpan(text: ' and '),
                TextSpan(
                  text: 'Privacy Policy',
                  style: TextStyle(
                    color: Color(0xff3525CD),
                    fontWeight: FontWeight.w500,
                  ),
                ),
                TextSpan(text: '.'),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Center _avatarPickerBtn() {
    return Center(
      child: Stack(
        alignment: Alignment.center,
        children: [
          Container(
            width: 64,
            height: 64,
            decoration: BoxDecoration(
              color: const Color(0xffF0F2F5),
              shape: BoxShape.circle,
              border: Border.all(
                color: const Color(0xffD0D5DD),
                style: BorderStyle.none,
              ),
            ),
            child: RawMaterialButton(
              onPressed: () {},
              shape: const CircleBorder(),
              child: const Icon(
                Icons.add_a_photo_outlined,
                color: Color(0xff667085),
                size: 26,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
