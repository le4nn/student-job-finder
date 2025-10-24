import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:student_job_finder/presentation/bloc/common/auth/auth_bloc.dart';
import 'package:student_job_finder/presentation/bloc/common/auth/auth_event.dart';

import 'core/di/injection.dart';
import 'core/routes/app_routes.dart';
import 'core/utils/app_logger.dart';
import 'core/constants/app_colors.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await configureDependencies();
  final logger = getIt<AppLogger>();
  logger.info('🚀 App started');
  await initializeDateFormatting('ru_RU', null);
  await initializeDateFormatting('ru', null);
  Intl.defaultLocale = 'ru_RU';
  
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(375, 812),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return BlocProvider(
          create: (context) => getIt<AuthBloc>()..add(const AuthSessionCheckRequested()),
          child: MaterialApp.router(
            title: 'Student Job Finder',
            theme: ThemeData(
              colorScheme: ColorScheme.fromSeed(
                seedColor: AppColors.primary,
                brightness: Brightness.light,
              ),
              useMaterial3: true,
            ),
            darkTheme: ThemeData(
              colorScheme: ColorScheme.fromSeed(
                seedColor: AppColors.primary,
                brightness: Brightness.dark,
              ),
              useMaterial3: true,
            ),
            routerConfig: AppRoutes.router,
            debugShowCheckedModeBanner: false,
          ),
        );
      },
    );
  }
}
