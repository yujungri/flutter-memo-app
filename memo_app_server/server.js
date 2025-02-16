const express = require('express');
const mysql = require('mysql2');
const cors = require('cors');  // 🟢 CORS 추가
const app = express();

app.use(cors({
  origin: '*',  // 🟢 모든 요청 허용
  methods: ['GET', 'POST', 'PUT', 'DELETE'],  // 🟢 허용할 HTTP 메서드 지정
  allowedHeaders: ['Content-Type'],  // 🟢 요청 허용 헤더 지정
}));

app.use(express.json()); // JSON 파싱

// MySQL 연결 설정
const connection = mysql.createConnection({
  host: 'localhost',
  user: 'root',
  password: '', // MySQL 비밀번호
  database: 'memo_app_db'
});

// MySQL 연결 체크
connection.connect(err => {
  if (err) {
    console.error('MySQL 연결 실패:', err);
    return;
  }
  console.log('MySQL에 연결되었습니다!');
});

// 🟢 [C] Create: 새 메모 추가
app.post('/memos', (req, res) => {
  const { title, content } = req.body;
  
  if (!title || !content) {
    return res.status(400).json({ error: "제목과 내용을 입력하세요." });
  }

  const sql = 'INSERT INTO memos (title, content) VALUES (?, ?)';
  connection.query(sql, [title, content], (err, result) => {
    if (err) {
      console.error('MySQL Insert Error:', err);
      return res.status(500).json({ error: "데이터 저장 실패" });
    }
    res.json({ id: result.insertId, title, content });
  });
});

// 🟢 [R] Read: 전체 메모 조회
app.get('/memos', (req, res) => {
  connection.query('SELECT * FROM memos', (err, results) => {
    if (err) {
      console.error('MySQL Select Error:', err);
      return res.status(500).json({ error: "데이터 조회 실패" });
    }
    res.json(results);
  });
});

// 🟢 [D] Delete: 메모 삭제
app.delete('/memos/:id', (req, res) => {
  const id = req.params.id;
  connection.query('DELETE FROM memos WHERE id = ?', [id], (err, result) => {
    if (err) {
      console.error('MySQL Delete Error:', err);
      return res.status(500).json({ error: "메모 삭제 실패" });
    }
    res.json({ message: '메모가 삭제되었습니다.' });
  });
});

// ✅ `PORT`를 한 번만 선언하도록 수정!
const PORT = 3000;
app.listen(PORT, () => {
  console.log(`서버가 http://localhost:${PORT} 에서 실행 중입니다.`);
});
