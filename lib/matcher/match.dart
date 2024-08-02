import 'dart:convert';
import 'dart:io';
import 'dart:async';
import 'package:http/http.dart' as http;

Future<MatchResult> getMatches(String inputJson) async {
  final queryParameters = {
    'input': inputJson,
  };
  final uri = Uri.http('localhost', '/matcher/match', queryParameters);
  final response = await http.post(uri, headers: {
    HttpHeaders.contentTypeHeader: 'application/x-www-form-urlencoded',
  });
  if (response.statusCode == 200) {
    return MatchResult.fromJson(jsonDecode(response.body));
  } else {
    throw Exception('Failed to get matches');
  }
}

Future<MatchResult> initMatches() async {
  return MatchResult.fromJson(jsonDecode('{"result": ""}'));
}

class MatchResult {
  final dynamic matchResult;

  const MatchResult({
    required this.matchResult,
  });

  factory MatchResult.fromJson(Map<String, dynamic> json) {
    return MatchResult(matchResult: json['result']);
  }
}
