-- ================================================================================================================================================================================
-- CREATE TABLES — E-Commerce Cleaning Project
-- ================================================================================================================================================================================
-- Note: All columns are intentionally defined as VARCHAR.
-- The raw dataset contains mixed data types, invalid placeholders
-- (e.g. 'N/A', 'TRUE', 'ABCDE'), multiple date formats and 
-- numeric columns with string values — applying strict data types 
-- at this stage would cause import failures or silent data loss.
-- Proper data types will be assigned in 03_cleaning.sql 
-- after all issues are resolved.
-- ================================================================================================================================================================================

CREATE TABLE customers (
  customer_id VARCHAR(20),
  name VARCHAR(100),
  email VARCHAR(100),
  phone VARCHAR(20),
  city VARCHAR(50),
  state VARCHAR(50),
  pincode VARCHAR(10),
  gender VARCHAR(20),
  age VARCHAR(10),
  registration_date VARCHAR(20),
  loyalty_points VARCHAR(20),
  is_premium VARCHAR(10)
);

CREATE TABLE products (
  product_id VARCHAR(20),
  product_name VARCHAR(200),
  category VARCHAR(50),
  sub_category VARCHAR(50),
  brand VARCHAR(100),
  price VARCHAR(20),
  discount_percent VARCHAR(10),
  stock_quantity VARCHAR(20),
  rating VARCHAR(10),
  is_available VARCHAR(20)
);

CREATE TABLE orders (
  order_id VARCHAR(20),
  customer_id VARCHAR(20),
  order_date VARCHAR(20),
  delivery_date VARCHAR(20),
  status VARCHAR(30),
  payment_method VARCHAR(30),
  total_amount VARCHAR(20),
  shipping_charges VARCHAR(20),
  discount_applied VARCHAR(20),
  city VARCHAR(50),
  promo_code VARCHAR(20)
);

CREATE TABLE order_items (
  item_id VARCHAR(30),
  order_id VARCHAR(20),
  product_id VARCHAR(20),
  quantity VARCHAR(10),
  unit_price VARCHAR(20),
  total_price VARCHAR(20),
  return_requested VARCHAR(10),
  warehouse_location VARCHAR(50)
);