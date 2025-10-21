// dart format width=80
// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:dio/dio.dart' as _i361;
import 'package:get_it/get_it.dart' as _i174;
import 'package:injectable/injectable.dart' as _i526;
import 'package:shared_preferences/shared_preferences.dart' as _i460;
import 'package:student_job_finder/core/di/injection.dart' as _i93;
import 'package:student_job_finder/core/utils/app_logger.dart' as _i718;
import 'package:student_job_finder/core/utils/network_checker.dart' as _i394;
import 'package:student_job_finder/data/datasources/auth_local_datasource.dart'
    as _i567;
import 'package:student_job_finder/data/datasources/auth_remote_datasource.dart'
    as _i753;
import 'package:student_job_finder/data/repositories/auth_repository_impl.dart'
    as _i256;
import 'package:student_job_finder/domain/repositories/auth_repository.dart'
    as _i102;
import 'package:student_job_finder/domain/usecases/get_current_session_usecase.dart'
    as _i588;
import 'package:student_job_finder/domain/usecases/login_password_usecase.dart'
    as _i918;
import 'package:student_job_finder/domain/usecases/register_password_usecase.dart'
    as _i1029;
import 'package:student_job_finder/domain/usecases/request_code_usecase.dart'
    as _i622;
import 'package:student_job_finder/domain/usecases/request_email_code_usecase.dart'
    as _i955;
import 'package:student_job_finder/domain/usecases/send_otp_usecase.dart'
    as _i542;
import 'package:student_job_finder/domain/usecases/verify_code_usecase.dart'
    as _i628;
import 'package:student_job_finder/domain/usecases/verify_email_code_usecase.dart'
    as _i459;
import 'package:student_job_finder/domain/usecases/verify_otp_usecase.dart'
    as _i502;
import 'package:student_job_finder/presentation/bloc/auth/auth_bloc.dart'
    as _i162;

extension GetItInjectableX on _i174.GetIt {
  // initializes the registration of main-scope dependencies inside of GetIt
  Future<_i174.GetIt> init({
    String? environment,
    _i526.EnvironmentFilter? environmentFilter,
  }) async {
    final gh = _i526.GetItHelper(this, environment, environmentFilter);
    final registerModule = _$RegisterModule();
    await gh.factoryAsync<_i460.SharedPreferences>(
      () => registerModule.prefs,
      preResolve: true,
    );
    gh.lazySingleton<_i361.Dio>(() => registerModule.dio);
    gh.lazySingleton<_i718.AppLogger>(() => _i718.AppLogger());
    gh.lazySingleton<_i567.AuthLocalDataSource>(
      () => _i567.AuthLocalDataSourceImpl(gh<_i460.SharedPreferences>()),
    );
    gh.lazySingleton<_i753.AuthRemoteDataSource>(
      () => _i753.AuthRemoteDataSourceImpl(
        gh<_i361.Dio>(),
        gh<_i718.AppLogger>(),
      ),
    );
    gh.factory<_i394.NetworkChecker>(
      () => _i394.NetworkChecker(gh<_i361.Dio>(), gh<_i718.AppLogger>()),
    );
    gh.lazySingleton<_i102.AuthRepository>(
      () => _i256.AuthRepositoryImpl(
        gh<_i753.AuthRemoteDataSource>(),
        gh<_i567.AuthLocalDataSource>(),
      ),
    );
    gh.factory<_i1029.RegisterPasswordUseCase>(
      () => _i1029.RegisterPasswordUseCase(gh<_i102.AuthRepository>()),
    );
    gh.factory<_i588.GetCurrentSessionUseCase>(
      () => _i588.GetCurrentSessionUseCase(gh<_i102.AuthRepository>()),
    );
    gh.factory<_i622.RequestCodeUseCase>(
      () => _i622.RequestCodeUseCase(gh<_i102.AuthRepository>()),
    );
    gh.factory<_i459.VerifyEmailCodeUseCase>(
      () => _i459.VerifyEmailCodeUseCase(gh<_i102.AuthRepository>()),
    );
    gh.factory<_i628.VerifyCodeUseCase>(
      () => _i628.VerifyCodeUseCase(gh<_i102.AuthRepository>()),
    );
    gh.factory<_i955.RequestEmailCodeUseCase>(
      () => _i955.RequestEmailCodeUseCase(gh<_i102.AuthRepository>()),
    );
    gh.factory<_i542.RequestCodeUseCase>(
      () => _i542.RequestCodeUseCase(gh<_i102.AuthRepository>()),
    );
    gh.factory<_i918.LoginPasswordUseCase>(
      () => _i918.LoginPasswordUseCase(gh<_i102.AuthRepository>()),
    );
    gh.factory<_i502.VerifyCodeUseCase>(
      () => _i502.VerifyCodeUseCase(gh<_i102.AuthRepository>()),
    );
    gh.factory<_i162.AuthBloc>(
      () => _i162.AuthBloc(
        gh<_i622.RequestCodeUseCase>(),
        gh<_i628.VerifyCodeUseCase>(),
        gh<_i1029.RegisterPasswordUseCase>(),
        gh<_i918.LoginPasswordUseCase>(),
        gh<_i955.RequestEmailCodeUseCase>(),
        gh<_i459.VerifyEmailCodeUseCase>(),
        gh<_i588.GetCurrentSessionUseCase>(),
        gh<_i102.AuthRepository>(),
        gh<_i718.AppLogger>(),
      ),
    );
    return this;
  }
}

class _$RegisterModule extends _i93.RegisterModule {}
