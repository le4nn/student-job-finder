import '../entities/vacancy_entity.dart';
import '../repositories/vacancy_repository.dart';

class GetVacanciesUseCase {
  final VacancyRepository repository;

  GetVacanciesUseCase(this.repository);

  Future<List<VacancyEntity>> call({String? status}) async {
    return await repository.getVacancies(status: status);
  }
}

class GetVacancyByIdUseCase {
  final VacancyRepository repository;

  GetVacancyByIdUseCase(this.repository);

  Future<VacancyEntity> call(String id) async {
    return await repository.getVacancyById(id);
  }
}

class CreateVacancyUseCase {
  final VacancyRepository repository;

  CreateVacancyUseCase(this.repository);

  Future<VacancyEntity> call(VacancyEntity vacancy) async {
    return await repository.createVacancy(vacancy);
  }
}

class UpdateVacancyUseCase {
  final VacancyRepository repository;

  UpdateVacancyUseCase(this.repository);

  Future<VacancyEntity> call(String id, VacancyEntity vacancy) async {
    return await repository.updateVacancy(id, vacancy);
  }
}

class DeleteVacancyUseCase {
  final VacancyRepository repository;

  DeleteVacancyUseCase(this.repository);

  Future<void> call(String id) async {
    return await repository.deleteVacancy(id);
  }
}

class GetEmployerVacanciesUseCase {
  final VacancyRepository repository;

  GetEmployerVacanciesUseCase(this.repository);

  Future<List<VacancyEntity>> call(String employerId) async {
    return await repository.getEmployerVacancies(employerId);
  }
}
