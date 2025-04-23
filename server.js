const express = require('express');
const cors = require('cors');
const bodyParser = require('body-parser');
const db = require('./db');

const app = express();
app.use(cors());
app.use(bodyParser.json());

const PORT = process.env.PORT || 5000;

app.get('/recipes', async (req, res) => {
  try {
    const [rows] = await db.query('SELECT * FROM Recipes');
    res.json(rows);
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
});

app.listen(PORT, () => {
  console.log(Server running on port ${PORT});
});