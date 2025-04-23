Modular Route file 

Recipes.js

// routes/recipes.js
const express = require('express');
const router = express.Router();
const db = require('../db'); // your MySQL pool

// GET all recipes
router.get('/', async (req, res) => {
  try {
    const [rows] = await db.query('SELECT * FROM Recipes');
    res.json(rows);
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
});

// GET a single recipe by ID
router.get('/:id', async (req, res) => {
  const recipeId = req.params.id;
  try {
    const [recipe] = await db.query('SELECT * FROM Recipes WHERE recipe_id = ?', [recipeId]);
    if (recipe.length === 0) return res.status(404).json({ message: 'Recipe not found' });

    const [ingredients] = await db.query(`
      SELECT i.ingredient_name, ri.quantity, i.unit
      FROM RecipeIngredients ri
      JOIN Ingredients i ON ri.ingredient_id = i.ingredient_id
      WHERE ri.recipe_id = ?
    `, [recipeId]);

    const [nutrition] = await db.query('SELECT * FROM Nutrition WHERE recipe_id = ?', [recipeId]);

    res.json({ ...recipe[0], ingredients, nutrition: nutrition[0] });
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
});

module.exports = router;
