import 'package:flutter/material.dart';
import 'package:transport_app/core/constants/app_colors.dart';
import 'package:transport_app/feature/home/screens/home_page.dart';

import '../../../core/constants/app_sizes.dart';
import '../../../core/constants/app_text_styles.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  // ---------- Controllers (to read what the user typed) ----------
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _birthDateController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
  TextEditingController();

  // ---------- Other values ----------
  final List<String> _genders = ['ប្រុស', 'ស្រី', 'ផ្សេងទៀត'];
  int _selectedGender = 0; // 0 = ប្រុស
  bool _hidePassword = true;
  bool _hideConfirmPassword = true;
  bool _acceptTerms = true;

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _birthDateController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  // ---------- Open the calendar and pick a date ----------
  Future<void> _pickBirthDate() async {
    final DateTime? picked = await _showCalendar(
      initialDate: DateTime(2000, 5, 15),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );

    // picked is null if the user closes the calendar
    if (picked != null) {
      setState(() {
        _birthDateController.text = _formatDate(picked);
      });
    }
  }

  // ---------- Called when user presses the register button ----------
  void _onRegisterPressed() {
    if (!_acceptTerms) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('សូមយល់ព្រមតាមលក្ខខណ្ឌជាមុនសិន')),
      );
      return;
    }

    if (_passwordController.text != _confirmPasswordController.text) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('ពាក្យសម្ងាត់មិនដូចគ្នា')),
      );
      return;
    }

    print('First name: ${_firstNameController.text}');
    print('Last name: ${_lastNameController.text}');
    print('Gender: ${_genders[_selectedGender]}');
    print('Birth date: ${_birthDateController.text}');
    print('Phone: ${_phoneController.text}');
    print('Email: ${_emailController.text}');
    // TODO: call your register API here

    Navigator.pushReplacement(context,
    MaterialPageRoute(builder: (context) => const HomePage()));
  }

  // ---------- One decoration for all text fields (so we don't repeat) ----------
  InputDecoration _inputDecoration({
    required String hint,
    required IconData icon,
    Widget? suffixIcon,
  }) {
    return InputDecoration(
      hintText: hint,
      hintStyle: const TextStyle(color: AppColors.textSecondary),
      prefixIcon: Icon(icon, color: AppColors.textSecondary),
      suffixIcon: suffixIcon,
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
        borderSide: const BorderSide(color: AppColors.primaryColor),
      ),
    );
  }

  // ---------- Label text above each field ----------
  Widget _buildLabel(String text) {
    return Text(
      text,
      style: const TextStyle(color: Colors.white, fontSize: 16),
    );
  }

  Future<DateTime?> _showCalendar({
    required DateTime initialDate,
    required DateTime firstDate,
    DateTime? lastDate,
  }) {
    final today = DateUtils.dateOnly(DateTime.now());
    return showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: firstDate.isAfter(DateTime(1800)) ? firstDate : DateTime(1800),
      lastDate: lastDate ?? DateUtils.addMonthsToMonthDate(today, 24),
      builder: (context, child) {
        final theme = Theme.of(context);
        return Center(
          child: Transform.scale(
            scale: 0.9,
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 360),
              child: Theme(
                data: theme.copyWith(
                  colorScheme: const ColorScheme.light(
                    primary: AppColors.primaryColor,
                    onPrimary: AppColors.textOnPrimary,
                    surface: AppColors.surfaceColor,
                    onSurface: AppColors.textColor,
                  ),
                  datePickerTheme: DatePickerThemeData(
                    backgroundColor: AppColors.surfaceColor,
                    headerBackgroundColor: AppColors.primaryColor,
                    headerForegroundColor: AppColors.textOnPrimary,
                    headerHelpStyle: const TextStyle(
                      color: Colors.white70,
                      fontSize: AppSizes.fontSM,
                    ),
                    headerHeadlineStyle: const TextStyle(
                      color: AppColors.textOnPrimary,
                      fontSize: AppSizes.font2XL,
                      fontWeight: FontWeight.w600,
                    ),
                    weekdayStyle: const TextStyle(
                      color: AppColors.textSecondary,
                      fontSize: AppSizes.fontXS,
                      fontWeight: FontWeight.w600,
                    ),
                    dayStyle: const TextStyle(
                      color: AppColors.textColor,
                      fontSize: AppSizes.fontMD,
                      fontWeight: FontWeight.w500,
                    ),
                    dayForegroundColor: WidgetStateProperty.resolveWith((
                        states,
                        ) {
                      if (states.contains(WidgetState.selected) ||
                          states.contains(WidgetState.hovered) ||
                          states.contains(WidgetState.pressed)) {
                        return AppColors.textOnPrimary;
                      }
                      if (states.contains(WidgetState.disabled)) {
                        return AppColors.textSecondary;
                      }
                      return AppColors.textColor;
                    }),
                    dayBackgroundColor: WidgetStateProperty.resolveWith((
                        states,
                        ) {
                      if (states.contains(WidgetState.selected) ||
                          states.contains(WidgetState.hovered) ||
                          states.contains(WidgetState.pressed)) {
                        return AppColors.primaryColor;
                      }
                      return null;
                    }),
                    todayForegroundColor: WidgetStateProperty.resolveWith((
                        states,
                        ) {
                      if (states.contains(WidgetState.selected) ||
                          states.contains(WidgetState.hovered) ||
                          states.contains(WidgetState.pressed)) {
                        return AppColors.textOnPrimary;
                      }
                      return AppColors.primaryColor;
                    }),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(AppSizes.lg),
                    ),
                    cancelButtonStyle: TextButton.styleFrom(
                      foregroundColor: AppColors.primaryColor,
                    ),
                    confirmButtonStyle: TextButton.styleFrom(
                      foregroundColor: AppColors.primaryColor,
                    ),
                  ),
                ),
                child: child!,
              ),
            ),
          ),
        );
      },
    );
  }

  // Format date as dd-MM-yyyy
  String _formatDate(DateTime d) {
    return '${d.day.toString().padLeft(2, '0')}-''${d.month.toString().padLeft(2, '0')}-''${d.year}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: AppSizes.peddingY, vertical: AppSizes.peddingX),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 40),

                // ---------- Logo ----------
                Center(
                  child: Image.asset(
                    'assets/icon/logoApp.png',
                    width: 130,
                    height: 130,
                  ),
                ),

                const SizedBox(height: 16),

                // ---------- Title ----------
                Center(
                  child: Text(
                    'បង្កើតគណនី',
                    style: AppTextStyles.heading2.copyWith(
                      color: Colors.white,
                    ),
                  ),
                ),

                const SizedBox(height: 32),

                // ---------- First name + Last name (side by side) ----------
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // First name
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildLabel('នាមត្រកូល'),
                          const SizedBox(height: 8),
                          TextField(
                            controller: _firstNameController,
                            style: const TextStyle(color: Colors.white),
                            decoration: _inputDecoration(
                              hint: 'នាមត្រកូល',
                              icon: Icons.person_outline,
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(width: 20),

                    // Last name
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildLabel('នាមខ្លួន'),
                          const SizedBox(height: 8),
                          TextField(
                            controller: _lastNameController,
                            style: const TextStyle(color: Colors.white),
                            decoration: _inputDecoration(
                              hint: 'នាមខ្លួន',
                              icon: Icons.person_outline,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 20),

                // ---------- Gender ----------
                _buildLabel('ភេទ'),
                const SizedBox(height: 8),

                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: AppColors.cardLen),
                  ),
                  child: Row(
                    children: [
                      for (int i = 0; i < _genders.length; i++)
                        Expanded(
                          child: GestureDetector(
                            onTap: () {
                              setState(() {
                                _selectedGender = i;
                              });
                            },
                            child: Container(
                              height: 44,
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(14),
                                gradient: _selectedGender == i
                                    ? const LinearGradient(
                                  colors: [
                                    AppColors.primaryColor,
                                    AppColors.secondaryColor,
                                  ],
                                )
                                    : null,
                              ),
                              child: Text(
                                _genders[i],
                                style: TextStyle(
                                  fontSize: 16,
                                  color: _selectedGender == i
                                      ? Colors.white
                                      : AppColors.textSecondary,
                                ),
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                ),

                const SizedBox(height: 20),

                // ---------- Birth date (label + small hint on the right) ----------
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _buildLabel('ថ្ងៃខែឆ្នាំកំណើត'),
                    const Text(
                      'ជ្រើសរើសថ្ងៃកំណើត',
                      style: TextStyle(
                        color: AppColors.textSecondary,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),

                TextField(
                  controller: _birthDateController,
                  readOnly: true, // user can't type, only pick from calendar
                  onTap: _pickBirthDate,
                  style: const TextStyle(color: Colors.white),
                  decoration: _inputDecoration(
                    hint: 'ថ្ងៃ/ខែ/ឆ្នាំ',
                    icon: Icons.calendar_today_outlined,
                    suffixIcon: const Icon(
                      Icons.edit_calendar_outlined,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                // ---------- Phone ----------
                _buildLabel('លេខទូរស័ព្ទ'),
                const SizedBox(height: 8),

                TextField(
                  controller: _phoneController,
                  keyboardType: TextInputType.phone,
                  style: const TextStyle(color: Colors.white),
                  decoration: _inputDecoration(
                    hint: 'បញ្ចូលលេខទូរស័ព្ទ',
                    icon: Icons.phone_outlined,
                  ),
                ),

                const SizedBox(height: 20),

                // ---------- Email ----------
                _buildLabel('អ៊ីមែល'),
                const SizedBox(height: 8),

                TextField(
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  style: const TextStyle(color: Colors.white),
                  decoration: _inputDecoration(
                    hint: 'បញ្ចូលអ៊ីមែលរបស់អ្នក',
                    icon: Icons.mail_outline,
                  ),
                ),

                const SizedBox(height: 20),

                // ---------- Password ----------
                _buildLabel('ពាក្យសម្ងាត់'),
                const SizedBox(height: 8),

                TextField(
                  controller: _passwordController,
                  obscureText: _hidePassword,
                  style: const TextStyle(color: Colors.white),
                  decoration: _inputDecoration(
                    hint: 'បញ្ចូលពាក្យសម្ងាត់',
                    icon: Icons.lock_outline,
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
                  ),
                ),

                const SizedBox(height: 20),

                // ---------- Confirm password ----------
                _buildLabel('បញ្ជាក់ពាក្យសម្ងាត់'),
                const SizedBox(height: 8),

                TextField(
                  controller: _confirmPasswordController,
                  obscureText: _hideConfirmPassword,
                  style: const TextStyle(color: Colors.white),
                  decoration: _inputDecoration(
                    hint: 'បញ្ជាក់ពាក្យសម្ងាត់ឡើងវិញ',
                    icon: Icons.lock_outline,
                    suffixIcon: IconButton(
                      icon: Icon(
                        _hideConfirmPassword
                            ? Icons.visibility_off_outlined
                            : Icons.visibility_outlined,
                        color: AppColors.textSecondary,
                      ),
                      onPressed: () {
                        setState(() {
                          _hideConfirmPassword = !_hideConfirmPassword;
                        });
                      },
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                // ---------- Terms checkbox ----------
                Row(
                  children: [
                    Checkbox(
                      value: _acceptTerms,
                      activeColor: AppColors.primaryColor,
                      side: const BorderSide(color: AppColors.textSecondary),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(6),
                      ),
                      onChanged: (value) {
                        setState(() {
                          _acceptTerms = value ?? false;
                        });
                      },
                    ),
                    // Expanded + Wrap so long text goes to the next line
                    Expanded(
                      child: Wrap(
                        crossAxisAlignment: WrapCrossAlignment.center,
                        children: [
                          const Text(
                            'ខ្ញុំយល់ព្រមតាម ',
                            style: TextStyle(
                              color: AppColors.textSecondary,
                              fontSize: 14,
                            ),
                          ),
                          GestureDetector(
                            onTap: () {

                            },
                            child: const Text(
                              'លក្ខខណ្ឌ',
                              style: TextStyle(
                                color: AppColors.primaryColor,
                                fontSize: 14,
                                decoration: TextDecoration.underline,
                                decorationColor: AppColors.primaryColor,
                              ),
                            ),
                          ),
                          const Text(
                            ' និង ',
                            style: TextStyle(
                              color: AppColors.textSecondary,
                              fontSize: 14,
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              // TODO: open privacy policy page
                            },
                            child: const Text(
                              'គោលការណ៍ឯកជនភាព',
                              style: TextStyle(
                                color: AppColors.primaryColor,
                                fontSize: 14,
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

                const SizedBox(height: 16),

                // ---------- Register button (orange gradient) ----------
                Container(
                  width: double.infinity,
                  height: 56,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    gradient: const LinearGradient(
                      colors: [
                        AppColors.primaryColor,
                        AppColors.secondaryColor,
                      ],
                    ),
                  ),
                  child: ElevatedButton(
                    onPressed: _onRegisterPressed,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.transparent, // show gradient
                      shadowColor: Colors.transparent,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'ចុះឈ្មោះ',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(width: 8),
                        Icon(Icons.arrow_forward, color: Colors.white),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 24),

                // ---------- Already have account ----------
                Center(
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text(
                        'មានគណនីរួចហើយ? ',
                        style: TextStyle(color: AppColors.textSecondary),
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.pop(context); // go back to login page
                        },
                        child: const Text(
                          'ចូលគណនី',
                          style: TextStyle(
                            color: AppColors.primaryColor,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 16),
              ],
            ),
          ),
        ),
      ),
    );
  }
}