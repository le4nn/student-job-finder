class VacancyEntity {
  final String? id;
  final String title;
  final String type;
  final String format;
  final String location;
  final int? salaryFrom;
  final int? salaryTo;
  final List<String> skills;
  final String description;
  final String responsibilities;
  final String requirements;
  final String benefits;
  final String status;
  final String employerId;
  final String companyName;
  final int applicantsCount;
  final int viewsCount;
  final DateTime? deadline;
  final DateTime createdAt;
  final DateTime updatedAt;

  const VacancyEntity({
    this.id,
    required this.title,
    required this.type,
    required this.format,
    required this.location,
    this.salaryFrom,
    this.salaryTo,
    required this.skills,
    required this.description,
    required this.responsibilities,
    required this.requirements,
    required this.benefits,
    this.status = 'active',
    required this.employerId,
    required this.companyName,
    this.applicantsCount = 0,
    this.viewsCount = 0,
    this.deadline,
    required this.createdAt,
    required this.updatedAt,
  });

  VacancyEntity copyWith({
    String? id,
    String? title,
    String? type,
    String? format,
    String? location,
    int? salaryFrom,
    int? salaryTo,
    List<String>? skills,
    String? description,
    String? responsibilities,
    String? requirements,
    String? benefits,
    String? status,
    String? employerId,
    String? companyName,
    int? applicantsCount,
    int? viewsCount,
    DateTime? deadline,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return VacancyEntity(
      id: id ?? this.id,
      title: title ?? this.title,
      type: type ?? this.type,
      format: format ?? this.format,
      location: location ?? this.location,
      salaryFrom: salaryFrom ?? this.salaryFrom,
      salaryTo: salaryTo ?? this.salaryTo,
      skills: skills ?? this.skills,
      description: description ?? this.description,
      responsibilities: responsibilities ?? this.responsibilities,
      requirements: requirements ?? this.requirements,
      benefits: benefits ?? this.benefits,
      status: status ?? this.status,
      employerId: employerId ?? this.employerId,
      companyName: companyName ?? this.companyName,
      applicantsCount: applicantsCount ?? this.applicantsCount,
      viewsCount: viewsCount ?? this.viewsCount,
      deadline: deadline ?? this.deadline,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
