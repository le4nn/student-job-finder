import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../domain/usecases/vacancy_usecases.dart';
import 'vacancy_event.dart';
import 'vacancy_state.dart';

class VacancyBloc extends Bloc<VacancyEvent, VacancyState> {
  final GetVacanciesUseCase getVacanciesUseCase;
  final CreateVacancyUseCase createVacancyUseCase;
  final UpdateVacancyUseCase updateVacancyUseCase;
  final DeleteVacancyUseCase deleteVacancyUseCase;
  final GetEmployerVacanciesUseCase getEmployerVacanciesUseCase;

  VacancyBloc({
    required this.getVacanciesUseCase,
    required this.createVacancyUseCase,
    required this.updateVacancyUseCase,
    required this.deleteVacancyUseCase,
    required this.getEmployerVacanciesUseCase,
  }) : super(VacancyInitial()) {
    on<LoadVacanciesEvent>(_onLoadVacancies);
    on<CreateVacancyEvent>(_onCreateVacancy);
    on<UpdateVacancyEvent>(_onUpdateVacancy);
    on<DeleteVacancyEvent>(_onDeleteVacancy);
    on<FilterVacanciesEvent>(_onFilterVacancies);
  }

  Future<void> _onLoadVacancies(
    LoadVacanciesEvent event,
    Emitter<VacancyState> emit,
  ) async {
    try {
      emit(VacancyLoading());
      final vacancies = await getVacanciesUseCase(status: event.status);
      emit(VacanciesLoaded(vacancies));
    } catch (e) {
      emit(VacancyError(e.toString()));
    }
  }

  Future<void> _onCreateVacancy(
    CreateVacancyEvent event,
    Emitter<VacancyState> emit,
  ) async {
    try {
      emit(VacancyLoading());
      final vacancy = await createVacancyUseCase(event.vacancy);
      emit(VacancyCreated(vacancy));
      
      // Reload vacancies after creation
      final vacancies = await getVacanciesUseCase();
      emit(VacanciesLoaded(vacancies));
    } catch (e) {
      emit(VacancyError(e.toString()));
    }
  }

  Future<void> _onUpdateVacancy(
    UpdateVacancyEvent event,
    Emitter<VacancyState> emit,
  ) async {
    try {
      emit(VacancyLoading());
      final vacancy = await updateVacancyUseCase(event.id, event.vacancy);
      emit(VacancyUpdated(vacancy));
      
      // Reload vacancies after update
      final vacancies = await getVacanciesUseCase();
      emit(VacanciesLoaded(vacancies));
    } catch (e) {
      emit(VacancyError(e.toString()));
    }
  }

  Future<void> _onDeleteVacancy(
    DeleteVacancyEvent event,
    Emitter<VacancyState> emit,
  ) async {
    try {
      emit(VacancyLoading());
      await deleteVacancyUseCase(event.id);
      emit(VacancyDeleted(event.id));
      
      // Reload vacancies after deletion
      final vacancies = await getVacanciesUseCase();
      emit(VacanciesLoaded(vacancies));
    } catch (e) {
      emit(VacancyError(e.toString()));
    }
  }

  Future<void> _onFilterVacancies(
    FilterVacanciesEvent event,
    Emitter<VacancyState> emit,
  ) async {
    if (state is VacanciesLoaded) {
      final currentState = state as VacanciesLoaded;
      emit(VacanciesLoaded(
        currentState.vacancies,
        currentFilter: event.status,
      ));
    }
  }
}
