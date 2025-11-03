import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_padding.dart';
import '../../../../core/constants/app_radii.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../../domain/entities/vacancy_entity.dart';

class VacancyCard extends StatelessWidget {
  final VacancyEntity vacancy;
  final VoidCallback onView;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const VacancyCard({
    super.key,
    required this.vacancy,
    required this.onView,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(AppPadding.medium),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppRadii.large),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Text(
                  vacancy.title,
                  style: AppTextStyles.h3,
                ),
              ),
              const SizedBox(width: 8),
              _buildStatusChip(),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            vacancy.companyName,
            style: AppTextStyles.body.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: 12),
          if (vacancy.salaryFrom != null || vacancy.salaryTo != null)
            _buildSalaryText(),
          const SizedBox(height: 12),
          _buildInfoRow(),
          const SizedBox(height: 16),
          _buildActionButtons(),
        ],
      ),
    );
  }

  Widget _buildStatusChip() {
    Color backgroundColor;
    Color textColor;
    String statusText;

    switch (vacancy.status) {
      case 'active':
        backgroundColor = const Color(0xFFE8F5E9);
        textColor = const Color(0xFF2E7D32);
        statusText = 'Активна';
        break;
      case 'paused':
        backgroundColor = const Color(0xFFFFF3E0);
        textColor = const Color(0xFFE65100);
        statusText = 'Приостановлена';
        break;
      case 'closed':
        backgroundColor = const Color(0xFFEEEEEE);
        textColor = const Color(0xFF616161);
        statusText = 'Закрыта';
        break;
      default:
        backgroundColor = AppColors.surface;
        textColor = AppColors.textPrimary;
        statusText = vacancy.status;
    }

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 12,
        vertical: 6,
      ),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(AppRadii.small),
      ),
      child: Text(
        statusText,
        style: AppTextStyles.caption.copyWith(
          color: textColor,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget _buildSalaryText() {
    final formatter = NumberFormat('#,###', 'ru_RU');
    String salaryText = '';

    if (vacancy.salaryFrom != null && vacancy.salaryTo != null) {
      salaryText = '${formatter.format(vacancy.salaryFrom)} - ${formatter.format(vacancy.salaryTo)} ₽';
    } else if (vacancy.salaryFrom != null) {
      salaryText = 'От ${formatter.format(vacancy.salaryFrom)} ₽';
    } else if (vacancy.salaryTo != null) {
      salaryText = 'До ${formatter.format(vacancy.salaryTo)} ₽';
    }

    return Text(
      salaryText,
      style: AppTextStyles.h4.copyWith(
        color: AppColors.primary,
      ),
    );
  }

  Widget _buildInfoRow() {
    return Wrap(
      spacing: 16,
      runSpacing: 8,
      children: [
        _buildInfoItem(Icons.location_on_outlined, vacancy.location),
        _buildInfoItem(Icons.work_outline, vacancy.format),
        _buildInfoItem(
          Icons.person_outline,
          '${vacancy.applicantsCount} откликов',
        ),
        _buildInfoItem(
          Icons.visibility_outlined,
          '${vacancy.viewsCount} просмотров',
        ),
        if (vacancy.deadline != null)
          _buildInfoItem(
            Icons.calendar_today_outlined,
            'До ${DateFormat('dd MMMM', 'ru').format(vacancy.deadline!)}',
          ),
      ],
    );
  }

  Widget _buildInfoItem(IconData icon, String text) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          icon,
          size: 16,
          color: AppColors.textSecondary,
        ),
        const SizedBox(width: 4),
        Text(
          text,
          style: AppTextStyles.caption.copyWith(
            color: AppColors.textSecondary,
          ),
        ),
      ],
    );
  }

  Widget _buildActionButtons() {
    return Row(
      children: [
        Expanded(
          child: OutlinedButton.icon(
            onPressed: onView,
            icon: const Icon(Icons.visibility_outlined, size: 18),
            label: const Text('Просмотр'),
            style: OutlinedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 12),
              side: const BorderSide(color: AppColors.border),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(AppRadii.medium),
              ),
            ),
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: OutlinedButton.icon(
            onPressed: onEdit,
            icon: const Icon(Icons.edit_outlined, size: 18),
            label: const Text('Изменить'),
            style: OutlinedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 12),
              side: const BorderSide(color: AppColors.border),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(AppRadii.medium),
              ),
            ),
          ),
        ),
        const SizedBox(width: 8),
        IconButton(
          onPressed: onDelete,
          icon: const Icon(
            Icons.delete_outline,
            color: Colors.red,
            size: 24,
          ),
        ),
      ],
    );
  }
}
