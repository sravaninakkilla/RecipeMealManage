-- Create Database
CREATE DATABASE RecipeMealDB;
USE RecipeMealDB;

-- Users Table (Customers & Admins)
CREATE TABLE Users (
    user_id INT AUTO_INCREMENT PRIMARY KEY,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    password_hash VARCHAR(255) NOT NULL,
    user_role ENUM('customer', 'admin') NOT NULL DEFAULT 'customer',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Recipes Table
CREATE TABLE Recipes (
    recipe_id INT AUTO_INCREMENT PRIMARY KEY,
    recipe_name VARCHAR(200) NOT NULL,
    description TEXT,
    preparation_time INT NOT NULL,  -- in minutes
    cooking_time INT NOT NULL,  -- in minutes
    servings INT NOT NULL
);

-- Ingredients Table
CREATE TABLE Ingredients (
    ingredient_id INT AUTO_INCREMENT PRIMARY KEY,
    ingredient_name VARCHAR(100) NOT NULL,
    unit VARCHAR(50) NOT NULL  -- e.g., grams, cups, pieces
);

-- Recipe Ingredients Table (Many-to-Many)
CREATE TABLE RecipeIngredients (
    recipe_id INT,
    ingredient_id INT,
    quantity DECIMAL(10,2) NOT NULL,
    PRIMARY KEY (recipe_id, ingredient_id),
    FOREIGN KEY (recipe_id) REFERENCES Recipes(recipe_id) ON DELETE CASCADE,
    FOREIGN KEY (ingredient_id) REFERENCES Ingredients(ingredient_id) ON DELETE CASCADE
);

-- Nutrition Table (Per Serving)
CREATE TABLE Nutrition (
    nutrition_id INT AUTO_INCREMENT PRIMARY KEY,
    recipe_id INT,
    calories INT NOT NULL,
    protein DECIMAL(10,2) NOT NULL,  -- in grams
    fat DECIMAL(10,2) NOT NULL,  -- in grams
    carbohydrates DECIMAL(10,2) NOT NULL,  -- in grams
    fiber DECIMAL(10,2) NOT NULL,  -- in grams
    sugar DECIMAL(10,2) NOT NULL,  -- in grams
    FOREIGN KEY (recipe_id) REFERENCES Recipes(recipe_id) ON DELETE CASCADE
);

-- Meal Plans Table
CREATE TABLE MealPlans (
    meal_plan_id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT,
    meal_plan_name VARCHAR(200) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES Users(user_id) ON DELETE CASCADE
);

-- Meal Plan Recipes (Many-to-Many)
CREATE TABLE MealPlanRecipes (
    meal_plan_id INT,
    recipe_id INT,
    PRIMARY KEY (meal_plan_id, recipe_id),
    FOREIGN KEY (meal_plan_id) REFERENCES MealPlans(meal_plan_id) ON DELETE CASCADE,
    FOREIGN KEY (recipe_id) REFERENCES Recipes(recipe_id) ON DELETE CASCADE
);

-- Orders Table (For ordering meal ingredients)
CREATE TABLE Orders (
    order_id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT,
    total_price DECIMAL(10,2) NOT NULL,
    status ENUM('pending', 'confirmed', 'shipped', 'delivered') DEFAULT 'pending',
    order_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES Users(user_id) ON DELETE CASCADE
);

-- Order Details Table (Many-to-Many for Orders and Ingredients)
CREATE TABLE OrderDetails (
    order_id INT,
    ingredient_id INT,
    quantity DECIMAL(10,2) NOT NULL,
    price DECIMAL(10,2) NOT NULL,
    PRIMARY KEY (order_id, ingredient_id),
    FOREIGN KEY (order_id) REFERENCES Orders(order_id) ON DELETE CASCADE,
    FOREIGN KEY (ingredient_id) REFERENCES Ingredients(ingredient_id) ON DELETE CASCADE
);

-- -----------------------------------
-- DATA INSERTION
-- -----------------------------------

-- Insert Sample Users
INSERT INTO Users (first_name, last_name, email, password_hash, user_role) VALUES
('Sravani', 'Venkateswararao', 'sravani@example.com', 'hashed_password', 'admin'),
('Rajesh', 'Vig', 'rajesh@example.com', 'hashed_password', 'customer');

-- Insert Sample Recipes
INSERT INTO Recipes (recipe_name, description, preparation_time, cooking_time, servings) VALUES
('Butter Chicken', 'A rich and creamy Indian dish.', 20, 40, 4),
('Vegetable Biryani', 'A fragrant rice dish with mixed vegetables.', 15, 45, 4),
('Gongura Mutton', 'A tangy and spicy mutton curry made with sorrel leaves.', 30, 60, 4),
('Chicken Chettinad', 'A flavorful South Indian dish with aromatic spices.', 20, 45, 4);

-- Insert Sample Ingredients
INSERT INTO Ingredients (ingredient_name, unit) VALUES
('Chicken', 'grams'),
('Butter', 'tablespoons'),
('Rice', 'cups'),
('Carrots', 'pieces'),
('Onions', 'pieces'),
('Garlic', 'cloves'),
('Mutton', 'grams'),
('Gongura Leaves (Sorrel Leaves)', 'cups'),
('Green Chilies', 'pieces'),
('Red Chilies', 'pieces'),
('Black Pepper', 'teaspoons'),
('Fennel Seeds', 'teaspoons'),
('Coriander Seeds', 'teaspoons'),
('Coconut', 'cups'),
('Tomatoes', 'pieces'),
('Curry Leaves', 'sprigs');

-- Insert Recipe Ingredients
INSERT INTO RecipeIngredients (recipe_id, ingredient_id, quantity) VALUES
-- Butter Chicken
((SELECT recipe_id FROM Recipes WHERE recipe_name = 'Butter Chicken'), 
 (SELECT ingredient_id FROM Ingredients WHERE ingredient_name = 'Chicken'), 500),  
((SELECT recipe_id FROM Recipes WHERE recipe_name = 'Butter Chicken'), 
 (SELECT ingredient_id FROM Ingredients WHERE ingredient_name = 'Butter'), 3),  
-- Vegetable Biryani
((SELECT recipe_id FROM Recipes WHERE recipe_name = 'Vegetable Biryani'), 
 (SELECT ingredient_id FROM Ingredients WHERE ingredient_name = 'Rice'), 2),  
((SELECT recipe_id FROM Recipes WHERE recipe_name = 'Vegetable Biryani'), 
 (SELECT ingredient_id FROM Ingredients WHERE ingredient_name = 'Carrots'), 2),  
((SELECT recipe_id FROM Recipes WHERE recipe_name = 'Vegetable Biryani'), 
 (SELECT ingredient_id FROM Ingredients WHERE ingredient_name = 'Onions'), 1),  
-- Gongura Mutton
((SELECT recipe_id FROM Recipes WHERE recipe_name = 'Gongura Mutton'), 
 (SELECT ingredient_id FROM Ingredients WHERE ingredient_name = 'Mutton'), 500),  
((SELECT recipe_id FROM Recipes WHERE recipe_name = 'Gongura Mutton'), 
 (SELECT ingredient_id FROM Ingredients WHERE ingredient_name = 'Gongura Leaves (Sorrel Leaves)'), 2), 
((SELECT recipe_id FROM Recipes WHERE recipe_name = 'Gongura Mutton'), 
 (SELECT ingredient_id FROM Ingredients WHERE ingredient_name = 'Green Chilies'), 4),  
((SELECT recipe_id FROM Recipes WHERE recipe_name = 'Gongura Mutton'), 
 (SELECT ingredient_id FROM Ingredients WHERE ingredient_name = 'Tomatoes'), 2),
-- Chicken Chettinad
((SELECT recipe_id FROM Recipes WHERE recipe_name = 'Chicken Chettinad'), 
 (SELECT ingredient_id FROM Ingredients WHERE ingredient_name = 'Chicken'), 500),  
((SELECT recipe_id FROM Recipes WHERE recipe_name = 'Chicken Chettinad'), 
 (SELECT ingredient_id FROM Ingredients WHERE ingredient_name = 'Black Pepper'), 2),  
((SELECT recipe_id FROM Recipes WHERE recipe_name = 'Chicken Chettinad'), 
 (SELECT ingredient_id FROM Ingredients WHERE ingredient_name = 'Fennel Seeds'), 1),  
((SELECT recipe_id FROM Recipes WHERE recipe_name = 'Chicken Chettinad'), 
 (SELECT ingredient_id FROM Ingredients WHERE ingredient_name = 'Coriander Seeds'), 2),  
((SELECT recipe_id FROM Recipes WHERE recipe_name = 'Chicken Chettinad'), 
 (SELECT ingredient_id FROM Ingredients WHERE ingredient_name = 'Coconut'), 1),  
((SELECT recipe_id FROM Recipes WHERE recipe_name = 'Chicken Chettinad'), 
 (SELECT ingredient_id FROM Ingredients WHERE ingredient_name = 'Curry Leaves'), 1);

-- Insert Nutrition Data
INSERT INTO Nutrition (recipe_id, calories, protein, fat, carbohydrates, fiber, sugar) VALUES
((SELECT recipe_id FROM Recipes WHERE recipe_name = 'Butter Chicken'), 450, 35, 25, 10, 2, 3),
((SELECT recipe_id FROM Recipes WHERE recipe_name = 'Vegetable Biryani'), 350, 8, 5, 65, 5, 2),
((SELECT recipe_id FROM Recipes WHERE recipe_name = 'Gongura Mutton'), 500, 40, 30, 12, 3, 1),
((SELECT recipe_id FROM Recipes WHERE recipe_name = 'Chicken Chettinad'), 420, 38, 22, 15, 4, 2);
