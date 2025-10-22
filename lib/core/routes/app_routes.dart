import 'package:go_router/go_router.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;
import '../../presentation/pages/common/auth/login_page.dart';
import '../../presentation/pages/common/auth/login_password_page.dart';
import '../../presentation/pages/common/auth/register_page.dart';
import '../../presentation/pages/common/auth/otp_verification_page.dart';
import '../../presentation/pages/employer/main/employer_main_page.dart';
import '../../presentation/pages/employer/vacancy/vacancies_list_page.dart';
import '../../presentation/pages/employer/vacancy/create_vacancy_page.dart';
import '../../presentation/bloc/employer/vacancy/vacancy_bloc.dart';
import '../../presentation/bloc/employer/vacancy/vacancy_event.dart';
import '../../domain/usecases/vacancy_usecases.dart';
import '../../data/datasources/vacancy_remote_datasource.dart';
import '../../data/repositories/vacancy_repository_impl.dart';

class AppRoutes {
  static const String login = '/login';
  static const String loginPassword = '/login-password';
  static const String register = '/register';
  static const String otpVerification = '/otp-verification';
  static const String employerHome = '/employer/home';
  static const String vacanciesList = '/vacancies';
  static const String createVacancy = '/create-vacancy';
  
  static final GoRouter router = GoRouter(
    initialLocation: loginPassword,
    routes: [
      GoRoute(
        path: login,
        builder: (context, state) => const LoginPage(),
      ),
      GoRoute(
        path: loginPassword,
        builder: (context, state) => const LoginPasswordPage(),
      ),
      GoRoute(
        path: register,
        builder: (context, state) => const RegisterPage(),
      ),
      GoRoute(
        path: otpVerification,
        builder: (context, state) {
          final params = state.extra as Map<String, dynamic>;
          final phoneNumber = params['phoneNumber'] as String;
          final role = params['role'] as String;
          return OtpVerificationPage(
            phoneNumber: phoneNumber,
            role: role,
          );
        },
      ),
      GoRoute(
        path: employerHome,
        builder: (context, state) {
          // Build dependencies manually (simple DI)
          final client = http.Client();
          final remote = VacancyRemoteDataSourceImpl(client: client);
          final repo = VacancyRepositoryImpl(remoteDataSource: remote);
          final getVacancies = GetVacanciesUseCase(repo);
          final createVacancy = CreateVacancyUseCase(repo);
          final updateVacancy = UpdateVacancyUseCase(repo);
          final deleteVacancy = DeleteVacancyUseCase(repo);
          final getEmployerVacancies = GetEmployerVacanciesUseCase(repo);

          return BlocProvider(
            create: (_) => VacancyBloc(
              getVacanciesUseCase: getVacancies,
              createVacancyUseCase: createVacancy,
              updateVacancyUseCase: updateVacancy,
              deleteVacancyUseCase: deleteVacancy,
              getEmployerVacanciesUseCase: getEmployerVacancies,
            )..add(LoadVacanciesEvent()),
            child: const EmployerMainPage(),
          );
        },
      ),
      GoRoute(
        path: vacanciesList,
        builder: (context, state) => const VacanciesListPage(),
      ),
      GoRoute(
        path: createVacancy,
        builder: (context, state) {
          final extraBloc = state.extra is VacancyBloc ? state.extra as VacancyBloc : null;
          if (extraBloc != null) {
            return BlocProvider.value(
              value: extraBloc,
              child: const CreateVacancyPage(),
            );
          }

          // Fallback: create isolated bloc if not provided via extra
          final client = http.Client();
          final remote = VacancyRemoteDataSourceImpl(client: client);
          final repo = VacancyRepositoryImpl(remoteDataSource: remote);
          final getVacancies = GetVacanciesUseCase(repo);
          final createVacancy = CreateVacancyUseCase(repo);
          final updateVacancy = UpdateVacancyUseCase(repo);
          final deleteVacancy = DeleteVacancyUseCase(repo);
          final getEmployerVacancies = GetEmployerVacanciesUseCase(repo);

          return BlocProvider(
            create: (_) => VacancyBloc(
              getVacanciesUseCase: getVacancies,
              createVacancyUseCase: createVacancy,
              updateVacancyUseCase: updateVacancy,
              deleteVacancyUseCase: deleteVacancy,
              getEmployerVacanciesUseCase: getEmployerVacancies,
            ),
            child: const CreateVacancyPage(),
          );
        },
      ),
    ],
  );
}
