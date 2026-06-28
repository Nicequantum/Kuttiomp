import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:kuttiomp_mobile/models/lexical_entry.dart';
import 'package:kuttiomp_mobile/models/speaker.dart';
import 'package:kuttiomp_mobile/utils/constants.dart';

class ApiService {
  final String baseUrl;

  ApiService({String? baseUrl}) : baseUrl = baseUrl ?? AppConstants.apiBaseUrl;

  Future<Map<String, dynamic>> health() async {
    final res = await http.get(Uri.parse('$baseUrl/health'));
    if (res.statusCode != 200) throw Exception('Health check failed');
    return json.decode(res.body) as Map<String, dynamic>;
  }

  Future<List<Speaker>> getSpeakers() async {
    final res = await http.get(Uri.parse('$baseUrl/api/v1/speakers'));
    if (res.statusCode != 200) throw Exception('Failed to load speakers');
    final list = json.decode(res.body) as List;
    return list.map((e) => Speaker.fromJson(e as Map<String, dynamic>)).toList();
  }

  Future<List<LexicalEntry>> getLexicon({String? search}) async {
    final uri = Uri.parse('$baseUrl/api/v1/lexicon').replace(
      queryParameters: search != null ? {'search': search} : null,
    );
    final res = await http.get(uri);
    if (res.statusCode != 200) throw Exception('Failed to load lexicon');
    final list = json.decode(res.body) as List;
    return list
        .map((e) => LexicalEntry.fromJson(e as Map<String, dynamic>))
        .toList();
  }
}