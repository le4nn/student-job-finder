import '../../domain/entities/vacancy_entity.dart';
import '../../domain/repositories/vacancy_repository.dart';
import '../datasources/vacancy_remote_datasource.dart';
import '../models/vacancy_model.dart';

class VacancyRepositoryImpl implements VacancyRepository {
  final VacancyRemoteDataSource remoteDataSource;

  VacancyRepositoryImpl({required this.remoteDataSource});

  @override
  Future<List<VacancyEntity>> getVacancies({String? status}) async {
    final vacancyModels = await remoteDataSource.getVacancies(status: status);
    return vacancyModels.map((model) => model.toEntity()).toList();
  }

  @override
  Future<VacancyEntity> getVacancyById(String id) async {
    final vacancyModel = await remoteDataSource.getVacancyById(id);
    return vacancyModel.toEntity();
  }

  @override
  Future<VacancyEntity> createVacancy(VacancyEntity vacancy) async {
    final vacancyModel = VacancyModel(
      id: vacancy.id,
      title: vacancy.title,
      type: vacancy.type,
      format: vacancy.format,
      location: vacancy.location,
      salaryFrom: vacancy.salaryFrom,
      salaryTo: vacancy.salaryTo,
      skills: vacancy.skills,
      description: vacancy.description,
      responsibilities: vacancy.responsibilities,
      requirements: vacancy.requirements,
      benefits: vacancy.benefits,
      status: vacancy.status,
      employerId: vacancy.employerId,
      companyName: vacancy.companyName,
      applicantsCount: vacancy.applicantsCount,
      viewsCount: vacancy.viewsCount,
      deadline: vacancy.deadline,
      createdAt: vacancy.createdAt,
      updatedAt: vacancy.updatedAt,
    );

    final createdModel = await remoteDataSource.createVacancy(vacancyModel);
    return createdModel.toEntity();
  }

  @override
  Future<VacancyEntity> updateVacancy(String id, VacancyEntity vacancy) async {
    final vacancyModel = VacancyModel(
      id: vacancy.id,
      title: vacancy.title,
      type: vacancy.type,
      format: vacancy.format,
      location: vacancy.location,
      salaryFrom: vacancy.salaryFrom,
      salaryTo: vacancy.salaryTo,
      skills: vacancy.skills,
      description: vacancy.description,
      responsibilities: vacancy.responsibilities,
      requirements: vacancy.requirements,
      benefits: vacancy.benefits,
      status: vacancy.status,
      employerId: vacancy.employerId,
      companyName: vacancy.companyName,
      applicantsCount: vacancy.applicantsCount,
      viewsCount: vacancy.viewsCount,
      deadline: vacancy.deadline,
      createdAt: vacancy.createdAt,
      updatedAt: vacancy.updatedAt,
    );

    final updatedModel = await remoteDataSource.updateVacancy(id, vacancyModel);
    return updatedModel.toEntity();
  }

  @override
  Future<void> deleteVacancy(String id) async {
    await remoteDataSource.deleteVacancy(id);
  }

  @override
  Future<List<VacancyEntity>> getEmployerVacancies(String employerId) async {
    final vacancyModels = await remoteDataSource.getEmployerVacancies(employerId);
    return vacancyModels.map((model) => model.toEntity()).toList();
  }
}
