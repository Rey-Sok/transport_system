import 'package:flutter/material.dart';
import 'package:transport_app/core/constants/app_colors.dart';
import 'package:transport_app/feature/auth/screens/login.dart';
import '../../../core/constants/app_sizes.dart';
import '../../../core/constants/app_text_styles.dart';

class WelcomePage extends StatefulWidget {
  const WelcomePage({super.key});

  @override
  State<WelcomePage> createState() {
    return WelcomeState();
  }
}

class WelcomeState extends State<WelcomePage> {
  // Default selected language
  String selectedLanguage = 'km';

  // Change language
  void selectLanguage(String language) {
    setState(() {
      selectedLanguage = language;
    });
  }

  // Continue button
  void onContinue() {
    debugPrint('Selected language: $selectedLanguage');
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => LoginPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,

      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: AppSizes.peddingY,
            vertical: AppSizes.peddingX,
          ),
          child: Column(
            children: [
              const SizedBox(height: 60),

              // App Logo
              Image.asset('assets/icon/logoApp.png', width: 130, height: 130),

              const SizedBox(height: 16),

              // Welcome Title
              Text(
                'Welcome to CamRide',
                style: AppTextStyles.heading2.copyWith(color: Colors.white),
              ),

              const SizedBox(height: 12),

              // Subtitle
              Text(
                'Please select your preferred language',
                style: AppTextStyles.body.copyWith(
                  color: Colors.white.withValues(alpha: 0.7),
                ),
              ),

              const Spacer(),

              // Khmer Language
              Material(
                color: Colors.transparent,
                borderRadius: BorderRadius.circular(18),

                child: InkWell(
                  borderRadius: BorderRadius.circular(18),

                  onTap: () {
                    selectLanguage('km');
                  },

                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(18),

                    decoration: BoxDecoration(
                      color: AppColors.cardLen,
                      borderRadius: BorderRadius.circular(18),

                      border: Border.all(
                        color: selectedLanguage == 'km'
                            ? AppColors.secondaryColor
                            : AppColors.borderCard,
                        width: 2,
                      ),
                    ),

                    child: Row(
                      children: [
                        const Text('🇰🇭', style: TextStyle(fontSize: 32)),

                        const SizedBox(width: 16),

                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'ភាសាខ្មែរ',
                                style: AppTextStyles.heading3.copyWith(
                                  color: Colors.white,
                                ),
                              ),

                              Text(
                                'Khmer',
                                style: AppTextStyles.label.copyWith(
                                  color: Colors.white70,
                                ),
                              ),
                            ],
                          ),
                        ),

                        // Show check icon
                        if (selectedLanguage == 'km')
                          const Icon(
                            Icons.check_circle,
                            color: AppColors.primaryColor,
                            size: 28,
                          ),
                      ],
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 16),

              // English Language
              Material(
                color: Colors.transparent,
                borderRadius: BorderRadius.circular(18),

                child: InkWell(
                  borderRadius: BorderRadius.circular(18),

                  onTap: () {
                    selectLanguage('en');
                  },

                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(18),

                    decoration: BoxDecoration(
                      color: AppColors.cardLen,
                      borderRadius: BorderRadius.circular(18),

                      border: Border.all(
                        color: selectedLanguage == 'en'
                            ? AppColors.secondaryColor
                            : AppColors.borderCard,
                        width: 2,
                      ),
                    ),

                    child: Row(
                      children: [
                        const Text('🇬🇧', style: TextStyle(fontSize: 32)),

                        const SizedBox(width: 16),

                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'English',
                                style: AppTextStyles.heading3.copyWith(
                                  color: Colors.white,
                                ),
                              ),

                              Text(
                                'English',
                                style: AppTextStyles.label.copyWith(
                                  color: Colors.white70,
                                ),
                              ),
                            ],
                          ),
                        ),

                        // Show check icon
                        if (selectedLanguage == 'en')
                          const Icon(
                            Icons.check_circle,
                            color: AppColors.primaryColor,
                            size: 28,
                          ),
                      ],
                    ),
                  ),
                ),
              ),

              const Spacer(),

              // Continue Button
              SizedBox(
                width: double.infinity,
                height: 68,

                child: ElevatedButton(
                  onPressed: onContinue,

                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryColor,
                    foregroundColor: Colors.white,
                    elevation: 0,

                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),

                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('Continue', style: AppTextStyles.button),

                      const SizedBox(width: 8),

                      const Icon(Icons.arrow_forward, size: 24),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 8),
            ],
          ),
        ),
      ),
    );
  }
}
