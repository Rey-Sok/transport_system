import 'package:flutter/material.dart';
import 'package:transport_app/core/constants/app_colors.dart';
import 'package:transport_app/core/constants/pedding.dart';
import 'package:table_calendar/table_calendar.dart';
import '../../../core/constants/app_sizes.dart';
import '../../../core/constants/app_text_styles.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  DateTime _departDate = DateTime.now();
  DateTime? _returnDate;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.fromLTRB(
            AppPadding.md,
            AppPadding.sm,
            AppPadding.md,
            AppPadding.sm,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(),
              const SizedBox(height: 20),
              _buildSearchCard(),
            ],
          ),
        ),
      ),
    );
  }

  // -------------| Header | ------------
  Widget _buildHeader() {
    return Row(
      children: [
        const CircleAvatar(
          radius: 26,
          backgroundColor: AppColors.surfaceColor,
          child: Icon(Icons.person, color: AppColors.textSecondary),
        ),
        const SizedBox(width: 12),
        const Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'សួស្តី Sok 👋',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: AppSizes.fontLG,
                ),
              ),
              Text(
                'តើអ្នកចង់ធ្វើដំណើរទៅណាដែរថ្ងៃនេះ?',
                style: TextStyle(
                  color: Colors.white70,
                  fontSize: AppSizes.fontMD,
                ),
              ),
            ],
          ),
        ),
        Stack(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.notifications_none, color: Colors.white),
            ),
            Positioned(
              right: 12,
              top: 12,
              child: Container(
                width: 10,
                height: 10,
                decoration: const BoxDecoration(
                  color: AppColors.primaryColor,
                  shape: BoxShape.circle,
                ),
              ),
            ),
          ],
        ),
      ],
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

  Widget _buildSearchCard() {
    return Container(
      padding: EdgeInsets.all(AppSizes.md),
      decoration: BoxDecoration(
        color: AppColors.surfaceColor,
        borderRadius: BorderRadius.circular(AppSizes.lg),
      ),
      child: Column(
        children: [
          // From
          InkWell(
            onTap: () {},
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: AppSizes.md),
              child: Row(
                children: [
                  Icon(
                    Icons.location_on,
                    size: 28,
                    color: AppColors.textSecondary,
                  ),
                  SizedBox(width: AppSizes.md),
                  Expanded(child: Text('ទិសដៅពី', style: AppTextStyles.body)),
                  Icon(Icons.chevron_right, color: AppColors.textSecondary),
                ],
              ),
            ),
          ),
          Divider(height: 1, color: AppColors.borderColor),

          // To
          InkWell(
            onTap: () {},
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: AppSizes.md),
              child: Row(
                children: [
                  Icon(
                    Icons.flag_outlined,
                    size: 28,
                    color: AppColors.textSecondary,
                  ),
                  SizedBox(width: AppSizes.md),
                  Expanded(child: Text('ទិសដៅទៅ', style: AppTextStyles.body)),
                  Icon(Icons.chevron_right, color: AppColors.textSecondary),
                ],
              ),
            ),
          ),
          Divider(height: 1, color: AppColors.borderColor),
          SizedBox(height: AppSizes.md),

          // Dates
          IntrinsicHeight(
            child: Row(
              children: [
                // Depart
                Expanded(
                  child: InkWell(
                    onTap: () async {
                      final picked = await _showCalendar(
                        initialDate: _departDate,
                        firstDate: DateTime(1800),
                      );
                      if (picked != null) {
                        setState(() {
                          _departDate = picked;
                          // return date can't be before depart date
                          if (_returnDate != null &&
                              _returnDate!.isBefore(picked)) {
                            _returnDate = null;
                          }
                        });
                      }
                    },
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: AppSizes.sm),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('ថ្ងៃចេញដំណើរ', style: AppTextStyles.label),
                          SizedBox(height: AppSizes.sm),
                          Row(
                            children: [
                              Icon(
                                Icons.calendar_today_outlined,
                                size: 20,
                                color: AppColors.textSecondary,
                              ),
                              SizedBox(width: AppSizes.sm),
                              Text(
                                _formatDate(_departDate),
                                style: AppTextStyles.body.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

                VerticalDivider(width: 1, color: AppColors.borderColor),

                // Return
                Expanded(
                  child: InkWell(
                    onTap: () async {
                      final picked = await _showCalendar(
                        initialDate: _returnDate ?? _departDate,
                        firstDate: _departDate,
                      );
                      if (picked != null) setState(() => _returnDate = picked);
                    },
                    child: Padding(
                      padding: EdgeInsets.only(left: AppSizes.md),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('ថ្ងៃមកវិញ', style: AppTextStyles.label),
                          SizedBox(height: AppSizes.sm),
                          Row(
                            children: [
                              Icon(
                                Icons.calendar_today_outlined,
                                size: 20,
                                color: AppColors.textSecondary,
                              ),
                              SizedBox(width: AppSizes.sm),
                              Flexible(
                                child: _returnDate == null
                                    ? Text(
                                        'ជ្រើសរើសថ្ងៃ',
                                        style: AppTextStyles.accent,
                                      )
                                    : Text(
                                        _formatDate(_returnDate!),
                                        style: AppTextStyles.body.copyWith(
                                          fontWeight: FontWeight.bold,
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
              ],
            ),
          ),
          SizedBox(height: AppSizes.md),
          Divider(height: 1, color: AppColors.borderColor),
          SizedBox(height: AppSizes.md),

          // Search button
          Container(
            width: double.infinity,
            height: 54,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(AppSizes.md),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.18),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: ElevatedButton.icon(
              onPressed: () {},
              icon: const Icon(Icons.search, size: 22),
              label: Text('ស្វែងរក', style: AppTextStyles.button),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryColor,
                foregroundColor: AppColors.textOnPrimary,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppSizes.md),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
