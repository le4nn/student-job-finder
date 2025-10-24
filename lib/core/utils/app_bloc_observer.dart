import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:student_job_finder/core/utils/app_logger.dart';

class AppBlocObserver extends BlocObserver {
  final AppLogger logger;

  AppBlocObserver(this.logger);

  @override
  void onEvent(Bloc bloc, Object? event) {
    super.onEvent(bloc, event);
    logger.debug('Bloc Event: ${bloc.runtimeType} -> $event');
  }

  @override
  void onChange(BlocBase bloc, Change change) {
    super.onChange(bloc, change);
    logger.debug('Bloc Change: ${bloc.runtimeType} -> ${change.currentState} => ${change.nextState}');
  }

  @override
  void onTransition(Bloc bloc, Transition transition) {
    super.onTransition(bloc, transition);
    logger.debug('Bloc Transition: ${bloc.runtimeType} -> $transition');
  }

  @override
  void onError(BlocBase bloc, Object error, StackTrace stackTrace) {
    logger.error('Bloc Error: ${bloc.runtimeType}', error, stackTrace);
    super.onError(bloc, error, stackTrace);
  }
}
