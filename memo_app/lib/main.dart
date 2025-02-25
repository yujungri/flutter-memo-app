import 'package:flutter/material.dart';
import 'api_service.dart'; // 🟢 API 서비스 불러오기

void main() {
  runApp(const MyApp()); //앱을 실행하고, MyApp이 앱의 기본 구조가 됨.
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: MemoScreen(),
    ); //MaterialApp: Flutter에서 기본적인 앱 구조를 설정하는 위젯
  }
}

class MemoScreen extends StatefulWidget {
  const MemoScreen({super.key});

  @override
  _MemoScreenState createState() => _MemoScreenState();
}

class _MemoScreenState extends State<MemoScreen> {
  List<Memo> memos = [];
  TextEditingController titleController = TextEditingController();
  TextEditingController contentController = TextEditingController();
  final ApiService apiService = ApiService();

  @override
  void initState() {
    super.initState();
    fetchMemos();
  }

  // 🟢 메모 불러오기
  Future<void> fetchMemos() async {
    try {
      List<Memo> loadedMemos = await apiService.getMemos();
      setState(() {
        memos = loadedMemos;
      });
    } catch (e) {
      print('메모 불러오기 오류: $e');
    }
  }

  // 🟢 메모 추가하기
  Future<void> addMemo() async {
    if (titleController.text.isEmpty || contentController.text.isEmpty) return;
    try {
      Memo newMemo = await apiService.createMemo(
          titleController.text, contentController.text);
      setState(() {
        memos.add(newMemo);
      });
      titleController.clear();
      contentController.clear();
    } catch (e) {
      print('메모 추가 오류: $e');
    }
  }

  // 🟢 메모 삭제하기
  Future<void> deleteMemo(int id) async {
    try {
      await apiService.deleteMemo(id);
      setState(() {
        memos.removeWhere((memo) => memo.id == id);
      });
    } catch (e) {
      print('메모 삭제 오류: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("메모장")),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                TextField(
                  controller: titleController,
                  decoration: const InputDecoration(labelText: "제목"),
                ),
                TextField(
                  controller: contentController,
                  decoration: const InputDecoration(labelText: "내용"),
                ),
                ElevatedButton(
                  onPressed: addMemo,
                  child: const Text("메모 추가"),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: memos.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(memos[index].title),
                  subtitle: Text(memos[index].content),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete),
                    onPressed: () => deleteMemo(memos[index].id),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
