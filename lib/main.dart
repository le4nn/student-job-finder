import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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
    return BlocProvider(
      create: (context) => getIt<AuthBloc>()..add(const AuthSessionCheckRequested()),
      child: MaterialApp.router(
        title: 'Student Job Finder',
        theme: ThemeData(
          useMaterial3: true,
          colorScheme: ColorScheme.light(
            primary: AppColors.primary,
            secondary: AppColors.secondary,
            surface: AppColors.surface,
            background: AppColors.background,
            error: AppColors.error,
            onPrimary: Colors.white,
            onSecondary: AppColors.textPrimary,
            onSurface: AppColors.textPrimary,
            onBackground: AppColors.textPrimary,
            onError: Colors.white,
          ),
          scaffoldBackgroundColor: AppColors.background,
          fontFamily: 'SF Pro Display',
          
          // Card Theme - Rounded with subtle shadow
          cardTheme: CardTheme(
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            color: AppColors.surface,
            shadowColor: AppColors.shadow,
          ),
          
          // Input Decoration Theme
          inputDecorationTheme: InputDecorationTheme(
            filled: true,
            fillColor: AppColors.inputBackground,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: AppColors.border, width: 1),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: AppColors.borderLight, width: 1),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: AppColors.primary, width: 2),
            ),
            contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          ),
          
          // Elevated Button Theme - Gradient purple to lilac
          elevatedButtonTheme: ElevatedButtonThemeData(
            style: ElevatedButton.styleFrom(
              elevation: 0,
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            ),
          ),
          
          // Text Button Theme
          textButtonTheme: TextButtonThemeData(
            style: TextButton.styleFrom(
              foregroundColor: AppColors.primary,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
          
          // App Bar Theme
          appBarTheme: AppBarTheme(
            elevation: 0,
            backgroundColor: AppColors.surface,
            foregroundColor: AppColors.textPrimary,
            centerTitle: true,
          ),
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
  }
}
