-- ============================================================
-- QuickBasket E-Commerce Database Schema
-- Database: ecommerce
-- ============================================================

CREATE DATABASE IF NOT EXISTS ecommerce;
USE ecommerce;

-- ── USERS TABLE ──────────────────────────────────────────────
-- usertype: 'normal' (default) or 'admin'
-- To make a user admin: UPDATE users SET usertype = 'admin' WHERE email = 'admin@example.com';
CREATE TABLE IF NOT EXISTS users (
    id       INT AUTO_INCREMENT PRIMARY KEY,
    name     VARCHAR(100)  NOT NULL,
    email    VARCHAR(150)  NOT NULL UNIQUE,
    password VARCHAR(255)  NOT NULL,
    phone    VARCHAR(15),
    userpic  VARCHAR(255)  DEFAULT NULL,
    location VARCHAR(200),
    usertype VARCHAR(20)   NOT NULL DEFAULT 'normal',
    created_at TIMESTAMP   DEFAULT CURRENT_TIMESTAMP
);

-- ── CATEGORY TABLE ───────────────────────────────────────────
CREATE TABLE IF NOT EXISTS category (
    id          INT AUTO_INCREMENT PRIMARY KEY,
    title       VARCHAR(100)  NOT NULL,
    description TEXT,
    created_at  TIMESTAMP     DEFAULT CURRENT_TIMESTAMP
);

-- ── PRODUCT TABLE ────────────────────────────────────────────
CREATE TABLE IF NOT EXISTS product (
    id          INT AUTO_INCREMENT PRIMARY KEY,
    title       VARCHAR(150)  NOT NULL,
    description TEXT,
    prodimage   VARCHAR(255),
    price       INT           NOT NULL DEFAULT 0,
    discount    INT           NOT NULL DEFAULT 0,
    qnty        INT           NOT NULL DEFAULT 0,
    cid         INT           NOT NULL,
    created_at  TIMESTAMP     DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (cid) REFERENCES category(id) ON DELETE CASCADE
);

-- ============================================================
-- SAMPLE SEED DATA (optional - remove if not needed)
-- ============================================================

-- Sample admin user (password: admin123 — store hashed in prod)
INSERT IGNORE INTO users (name, email, password, phone, location, usertype)
VALUES ('Admin User', 'admin@quickbasket.com', 'admin123', '9999999999', 'Mumbai', 'admin');

-- Sample normal user
INSERT IGNORE INTO users (name, email, password, phone, location, usertype)
VALUES ('Test User', 'user@quickbasket.com', 'user123', '8888888888', 'Delhi', 'normal');

-- Sample categories
INSERT IGNORE INTO category (title, description) VALUES
('Fruits',       'Fresh seasonal fruits from local farms'),
('Vegetables',   'Farm-fresh vegetables delivered daily'),
('Dairy',        'Milk, cheese, butter, and dairy products'),
('Snacks',       'Chips, biscuits, and packaged snacks'),
('Home Essentials', 'Cleaning and household essentials');

-- Sample products (update category IDs if needed)
INSERT IGNORE INTO product (title, description, prodimage, price, discount, qnty, cid) VALUES
('Fresh Apples',    'Juicy red apples from Himachal Pradesh',  'apple.jpg',   120, 10, 50, 1),
('Organic Mangoes', 'Sweet Alphonso mangoes – seasonal',        'mango.jpg',   250, 15, 30, 1),
('Spinach Bunch',   'Tender green spinach, freshly harvested',  'spinach.jpg',  40,  0, 80, 2),
('Carrots Pack',    'Crunchy orange carrots – 500g pack',       'carrot.jpg',   55,  5, 60, 2),
('Full Cream Milk', 'Fresh pasteurised full cream milk – 1L',   'milk.jpg',     60,  0, 100, 3),
('Paneer Block',    'Soft cottage cheese – 200g',               'paneer.jpg',  120, 10, 40, 3),
('Lays Classic',    'Classic salted potato chips – 75g',        'lays.jpg',     30,  0, 200, 4),
('Bourbon Biscuits','Chocolatey cream biscuits – 100g pack',    'bourbon.jpg',  25,  0, 150, 4),
('Vim Dish Wash',   'Lemon dishwash liquid – 750ml',            'vim.jpg',      99,  5, 70, 5);
