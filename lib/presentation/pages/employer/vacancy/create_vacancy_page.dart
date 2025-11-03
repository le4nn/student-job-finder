import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:responsive_builder/responsive_builder.dart';
import '../../../bloc/common/auth/auth_bloc.dart';
import '../../../bloc/common/auth/auth_state.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_padding.dart';
import '../../../../core/constants/app_radii.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../../domain/entities/vacancy_entity.dart';
import '../../../bloc/employer/vacancy/vacancy_bloc.dart';
import '../../../bloc/employer/vacancy/vacancy_event.dart';
import '../../../bloc/employer/vacancy/vacancy_state.dart';

class CreateVacancyPage extends StatefulWidget {
  const CreateVacancyPage({super.key});

  @override
  State<CreateVacancyPage> createState() => _CreateVacancyPageState();
}

class _CreateVacancyPageState extends State<CreateVacancyPage> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _locationController = TextEditingController();
  final _salaryFromController = TextEditingController();
  final _salaryToController = TextEditingController();
  final _skillController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _responsibilitiesController = TextEditingController();
  final _requirementsController = TextEditingController();
  final _benefitsController = TextEditingController();

  String? _selectedType;
  String? _selectedFormat;
  final List<String> _skills = [];

  final List<String> _types = [
    'Полная занятость',
    'Частичная занятость',
    'Стажировка',
    'Проектная работа',
  ];

  final List<String> _formats = [
    'Офис',
    'Удаленно',
    'Гибрид',
  ];

  @override
  void dispose() {
    _titleController.dispose();
    _locationController.dispose();
    _salaryFromController.dispose();
    _salaryToController.dispose();
    _skillController.dispose();
    _descriptionController.dispose();
    _responsibilitiesController.dispose();
    _requirementsController.dispose();
    _benefitsController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => context.pop(),
        ),
        title: Text(
          'Создать вакансию',
          style: AppTextStyles.h2,
        ),
        centerTitle: false,
      ),
      body: ResponsiveBuilder(
        builder: (context, sizingInformation) {
          final isDesktop = sizingInformation.isDesktop;
          final isTablet = sizingInformation.isTablet;
          
          return BlocListener<VacancyBloc, VacancyState>(
            listener: (context, state) {
              if (state is VacancyCreated) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Вакансия успешно создана')),
                );
                context.pop();
              } else if (state is VacancyError) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(state.message)),
                );
              }
            },
            child: Center(
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  maxWidth: isDesktop ? 900 : isTablet ? 700 : double.infinity,
                ),
                child: Form(
                  key: _formKey,
                  child: ListView(
                    padding: EdgeInsets.all(
                      isDesktop ? AppPadding.medium * 2 : AppPadding.medium,
                    ),
                    children: [
                      _buildSection(
                        'Основная информация',
                        isDesktop,
                        [
                          _buildTextField(
                            controller: _titleController,
                            label: 'Название вакансии',
                            required: true,
                            hint: 'Frontend Developer',
                          ),
                          const SizedBox(height: 16),
                          Row(
                            children: [
                              Expanded(
                                child: _buildDropdownField(
                                  value: _selectedType,
                                  items: _types,
                                  label: 'Тип',
                                  required: true,
                                  onChanged: (value) {
                                    setState(() => _selectedType = value);
                                  },
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: _buildDropdownField(
                                  value: _selectedFormat,
                                  items: _formats,
                                  label: 'Формат',
                                  required: true,
                                  onChanged: (value) {
                                    setState(() => _selectedFormat = value);
                                  },
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          _buildTextField(
                            controller: _locationController,
                            label: 'Локация',
                            required: true,
                            hint: 'Москва',
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),
                      _buildSection(
                        'Зарплата',
                        isDesktop,
                [
                          Row(
                            children: [
                              Expanded(
                                child: _buildTextField(
                                  controller: _salaryFromController,
                                  label: 'От (₽)',
                                  hint: '80000',
                                  keyboardType: TextInputType.number,
                                  inputFormatters: [
                                    FilteringTextInputFormatter.digitsOnly,
                                  ],
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: _buildTextField(
                                  controller: _salaryToController,
                                  label: 'До (₽)',
                                  hint: '120000',
                                  keyboardType: TextInputType.number,
                                  inputFormatters: [
                                    FilteringTextInputFormatter.digitsOnly,
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),
                      _buildSection(
                        'Навыки',
                        isDesktop,
                        [
                          Row(
                            children: [
                              Expanded(
                                child: TextField(
                                  controller: _skillController,
                                  decoration: InputDecoration(
                                    hintText: 'Добавить навык',
                                    filled: true,
                                    fillColor: AppColors.inputBackground,
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(AppRadii.medium),
                                      borderSide: BorderSide.none,
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 8),
                              ElevatedButton(
                                onPressed: _addSkill,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.white,
                                  foregroundColor: AppColors.textPrimary,
                                  side: const BorderSide(color: AppColors.border),
                                  padding: const EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 16,
                          ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(AppRadii.medium),
                                  ),
                                ),
                                child: const Text('Добавить'),
                              ),
                            ],
                          ),
                          if (_skills.isNotEmpty) ...[
                            const SizedBox(height: 12),
                            Wrap(
                              spacing: 8,
                              runSpacing: 8,
                              children: _skills.map((skill) => _buildSkillChip(skill)).toList(),
                            ),
                          ],
                        ],
                      ),
                      const SizedBox(height: 24),
                      _buildSection(
                        'Описание',
                        isDesktop,
                        [
                          _buildTextField(
                            controller: _descriptionController,
                            label: 'О вакансии',
                            required: true,
                            hint: 'Расскажите о вакансии, команде и компании...',
                            maxLines: 5,
                          ),
                          const SizedBox(height: 16),
                          _buildTextField(
                            controller: _responsibilitiesController,
                            label: 'Обязанности',
                            required: true,
                            hint: '• Разработка пользовательских интерфейсов\n• Оптимизация производительности\n• Участие в code review',
                            maxLines: 5,
                          ),
                          const SizedBox(height: 16),
                          _buildTextField(
                            controller: _requirementsController,
                            label: 'Требования',
                            required: true,
                            hint: '• Опыт работы с React от 1 года\n• Знание TypeScript\n• Понимание принципов UX/UI',
                            maxLines: 5,
                          ),
                          const SizedBox(height: 16),
                          _buildTextField(
                            controller: _benefitsController,
                            label: 'Что предлагаем',
                            hint: '• Гибкий график работы\n• Медицинская страховка\n• Обучение за счет компании',
                            maxLines: 5,
                          ),
                        ],
                      ),
                      const SizedBox(height: 32),
                      _buildActionButtons(),
                      const SizedBox(height: 32),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildSection(String title, bool isDesktop, List<Widget> children) {
    return Container(
      padding: EdgeInsets.all(AppPadding.medium),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppRadii.large),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: AppTextStyles.h3,
          ),
          const SizedBox(height: 16),
          ...children,
        ],
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    bool required = false,
    String? hint,
    int maxLines = 1,
    TextInputType? keyboardType,
    List<TextInputFormatter>? inputFormatters,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        RichText(
          text: TextSpan(
            text: label,
            style: AppTextStyles.body.copyWith(
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
            children: [
              if (required)
                TextSpan(
                  text: ' *',
                  style: TextStyle(color: Colors.red),
                ),
            ],
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          maxLines: maxLines,
          keyboardType: keyboardType,
          inputFormatters: inputFormatters,
          decoration: InputDecoration(
            hintText: hint,
            filled: true,
            fillColor: AppColors.inputBackground,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppRadii.medium),
              borderSide: BorderSide.none,
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppRadii.medium),
              borderSide: const BorderSide(color: Colors.red),
            ),
          ),
          validator: required
              ? (value) {
                  if (value == null || value.isEmpty) {
                    return 'Обязательное поле';
                  }
                  return null;
                }
              : null,
        ),
      ],
    );
  }

  Widget _buildDropdownField({
    required String? value,
    required List<String> items,
    required String label,
    bool required = false,
    required ValueChanged<String?> onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        RichText(
          text: TextSpan(
            text: label,
            style: AppTextStyles.body.copyWith(
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
            children: [
              if (required)
                TextSpan(
                  text: ' *',
                  style: TextStyle(color: Colors.red),
                ),
            ],
          ),
        ),
        const SizedBox(height: 8),
        DropdownButtonFormField<String>(
          value: value,
          items: items.map((item) {
            return DropdownMenuItem(
              value: item,
              child: Text(item),
            );
          }).toList(),
          onChanged: onChanged,
          isExpanded: true,
          decoration: InputDecoration(
            hintText: 'Выберите',
            filled: true,
            fillColor: AppColors.inputBackground,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppRadii.medium),
              borderSide: BorderSide.none,
            ),
          ),
          validator: required
              ? (value) {
                  if (value == null || value.isEmpty) {
                    return 'Обязательное поле';
                  }
                  return null;
                }
              : null,
        ),
      ],
    );
  }

  Widget _buildSkillChip(String skill) {
    return Chip(
      label: Text(skill),
      deleteIcon: const Icon(Icons.close, size: 18),
      onDeleted: () {
        setState(() {
          _skills.remove(skill);
        });
      },
      backgroundColor: AppColors.primary.withOpacity(0.1),
      labelStyle: AppTextStyles.caption.copyWith(
        color: AppColors.primary,
      ),
    );
  }

  Widget _buildActionButtons() {
    return Row(
      children: [
        Expanded(
          child: OutlinedButton(
            onPressed: () => context.pop(),
            style: OutlinedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 16),
              side: const BorderSide(color: AppColors.border),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(AppRadii.medium),
              ),
            ),
            child: Text(
              'Отмена',
              style: AppTextStyles.button,
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          flex: 2,
          child: ElevatedButton(
            onPressed: _submitForm,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(AppRadii.medium),
              ),
            ),
            child: Text(
              'Опубликовать',
              style: AppTextStyles.button.copyWith(color: Colors.white),
            ),
          ),
        ),
      ],
    );
  }

  void _addSkill() {
    final skill = _skillController.text.trim();
    if (skill.isNotEmpty && !_skills.contains(skill)) {
      setState(() {
        _skills.add(skill);
        _skillController.clear();
      });
    }
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      if (_selectedType == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Выберите тип вакансии')),
        );
        return;
      }
      if (_selectedFormat == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Выберите формат работы')),
        );
        return;
      }

      // Get employerId from auth session
      final authState = context.read<AuthBloc>().state;
      String employerId = 'unknown';
      String companyName = 'Компания';
      
      if (authState is AuthAuthenticated) {
        employerId = authState.session.user.id;
        companyName = authState.session.user.name ?? 'Компания';
      }

      final now = DateTime.now();
      final vacancy = VacancyEntity(
        title: _titleController.text.trim(),
        type: _selectedType!,
        format: _selectedFormat!,
        location: _locationController.text.trim(),
        salaryFrom: _salaryFromController.text.isNotEmpty
            ? int.tryParse(_salaryFromController.text)
            : null,
        salaryTo: _salaryToController.text.isNotEmpty
            ? int.tryParse(_salaryToController.text)
            : null,
        skills: _skills,
        description: _descriptionController.text.trim(),
        responsibilities: _responsibilitiesController.text.trim(),
        requirements: _requirementsController.text.trim(),
        benefits: _benefitsController.text.trim(),
        status: 'active',
        employerId: employerId,
        companyName: companyName,
        createdAt: now,
        updatedAt: now,
      );

      context.read<VacancyBloc>().add(CreateVacancyEvent(vacancy));
    }
  }
}
