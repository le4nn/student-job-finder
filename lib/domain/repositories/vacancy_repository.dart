import '../entities/vacancy_entity.dart';

abstract class VacancyRepository {
  Future<List<VacancyEntity>> getVacancies({String? status});
  Future<VacancyEntity> getVacancyById(String id);
  Future<VacancyEntity> createVacancy(VacancyEntity vacancy);
  Future<VacancyEntity> updateVacancy(String id, VacancyEntity vacancy);
  Future<void> deleteVacancy(String id);
  Future<List<VacancyEntity>> getEmployerVacancies(String employerId);
}
