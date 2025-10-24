import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/widgets/sg_snackbar.dart';
import '../../../../core/utils/exception_handler.dart';
import '../../../bloc/common/auth/auth_bloc.dart';
import '../../../bloc/common/auth/auth_state.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_padding.dart';
import '../../../../core/constants/app_radii.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../../core/routes/app_routes.dart';
import '../../../../domain/entities/vacancy_entity.dart';
import '../../../bloc/employer/vacancy/vacancy_bloc.dart';
import '../../../bloc/employer/vacancy/vacancy_event.dart';
import '../../../bloc/employer/vacancy/vacancy_state.dart';
import '../../../widgets/employer/vacancy/vacancy_card.dart';

class VacanciesListPage extends StatefulWidget {
  const VacanciesListPage({super.key});

  @override
  State<VacanciesListPage> createState() => _VacanciesListPageState();
}

class _VacanciesListPageState extends State<VacanciesListPage> {
  String _selectedFilter = 'all';

  @override
  void initState() {
    super.initState();
    _loadEmployerVacancies();
  }

  void _loadEmployerVacancies() {
    final authState = context.read<AuthBloc>().state;
    if (authState is AuthAuthenticated) {
      final userId = authState.session.user.id;
      context.read<VacancyBloc>().add(LoadEmployerVacanciesEvent(userId));
    } else {
      // Fallback to loading all vacancies if not authenticated
      context.read<VacancyBloc>().add(LoadVacanciesEvent());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: BlocListener<VacancyBloc, VacancyState>(
          listener: (context, state) {
            if (state is VacancyError) {
              snackBarBuilder(SnackBarOptions(
                type: SnackBarType.error,
                exception: ExceptionHandler(state.message),
              ));
            } else if (state is VacancyCreated) {
              snackBarBuilder(SnackBarOptions(
                type: SnackBarType.success,
                title: 'Вакансия создана',
              ));
            } else if (state is VacancyUpdated) {
              snackBarBuilder(SnackBarOptions(
                type: SnackBarType.success,
                title: 'Вакансия обновлена',
              ));
            } else if (state is VacancyDeleted) {
              snackBarBuilder(SnackBarOptions(
                type: SnackBarType.success,
                title: 'Вакансия удалена',
              ));
            }
          },
          child: Column(
            children: [
              _buildHeader(),
              _buildFilterTabs(),
              Expanded(
                child: BlocBuilder<VacancyBloc, VacancyState>(
                  builder: (context, state) {
                    if (state is VacancyLoading) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    if (state is VacancyError) {
                      return Center(
                        child: Text(
                          state.message,
                          style: AppTextStyles.body,
                        ),
                      );
                    }
                    if (state is VacanciesLoaded) {
                      final list = _getFilteredVacancies(state.vacancies);
                      return _buildVacanciesList(list);
                    }
                    return const SizedBox();
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
  
  Widget _buildVacanciesList(List<VacancyEntity> vacancies) {
    if (vacancies.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.work_outline,
              size: 100,
              color: AppColors.textSecondary,
            ),
            SizedBox(height: 16.h),
            Text(
              'Нет вакансий',
              style: AppTextStyles.h3,
            ),
            SizedBox(height: 8.h),
            Text(
              'Создайте первую вакансию',
              style: AppTextStyles.body.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
          ],
        ),
      );
    }
    
    return ListView.separated(
      padding: EdgeInsets.all(AppPadding.medium),
      itemCount: vacancies.length,
      separatorBuilder: (_, __) => SizedBox(height: 16.h),
      itemBuilder: (context, index) {
        return VacancyCard(
          vacancy: vacancies[index],
          onView: () => _onViewVacancy(vacancies[index]),
          onEdit: () => _onEditVacancy(vacancies[index]),
          onDelete: () => _onDeleteVacancy(vacancies[index]),
        );
      },
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: EdgeInsets.all(AppPadding.medium),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Мои вакансии',
                style: AppTextStyles.h1,
              ),
              BlocBuilder<VacancyBloc, VacancyState>(
                builder: (context, state) {
                  final count = state is VacanciesLoaded ? state.vacancies.length : 0;
                  return Text(
                    '$count вакансий',
                    style: AppTextStyles.caption.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  );
                },
              ),
            ],
          ),
          ElevatedButton.icon(
            onPressed: () => context.push(AppRoutes.createVacancy, extra: context.read<VacancyBloc>()),
            icon: const Icon(Icons.add, color: Colors.white),
            label: Text(
              'Создать',
              style: AppTextStyles.button.copyWith(color: Colors.white),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              padding: EdgeInsets.symmetric(
                horizontal: AppPadding.medium,
                vertical: AppPadding.small,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(AppRadii.medium),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterTabs() {
    final filters = [
      {'key': 'all', 'label': 'Все'},
      {'key': 'active', 'label': 'Активные'},
      {'key': 'paused', 'label': 'Пауза'},
      {'key': 'closed', 'label': 'Закрытые'},
    ];

    return Container(
      height: 50.h,
      margin: EdgeInsets.symmetric(horizontal: AppPadding.medium),
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: filters.length,
        separatorBuilder: (_, __) => SizedBox(width: 8.w),
        itemBuilder: (context, index) {
          final filter = filters[index];
          final isSelected = _selectedFilter == filter['key'];
          
          return GestureDetector(
            onTap: () {
              setState(() {
                _selectedFilter = filter['key']!;
              });
              context.read<VacancyBloc>().add(FilterVacanciesEvent(filter['key']!));
            },
            child: Container(
              padding: EdgeInsets.symmetric(
                horizontal: AppPadding.medium,
                vertical: AppPadding.small,
              ),
              decoration: BoxDecoration(
                color: isSelected ? AppColors.primary : AppColors.surface,
                borderRadius: BorderRadius.circular(AppRadii.medium),
              ),
              child: Center(
                child: Text(
                  filter['label']!,
                  style: AppTextStyles.button.copyWith(
                    color: isSelected ? Colors.white : AppColors.textPrimary,
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  List<VacancyEntity> _getFilteredVacancies(List<VacancyEntity> vacancies) {
    if (_selectedFilter == 'all') return vacancies;
    return vacancies.where((v) => v.status == _selectedFilter).toList();
  }

  void _onViewVacancy(VacancyEntity vacancy) {
    // Navigate to vacancy detail page
    context.push('/vacancy/${vacancy.id}');
  }

  void _onEditVacancy(VacancyEntity vacancy) {
    context.push('/edit-vacancy/${vacancy.id}');
  }

  void _onDeleteVacancy(VacancyEntity vacancy) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Удалить вакансию?'),
        content: Text('Вы уверены, что хотите удалить вакансию "${vacancy.title}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Отмена'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              // TODO: Добавить удаление когда настроим Provider
              snackBarBuilder(SnackBarOptions(
                type: SnackBarType.warning,
                title: 'Удаление будет доступно после настройки Provider',
              ));
            },
            child: const Text(
              'Удалить',
              style: TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
    );
  }
}
