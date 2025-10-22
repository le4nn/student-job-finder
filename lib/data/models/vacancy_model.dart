import '../../domain/entities/vacancy_entity.dart';

class VacancyModel extends VacancyEntity {
  const VacancyModel({
    super.id,
    required super.title,
    required super.type,
    required super.format,
    required super.location,
    super.salaryFrom,
    super.salaryTo,
    required super.skills,
    required super.description,
    required super.responsibilities,
    required super.requirements,
    required super.benefits,
    super.status,
    required super.employerId,
    required super.companyName,
    super.applicantsCount,
    super.viewsCount,
    super.deadline,
    required super.createdAt,
    required super.updatedAt,
  });

  factory VacancyModel.fromJson(Map<String, dynamic> json) {
    return VacancyModel(
      id: (json['id'] ?? json['_id']) as String?,
      title: json['title'] as String,
      type: json['type'] as String,
      format: json['format'] as String,
      location: json['location'] as String,
      salaryFrom: json['salary_from'] as int?,
      salaryTo: json['salary_to'] as int?,
      skills: (json['skills'] as List?)?.map((e) => e.toString()).toList() ?? [],
      description: json['description'] as String? ?? '',
      responsibilities: _joinIfList(json['responsibilities']),
      requirements: _joinIfList(json['requirements']),
      benefits: _joinIfList(json['benefits']),
      status: json['status'] as String? ?? 'Активна',
      employerId: (json['employer_id'] as String?) ?? '',
      companyName: json['company_name'] as String? ?? '',
      applicantsCount: json['applicants_count'] as int? ?? 0,
      viewsCount: json['views_count'] as int? ?? 0,
      deadline: json['deadline'] != null 
          ? DateTime.parse(json['deadline'] as String)
          : null,
      createdAt: _parseDate(json['created_at']) ?? DateTime.now(),
      updatedAt: _parseDate(json['updated_at']) ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      'title': title,
      'type': type,
      'format': format,
      'location': location,
      if (salaryFrom != null) 'salary_from': salaryFrom,
      if (salaryTo != null) 'salary_to': salaryTo,
      'skills': skills,
      'description': description,
      'responsibilities': responsibilities,
      'requirements': requirements,
      'benefits': benefits,
      'status': status,
      'employer_id': employerId,
      'company_name': companyName,
      'applicants_count': applicantsCount,
      'views_count': viewsCount,
      if (deadline != null) 'deadline': deadline!.toIso8601String(),
    };
  }

  VacancyEntity toEntity() {
    return VacancyEntity(
      id: id,
      title: title,
      type: type,
      format: format,
      location: location,
      salaryFrom: salaryFrom,
      salaryTo: salaryTo,
      skills: skills,
      description: description,
      responsibilities: responsibilities,
      requirements: requirements,
      benefits: benefits,
      status: status,
      employerId: employerId,
      companyName: companyName,
      applicantsCount: applicantsCount,
      viewsCount: viewsCount,
      deadline: deadline,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }
}

// Helpers used by factory constructor (top-level)
String _joinIfList(dynamic value) {
  if (value == null) return '';
  if (value is List) {
    return value.map((e) => e.toString()).join('\n');
  }
  return value.toString();
}

DateTime? _parseDate(dynamic v) {
  if (v == null) return null;
  try {
    return DateTime.parse(v.toString());
  } catch (_) {
    return null;
  }
}
