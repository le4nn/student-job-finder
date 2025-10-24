import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'dart:async';
import 'dart:ui';
import 'package:student_job_finder/core/widgets/sg_snackbar.dart';
import 'package:student_job_finder/core/utils/exception_handler.dart';
import 'package:student_job_finder/core/utils/app_bloc_observer.dart';
import 'package:student_job_finder/presentation/bloc/common/auth/auth_bloc.dart';
import 'package:student_job_finder/presentation/bloc/common/auth/auth_event.dart';

import 'core/di/injection.dart';
import 'core/routes/app_routes.dart';
import 'core/utils/app_logger.dart';
import 'core/constants/app_colors.dart';

void main() async {
  runZonedGuarded(() async {
    WidgetsFlutterBinding.ensureInitialized();
    await configureDependencies();
    final logger = getIt<AppLogger>();
    logger.info('🚀 App started');
    Bloc.observer = AppBlocObserver(logger);
    await initializeDateFormatting('ru_RU', null);
    await initializeDateFormatting('ru', null);
    Intl.defaultLocale = 'ru_RU';

    FlutterError.onError = (FlutterErrorDetails details) {
      logger.error('FlutterError', details.exception, details.stack);
    };

    PlatformDispatcher.instance.onError = (Object error, StackTrace stack) {
      logger.error('Uncaught platform error', error, stack);
      return true;
    };

    runApp(const MyApp());
  }, (error, stack) {
    final logger = getIt<AppLogger>();
    logger.error('Uncaught zone error', error, stack);
    try {
      snackBarBuilder(SnackBarOptions(
        type: SnackBarType.error,
        exception: ExceptionHandler(error),
      ));
    } catch (_) {}
  });
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
