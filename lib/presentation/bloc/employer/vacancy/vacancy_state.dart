import '../../../../domain/entities/vacancy_entity.dart';

abstract class VacancyState {}

class VacancyInitial extends VacancyState {}

class VacancyLoading extends VacancyState {}

class VacanciesLoaded extends VacancyState {
  final List<VacancyEntity> vacancies;
  final String currentFilter;
  
  VacanciesLoaded(this.vacancies, {this.currentFilter = 'all'});
  
  List<VacancyEntity> get filteredVacancies {
    if (currentFilter == 'all') return vacancies;
    return vacancies.where((v) => v.status == currentFilter).toList();
  }
}

class VacancyCreated extends VacancyState {
  final VacancyEntity vacancy;
  
  VacancyCreated(this.vacancy);
}

class VacancyUpdated extends VacancyState {
  final VacancyEntity vacancy;
  
  VacancyUpdated(this.vacancy);
}

class VacancyDeleted extends VacancyState {
  final String id;
  
  VacancyDeleted(this.id);
}

class VacancyError extends VacancyState {
  final String message;
  
  VacancyError(this.message);
}
