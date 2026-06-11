-------------------------------------------------------------------------------------------------------------------------------------------------
-- CREATING DATABASE
-------------------------------------------------------------------------------------------------------------------------------------------------
CREATE DATABASE Ecommerce;
USE Ecommerce;
-------------------------------------------------------------------------------------------------------------------------------------------------
-- CREATING BACKUP BEFORE CLEANING
-------------------------------------------------------------------------------------------------------------------------------------------------

CREATE TABLE customers_backup AS SELECT * FROM customers;
CREATE TABLE products_backup AS SELECT * FROM products;
CREATE TABLE orders_backup AS SELECT * FROM orders;
CREATE TABLE order_items_backup AS SELECT * FROM order_items;

