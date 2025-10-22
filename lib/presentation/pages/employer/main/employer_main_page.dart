import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/constants/app_colors.dart';
import '../resume/resumes_list_page.dart';
import '../messages/messages_page.dart';
import '../vacancy/vacancies_list_page.dart';
import '../profile/profile_page.dart';

class EmployerMainPage extends StatefulWidget {
  const EmployerMainPage({super.key});

  @override
  State<EmployerMainPage> createState() => _EmployerMainPageState();
}

class _EmployerMainPageState extends State<EmployerMainPage> {
  int _currentIndex = 0;

  final List<Widget> _pages = [
    const ResumesListPage(),
    const MessagesPage(),
    const VacanciesListPage(),
    const ProfilePage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_currentIndex],
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: SafeArea(
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 8.h),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildNavItem(
                  icon: Icons.description_outlined,
                  label: 'Резюме',
                  index: 0,
                ),
                _buildNavItem(
                  icon: Icons.message_outlined,
                  label: 'Сообщения',
                  index: 1,
                ),
                _buildNavItem(
                  icon: Icons.work_outline,
                  label: 'Вакансии',
                  index: 2,
                ),
                _buildNavItem(
                  icon: Icons.person_outline,
                  label: 'Профиль',
                  index: 3,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem({
    required IconData icon,
    required String label,
    required int index,
  }) {
    final isSelected = _currentIndex == index;

    return GestureDetector(
      onTap: () {
        setState(() {
          _currentIndex = index;
        });
      },
      behavior: HitTestBehavior.opaque,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primary.withOpacity(0.1) : Colors.transparent,
          borderRadius: BorderRadius.circular(12.r),
          border: isSelected
              ? Border.all(color: AppColors.primary, width: 1.5)
              : null,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Stack(
              clipBehavior: Clip.none,
              children: [
                Icon(
                  icon,
                  color: isSelected ? AppColors.primary : AppColors.textSecondary,
                  size: 24.sp,
                ),
                if (index == 1) // Уведомление для сообщений
                  Positioned(
                    right: -4,
                    top: -4,
                    child: Container(
                      width: 8.w,
                      height: 8.h,
                      decoration: const BoxDecoration(
                        color: AppColors.primary,
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
              ],
            ),
            SizedBox(height: 4.h),
            Text(
              label,
              style: TextStyle(
                fontSize: 12.sp,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                color: isSelected ? AppColors.primary : AppColors.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
