import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../core/config/api_config.dart';
import '../models/vacancy_model.dart';

abstract class VacancyRemoteDataSource {
  Future<List<VacancyModel>> getVacancies({String? status});
  Future<VacancyModel> getVacancyById(String id);
  Future<VacancyModel> createVacancy(VacancyModel vacancy);
  Future<VacancyModel> updateVacancy(String id, VacancyModel vacancy);
  Future<void> deleteVacancy(String id);
  Future<List<VacancyModel>> getEmployerVacancies(String employerId);
}

class VacancyRemoteDataSourceImpl implements VacancyRemoteDataSource {
  final http.Client client;

  VacancyRemoteDataSourceImpl({required this.client});

  @override
  Future<List<VacancyModel>> getVacancies({String? status}) async {
    final uri = Uri.parse('${ApiConfig.baseUrl}/api/vacancies')
        .replace(queryParameters: status != null ? {'status': status} : null);

    final response = await client.get(
      uri,
      headers: ApiConfig.defaultHeaders,
    ).timeout(ApiConfig.connectTimeout);

    if (response.statusCode == 200) {
      final decoded = json.decode(response.body);
      final List<dynamic> jsonList = decoded is Map<String, dynamic>
          ? (decoded['data'] as List<dynamic>? ?? [])
          : (decoded as List<dynamic>);
      return jsonList.map((e) => VacancyModel.fromJson(e as Map<String, dynamic>)).toList();
    } else {
      throw Exception('Failed to load vacancies: ${response.body}');
    }
  }

  @override
  Future<VacancyModel> getVacancyById(String id) async {
    final response = await client.get(
      Uri.parse('${ApiConfig.baseUrl}/api/vacancies/$id'),
      headers: ApiConfig.defaultHeaders,
    ).timeout(ApiConfig.connectTimeout);

    if (response.statusCode == 200) {
      final decoded = json.decode(response.body);
      final data = decoded is Map<String, dynamic> && decoded['data'] != null
          ? decoded['data'] as Map<String, dynamic>
          : decoded as Map<String, dynamic>;
      return VacancyModel.fromJson(data);
    } else {
      throw Exception('Failed to load vacancy: ${response.body}');
    }
  }

  @override
  Future<VacancyModel> createVacancy(VacancyModel vacancy) async {
    final payload = _buildPayloadFromModel(vacancy);
    final response = await client.post(
      Uri.parse('${ApiConfig.baseUrl}/api/vacancies'),
      headers: ApiConfig.defaultHeaders,
      body: json.encode(payload),
    ).timeout(ApiConfig.sendTimeout);

    if (response.statusCode == 201 || response.statusCode == 200) {
      final decoded = json.decode(response.body);
      final data = decoded is Map<String, dynamic> && decoded['data'] != null
          ? decoded['data'] as Map<String, dynamic>
          : decoded as Map<String, dynamic>;
      return VacancyModel.fromJson(data);
    } else {
      throw Exception('Failed to create vacancy: ${response.body}');
    }
  }

  @override
  Future<VacancyModel> updateVacancy(String id, VacancyModel vacancy) async {
    final payload = _buildPayloadFromModel(vacancy);
    final response = await client.put(
      Uri.parse('${ApiConfig.baseUrl}/api/vacancies/$id'),
      headers: ApiConfig.defaultHeaders,
      body: json.encode(payload),
    ).timeout(ApiConfig.sendTimeout);

    if (response.statusCode == 200) {
      final decoded = json.decode(response.body);
      final data = decoded is Map<String, dynamic> && decoded['data'] != null
          ? decoded['data'] as Map<String, dynamic>
          : decoded as Map<String, dynamic>;
      return VacancyModel.fromJson(data);
    } else {
      throw Exception('Failed to update vacancy: ${response.body}');
    }
  }

  @override
  Future<void> deleteVacancy(String id) async {
    final response = await client.delete(
      Uri.parse('${ApiConfig.baseUrl}/api/vacancies/$id'),
      headers: ApiConfig.defaultHeaders,
    ).timeout(ApiConfig.connectTimeout);

    if (response.statusCode != 200 && response.statusCode != 204) {
      throw Exception('Failed to delete vacancy: ${response.body}');
    }
  }

  @override
  Future<List<VacancyModel>> getEmployerVacancies(String employerId) async {
    final response = await client.get(
      Uri.parse('${ApiConfig.baseUrl}/api/employers/$employerId/vacancies'),
      headers: ApiConfig.defaultHeaders,
    ).timeout(ApiConfig.connectTimeout);

    if (response.statusCode == 200) {
      final decoded = json.decode(response.body);
      final List<dynamic> jsonList = decoded is Map<String, dynamic>
          ? (decoded['data'] as List<dynamic>? ?? [])
          : (decoded as List<dynamic>);
      return jsonList.map((e) => VacancyModel.fromJson(e as Map<String, dynamic>)).toList();
    } else {
      throw Exception('Failed to load employer vacancies: ${response.body}');
    }
  }
}

Map<String, dynamic> _buildPayloadFromModel(VacancyModel m) {
  // responsibilities/requirements/benefits in backend expect arrays
  List<String> _split(String s) => s
      .split(RegExp(r'\r?\n'))
      .map((e) => e.trim())
      .where((e) => e.isNotEmpty)
      .toList();

  // Salary payload: decide salary_type
  String salaryType;
  final Map<String, dynamic> salaryFields = {};
  if (m.salaryFrom != null && m.salaryTo != null) {
    salaryType = 'range';
    salaryFields['salary_from'] = m.salaryFrom;
    salaryFields['salary_to'] = m.salaryTo;
  } else if (m.salaryFrom != null) {
    salaryType = 'fixed';
    salaryFields['salary_fixed'] = m.salaryFrom;
  } else if (m.salaryTo != null) {
    salaryType = 'fixed';
    salaryFields['salary_fixed'] = m.salaryTo;
  } else {
    salaryType = 'none';
  }

  return {
    if (m.id != null) 'id': m.id,
    'title': m.title,
    'type': m.type,
    'format': m.format,
    'location': m.location,
    'salary_type': salaryType,
    ...salaryFields,
    'skills': m.skills,
    'description': m.description,
    'responsibilities': _split(m.responsibilities),
    'requirements': _split(m.requirements),
    'benefits': _split(m.benefits),
    'status': m.status,
    if (m.deadline != null) 'deadline': m.deadline!.toIso8601String(),
    // employer_id/company_name could be set by backend from auth; include if needed
    if (m.employerId.isNotEmpty) 'employer_id': m.employerId,
    if (m.companyName.isNotEmpty) 'company_name': m.companyName,
  };
}
