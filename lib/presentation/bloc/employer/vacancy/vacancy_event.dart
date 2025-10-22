import '../../../../domain/entities/vacancy_entity.dart';

abstract class VacancyEvent {}

class LoadVacanciesEvent extends VacancyEvent {
  final String? status;
  
  LoadVacanciesEvent({this.status});
}

class CreateVacancyEvent extends VacancyEvent {
  final VacancyEntity vacancy;
  
  CreateVacancyEvent(this.vacancy);
}

class UpdateVacancyEvent extends VacancyEvent {
  final String id;
  final VacancyEntity vacancy;
  
  UpdateVacancyEvent(this.id, this.vacancy);
}

class DeleteVacancyEvent extends VacancyEvent {
  final String id;
  
  DeleteVacancyEvent(this.id);
}

class FilterVacanciesEvent extends VacancyEvent {
  final String status;
  
  FilterVacanciesEvent(this.status);
}
