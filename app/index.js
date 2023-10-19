const express = require('express');
const mysql = require('promise-mysql');
const app = express();
const port = 8080;

const createUnixSocketPool = async () => {
  return mysql.createPool({
    user: "test-user",
    password: "password_1234",
    database: "database",
    socketPath: "/cloudsql/<CloudSQLの接続名>",
  });
};

let pool;

(async () => {
  pool = await createUnixSocketPool();
})();

app.get('/', async (req, res) => {
  try {
    const connection = await pool.getConnection();
    const results = await connection.query('SELECT * FROM users');
    connection.release();
    res.send(results);
  } catch (error) {
    res.status(500).send(error.message);
  }
});

app.listen(port, () => {
  console.log(`App running on http://localhost:${port}`);
});
