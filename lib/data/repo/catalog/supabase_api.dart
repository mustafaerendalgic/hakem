import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

class SupabaseApi with ChangeNotifier {
  
  static final String? _body = dotenv.env['SUPABASE_URL'];
  static final String? _key = dotenv.env['SUPABASE_ANON_KEY'];

  static Future<List<Map<String, dynamic>>> fetchViolationInfo(
    String tableName, {
    String select = '*',
    String? filter,
    String? order,
  }) async {
    if (_body == null || _key == null)
      throw Exception(
        'SUPABASE_URL veya SUPABASE_ANON_KEY .env dosyasında bulunamadı',
      );
    final String baseUrl = _body!;
    final query = StringBuffer('select=$select');
    if (filter != null) query.write('&$filter');
    if (order != null) query.write('&$order');
    final response = await http.get(
      Uri.parse(baseUrl + '/rest/v1/' + tableName + '?$query'),
      headers: {
        'apiKey': _key!,
        'Authorization': 'Bearer  $_key',
        'Content-Type': 'application/json',
      },
    );
    if (response.statusCode != 200) {
      throw Exception(
        'Failed to fetch $tableName: ${response.statusCode} ${response.body}',
      );
    }

    final body = response.body;
    final jsonList = jsonDecode(body) as List<dynamic>;
    return jsonList.cast<Map<String, dynamic>>();
  }

  static Future<Map<String, dynamic>> callRpc(
    String functionName, {
    Map<String, dynamic>? params,
  }) async {
    if (_body == null || _key == null) {
      throw Exception('SUPABASE_URL veya SUPABASE_ANON_KEY .env dosyasında bulunamadı');
    }
    final String baseUrl = _body!;
    final response = await http.post(
      Uri.parse('$baseUrl/rest/v1/rpc/$functionName'),
      headers: {
        'apiKey': _key!,
        'Authorization': 'Bearer $_key',
        'Content-Type': 'application/json',
      },
      body: jsonEncode(params ?? {}),
    );
    if (response.statusCode != 200) {
      throw Exception('RPC $functionName failed: ${response.statusCode} ${response.body}');
    }
    return jsonDecode(response.body) as Map<String, dynamic>;
  }
}
