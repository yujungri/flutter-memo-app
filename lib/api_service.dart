import 'dart:convert';
import 'package:http/http.dart' as http;

class Memo {
  final int id;
  final String title;
  final String content;

  Memo({required this.id, required this.title, required this.content});

  factory Memo.fromJson(Map<String, dynamic> json) {
    return Memo(
      id: json['id'],
      title: json['title'],
      content: json['content'],
    );
  }
}

class ApiService {
  //final String baseUrl = 'http://localhost:3000'; // 🟢 Node.js 서버 주소
  final String baseUrl = 'http://127.0.0.1:3000';  // 🟢 `localhost` 대신 `127.0.0.1` 사용!
  // 전체 메모 조회 (GET)
  Future<List<Memo>> getMemos() async {
    final response = await http.get(Uri.parse('$baseUrl/memos'));

    if (response.statusCode == 200) {
      List<dynamic> jsonList = json.decode(response.body);
      return jsonList.map((json) => Memo.fromJson(json)).toList();
    } else {
      throw Exception('메모 목록을 불러오지 못했습니다.');
    }
  }

  // 메모 생성 (POST)
  Future<Memo> createMemo(String title, String content) async {
    final response = await http.post(
      Uri.parse('$baseUrl/memos'),
      headers: {"Content-Type": "application/json"},
      body: json.encode({"title": title, "content": content}),
    );

    if (response.statusCode == 200) {
      return Memo.fromJson(json.decode(response.body));
    } else {
      throw Exception('메모 생성에 실패했습니다.');
    }
  }

  // 메모 삭제 (DELETE)
  Future<void> deleteMemo(int id) async {
    final response = await http.delete(Uri.parse('$baseUrl/memos/$id'));

    if (response.statusCode != 200) {
      throw Exception('메모 삭제에 실패했습니다.');
    }
  }
}
