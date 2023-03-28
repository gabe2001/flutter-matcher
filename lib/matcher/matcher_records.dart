import 'dart:convert';
import 'dart:async';
import 'dart:io';
import 'package:http/http.dart' as http;

Future<RecordsCount> getRecordsCount() async {
  final response =
      await http.get(Uri.parse('http://localhost/matcher/recordsCount'));
  if (response.statusCode == 200) {
    return RecordsCount.fromJson(jsonDecode(response.body));
  } else {
    throw Exception('Failed to get records count');
  }
}

Future<RecordsCount> flushRecords() async {
  final response =
      await http.get(Uri.parse('http://localhost/matcher/flushData'));
  if (response.statusCode == 200) {
    return RecordsCount.fromJson(jsonDecode(response.body));
  } else {
    throw Exception('Failed to delete all records');
  }
}

Future<RecordsCount> addExcelData() async {
  final queryParameters = {
    'fileName': '/data/HDD.xlsx',
    'sheetName': 'HDD',
    'matchKeys':
        'Capacity,Interface,Form Factor,HPE Model Number,Spares,Drv Assy,Offering,Connection,Option/ZMOD Description,Commodity',
  };
  final uri = Uri.http('localhost', '/matcher/addExcelData', queryParameters);
  final response = await http.get(uri, headers: {
    HttpHeaders.contentTypeHeader: 'application/json',
  });
  if (response.statusCode == 200) {
    return RecordsCount.fromJson(jsonDecode(response.body));
  } else {
    throw Exception('Failed to load Excel records');
  }
}

class RecordsCount {
  final int records;

  const RecordsCount({
    required this.records,
  });

  factory RecordsCount.fromJson(Map<String, dynamic> json) {
    return RecordsCount(records: json['records']);
  }
}
