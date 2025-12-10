-- Schema
DROP DATABASE IF EXISTS restaurant_search;
CREATE DATABASE restaurant_search;
USE restaurant_search;

CREATE TABLE restaurants (
  id INT AUTO_INCREMENT PRIMARY KEY,
  name VARCHAR(255) NOT NULL,
  city VARCHAR(120) NOT NULL
);

CREATE TABLE menu_items (
  id INT AUTO_INCREMENT PRIMARY KEY,
  restaurant_id INT NOT NULL,
  name VARCHAR(255) NOT NULL,
  price DECIMAL(10,2) NOT NULL,
  FOREIGN KEY (restaurant_id) REFERENCES restaurants(id)
);

CREATE TABLE orders (
  id INT AUTO_INCREMENT PRIMARY KEY,
  menu_item_id INT NOT NULL,
  created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (menu_item_id) REFERENCES menu_items(id)
);

-- Sample Data
INSERT INTO restaurants (name, city) VALUES
('Hyderabadi Spice House', 'Hyderabad'),
('Biryani Palace', 'Bengaluru'),
('Royal Dum Biryani', 'Hyderabad'),
('Coastal Kitchen', 'Chennai'),
('Punjabi Zaika', 'Delhi'),
('Andhra Ruchulu', 'Hyderabad'),
('Lucknowi Handi', 'Lucknow'),
('Bombay Treats', 'Mumbai'),
('Goan Spice Hut', 'Goa'),
('Kolkata Kitchen', 'Kolkata');

INSERT INTO menu_items (restaurant_id, name, price) VALUES
(1, 'Chicken Biryani', 220),
(1, 'Mutton Biryani', 320),
(2, 'Chicken Biryani', 200),
(2, 'Veg Biryani', 160),
(3, 'Chicken Biryani', 250),
(4, 'Fish Biryani', 280),
(5, 'Paneer Biryani', 190),
(6, 'Chicken Biryani', 230),
(7, 'Lucknowi Biryani', 260),
(8, 'Bombay Biryani', 210),
(9, 'Prawn Biryani', 290),
(10, 'Kolkata Biryani', 240);

-- Orders (one item per order for simplicity)
INSERT INTO orders (menu_item_id) VALUES
(1),(1),(1),(1),(1),(1),(1),(1),(1),(1),
(1),(1),(1),(1),(1),(1),(1),(1),(1),(1),
(2),(2),(2),
(3),(3),(3),(3),(3),(3),(3),(3),
(4),(4),(4),(4),(4),
(5),(5),(5),
(6),(6),(6),(6),(6),(6),
(7),(7),(7),(7),
(8),(8),(8),
(9),(9),(9),(9),(9),(9),
(10),(10),(10);

