import 'package:flutter/material.dart';
import 'package:transport_app/core/constants/app_colors.dart';
import 'package:transport_app/feature/auth/screens/register.dart';
import 'package:transport_app/feature/home/screens/home_page.dart';

import '../../../core/constants/app_text_styles.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  // Controllers: to read what the user typed
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  // true = hide password, false = show password
  bool _hidePassword = true;

  // Always dispose controllers when the page is closed
  @override
  void dispose() {
    _phoneController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  // Called when user presses the login button
  void _onLoginPressed() {
    final phone = _phoneController.text;
    final password = _passwordController.text;
    debugPrint('Phone: $phone, Password: $password');
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const HomePage(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      body: SafeArea(
        // Scroll view so the keyboard will not cause overflow
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 60),

                // ---------- Logo ----------
                Center(
                  child: Image.asset(
                    'assets/icon/logoApp.png',
                    width: 130,
                    height: 130,
                  ),
                ),

                const SizedBox(height: 16),

                // ---------- Welcome text ----------
                Center(
                  child: Text(
                    'ចូលប្រើប្រាស់',
                    style: AppTextStyles.heading2.copyWith(
                      color: Colors.white,
                    ),
                  ),
                ),

                const SizedBox(height: 48),

                // ---------- Phone label ----------
                const Text(
                  'លេខទូរស័ព្ទ',
                  style: TextStyle(color: Colors.white, fontSize: 16),
                ),

                const SizedBox(height: 8),

                // ---------- Phone input ----------
                TextField(
                  controller: _phoneController,
                  keyboardType: TextInputType.phone,
                  style: const TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    hintText: 'បញ្ចូលលេខទូរស័ព្ទ',
                    hintStyle: const TextStyle(color: AppColors.textSecondary),
                    prefixIcon: const Icon(
                      Icons.phone_outlined,
                      color: AppColors.textSecondary,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: const BorderSide(color: AppColors.cardLen),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: const BorderSide(color: AppColors.cardLen),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide:
                      const BorderSide(color: AppColors.primaryColor),
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                // ---------- Password label + Forgot password ----------
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'ពាក្យសម្ងាត់',
                      style: TextStyle(color: Colors.white, fontSize: 16),
                    ),
                    GestureDetector(
                      onTap: () {
                        // TODO: go to forgot password page
                      },
                      child: const Text(
                        'ភ្លេចពាក្យសម្ងាត់?',
                        style: TextStyle(
                          color: AppColors.primaryColor,
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 8),

                // ---------- Password input ----------
                TextField(
                  controller: _passwordController,
                  obscureText: _hidePassword,
                  style: const TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    hintText: 'បញ្ចូលពាក្យសម្ងាត់',
                    hintStyle: const TextStyle(color: AppColors.textSecondary),
                    prefixIcon: const Icon(
                      Icons.lock_outline,
                      color: AppColors.textSecondary,
                    ),
                    // Eye icon to show / hide password
                    suffixIcon: IconButton(
                      icon: Icon(
                        _hidePassword
                            ? Icons.visibility_off_outlined
                            : Icons.visibility_outlined,
                        color: AppColors.textSecondary,
                      ),
                      onPressed: () {
                        setState(() {
                          _hidePassword = !_hidePassword;
                        });
                      },
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: const BorderSide(color: AppColors.cardLen),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: const BorderSide(color: AppColors.cardLen),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide:
                      const BorderSide(color: AppColors.primaryColor),
                    ),
                  ),
                ),

                const SizedBox(height: 24),

                // ---------- Login button ----------
                SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: ElevatedButton(
                    onPressed: _onLoginPressed,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primaryColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'ចូលគណនី',
                          style: TextStyle(color: Colors.white, fontSize: 18),
                        ),
                        SizedBox(width: 8),
                        Icon(Icons.arrow_forward, color: Colors.white),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 16),

                // ---------- Divider with text "or continue with" ----------
                Row(
                  children: [
                    const Expanded(child: Divider(color: AppColors.cardLen)),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      child: const Text(
                        'ឬបន្តជាមួយ',
                        style: TextStyle(color: AppColors.textSecondary),
                      ),
                    ),
                    const Expanded(child: Divider(color: AppColors.cardLen)),
                  ],
                ),

                const SizedBox(height: 16),

                // ---------- Google button ----------
                SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: OutlinedButton(
                    onPressed: () {
                      // TODO: Google sign in
                    },
                    style: OutlinedButton.styleFrom(
                      backgroundColor: Colors.white,
                      side: const BorderSide(color: Color(0xFFDADCE0), width: 1),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                    ),
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        // Google logo on the left
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Image.asset(
                            'assets/icon/google.png',
                            width: 32,
                            height: 32,
                          ),
                        ),
                        // Centered text
                        const Text(
                          'Continue with Google',
                          style: TextStyle(
                            color: Color(0xFF3C4043),
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 40),

                // ---------- Register text ----------
                Center(
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text(
                        'មិនទាន់មានគណនីមែនទេ? ',
                        style: TextStyle(color: AppColors.textSecondary),
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const RegisterPage(),
                            ),
                          );
                        },
                        child: const Text(
                          'ចុះឈ្មោះ',
                          style: TextStyle(
                            color: AppColors.primaryColor,
                            decoration: TextDecoration.underline,
                            decorationColor: AppColors.primaryColor,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}