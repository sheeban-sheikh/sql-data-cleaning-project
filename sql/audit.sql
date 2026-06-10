-- ====================================================================================================================================================================
-- AUDIT 1: CUSTOMERS
-- ===================================================================================================================================================================
-- 1.1 NULL Check
SELECT 'customers' AS tbl,
  COUNT(*) AS total_rows,
  COUNT(CASE WHEN TRIM(customer_id) = '' OR name IS NULL THEN 1 END) AS null_customer_id,
  COUNT(CASE WHEN TRIM(name) = '' OR name IS NULL THEN 1 END) AS null_name,
  COUNT(CASE WHEN TRIM(email) = '' OR email IS NULL THEN 1 END) AS null_email,
  COUNT(CASE WHEN TRIM(phone) = '' OR phone IS NULL THEN 1 END) AS null_phone,
  COUNT(CASE WHEN TRIM(city) = '' OR city IS NULL THEN 1 END) AS null_city,
  COUNT(CASE WHEN TRIM(age) = '' OR age IS NULL THEN 1 END) AS null_age,
  COUNT(CASE WHEN TRIM(gender) = '' OR gender IS NULL THEN 1 END) AS null_gender,
  COUNT(CASE WHEN TRIM(registration_date) = '' OR registration_date IS NULL THEN 1 END) AS null_reg_date,
  COUNT(CASE WHEN TRIM(state) = '' OR state IS NULL THEN 1 END) AS null_state,
  COUNT(CASE WHEN TRIM(pincode) = '' OR pincode IS NULL THEN 1 END) AS null_pincode,
  COUNT(CASE WHEN TRIM(loyalty_points) = '' OR loyalty_points IS NULL THEN 1 END) AS null_loyalty_points,
  COUNT(CASE WHEN TRIM(is_premium) = '' OR is_premium IS NULL THEN 1 END) AS null_is_premium
FROM customers;
-- 1.2 Duplicate Check
SELECT COUNT(*) AS duplicate_email FROM(SELECT email,COUNT(*) AS cnt 
FROM customers
WHERE email<> 'NA' and email <>''
GROUP BY email
HAVING cnt>1) t;

SELECT COUNT(*) AS duplicate_phone FROM(SELECT phone,COUNT(*) AS cnt 
FROM customers
WHERE phone NOT IN ('0000000000','N/A')
GROUP BY phone
HAVING cnt>1) t;


-- 1.3.Inconsistent formatting check (email, state, city, gender, status kitni variations hain)
-- Validating Email Format
SELECT COUNT(*) as invalid_email_format_count FROM
(SELECT email FROM customers
WHERE email NOT LIKE '%@%' and email NOT IN ('NA',''))t;

-- Checking for Leading and Trailing Spaces in Email Values
SELECT email FROM customers
WHERE email<>TRIM(email);

-- Checking for Invalid Placeholder Values
SELECT email FROM customers
WHERE email IN ('NA','N/A','Unknown','-');

-- Analyzing Email Domain Distribution
SELECT 
    SUBSTRING_INDEX(email, '@', -1) AS domain,
    COUNT(*) AS total_users
FROM customers
WHERE email IS NOT NULL
  AND email <> '' AND email<>'NA'
GROUP BY domain
ORDER BY total_users DESC;

-- Counting Unique Email Addresses
SELECT COUNT(DISTINCT email) AS unique_email_count
FROM customers;

-- Analyzing City Value Distribution
SELECT DISTINCT city, COUNT(*) as frequency FROM customers
GROUP BY city
ORDER BY frequency DESC;

-- Checking for case inconsistencies in city column
SELECT LOWER(city) AS normalized_city,COUNT(DISTINCT BINARY city) AS variations
FROM customers
GROUP BY LOWER(city)
HAVING COUNT(DISTINCT BINARY city)>1;

-- Checking for Leading and Trailing Spaces in City Column
SELECT city
FROM customers
WHERE city <> TRIM(city);
-- Checking Value Length in City Column 
SELECT city,LENGTH(city) AS city_length
FROM customers;
-- Checking for Numeric Values in City Column
SELECT city 
FROM customers
WHERE city REGEXP '[0-9]';
-- Checking for Invalid Placeholder Values in City Column
SELECT city
FROM customers
WHERE city IN ('N/A','NA', 'Unknown', '-');
-- Checking for Special Characters in City Column
SELECT city 
FROM customers
WHERE city REGEXP '[^A-Za-z ]';

-- Analyzing state Value Distribution
SELECT DISTINCT state, COUNT(*) as frequency FROM customers
GROUP BY state
ORDER BY state;

-- Checking for Leading and Trailing Spaces in state Column
SELECT state
FROM customers
WHERE state <> TRIM(state);

-- Checking for case inconsistencies in state column
SELECT LOWER(state) AS normalized_state,COUNT(DISTINCT BINARY state) AS variations
FROM customers
GROUP BY LOWER(state)
HAVING COUNT(DISTINCT BINARY state)>1;

-- Checking Value Length in state Column 
SELECT DISTINCT state,LENGTH(state) AS State_length
FROM customers;

-- Checking for Numeric Values in state Column
SELECT state 
FROM customers
WHERE state REGEXP '[0-9]';

-- Checking for Invalid Placeholder Values in state Column
SELECT state
FROM customers
WHERE state IN ('N/A', 'Unknown', '-');

-- Checking for Special Characters in state Column
SELECT state 
FROM customers
WHERE state REGEXP '[^A-Za-z ]';

-- Analyzing gender Value Distribution
SELECT gender, COUNT(*) AS frequency FROM customers
GROUP BY gender 
ORDER BY gender;

-- Checking for Leading and Trailing Spaces in gender Column
SELECT gender
FROM customers
WHERE gender <> TRIM(gender);

-- Checking Value Length in gender Column 
SELECT gender,LENGTH(gender) AS city_length
FROM customers;

-- Checking for Invalid Placeholder Values in gender Column
SELECT gender
FROM customers
WHERE gender IN ('N/A', 'Unknown', '-');

-- Checking for Leading and Trailing Spaces in Name Values
SELECT name FROM customers
WHERE name<>TRIM(name);

-- Checking for Numeric Characters in Names
SELECT name FROM customers
WHERE name REGEXP '[0-9]';

-- Analyzing Name Length Distribution
SELECT name,
       LENGTH(name) AS name_length
FROM customers
WHERE LENGTH(name) < 3
   OR LENGTH(name) > 50;
   
-- Checking Unique values in is_premium column
SELECT DISTINCT is_premium FROM customers;

-- Checking for Negative and Zero Age Values
SELECT age FROM customers
WHERE age<=0 ;

-- Checking for Unrealistic Age Values
SELECT CAST(age AS SIGNED) AS age FROM customers
WHERE CAST(age AS SIGNED)>100;

-- Checking for Non-Numeric Values in Age Column
SELECT CAST(age AS SIGNED) AS age
FROM customers
WHERE CAST(age AS SIGNED) REGEXP '[^0-9]';

-- Analyzing Age Distribution
SELECT CAST(age AS SIGNED) AS age, COUNT(*) AS frequency FROM customers
GROUP BY age
ORDER BY age ASC;

-- Analyzing Age Range
SELECT MIN(CAST(age AS SIGNED)) min_age,MAX(CAST(age AS SIGNED)) AS max_age 
FROM customers
WHERE age!='';

-- Checking for Non-Numeric Values in Pincode Column
SELECT pincode FROM customers
WHERE pincode REGEXP '[^0-9]';

-- Validating Pincode Length
SELECT pincode FROM customers
WHERE LENGTH(pincode)!=6;

-- Checking for Invalid Placeholder Values in Pincode Column
SELECT pincode
FROM customers
WHERE pincode IN ('N/A', 'Unknown', '-','000000','NA');

-- Analyzing Pincode Distribution
SELECT pincode,COUNT(*) AS frequency FROM customers
GROUP BY pincode;

-- Checking for Non-Numeric Values in Phone Numbers
SELECT phone FROM customers
WHERE phone REGEXP '[^0-9]';

-- Length Validation
SELECT phone,LENGTH(phone) FROM customers
WHERE LENGTH(phone)!=10;

-- Checking for Invalid Placeholder Values in Phone Numbers
SELECT phone FROM customers
WHERE phone IN ('N/A','Unknown','-','0000000000','9999999999','1234567890');

-- Checking for Invalid Phone Number Patterns
SELECT phone FROM customers
WHERE phone NOT REGEXP '^[6-9][0-9]{9}$';

-- -- Checking for Invalid Registration Dates
SELECT registration_date
FROM customers
WHERE registration_date IN ('0000-00-00', '1900-01-01');

-- Checking for Future Registration Dates
SELECT DATE(registration_date) AS reg_date
FROM customers
WHERE DATE(registration_date)>CURDATE();

-- Validating Registration Date Format (YYYY-MM-DD)
SELECT registration_date
FROM customers
WHERE registration_date NOT REGEXP '^[0-9]{4}-[0-9]{2}-[0-9]{2}$';

-- Reviewing Registration Date Formats
SELECT registration_date
FROM customers
WHERE STR_TO_DATE(registration_date, '%Y-%m-%d') IS NULL
  AND registration_date IS NOT NULL
  AND registration_date <> '';
  
-- ====================================================================================================================================================================
-- AUDIT 2: PRODUCTS
-- ===================================================================================================================================================================

-- 2.1 NULL Check
SELECT 'products' as tbl,
  COUNT(*) AS total_rows,
  COUNT(CASE WHEN TRIM(product_id) = '' OR product_id IS NULL THEN 1 END) AS null_product_id,
  COUNT(CASE WHEN TRIM(product_name) = '' OR product_name IS NULL THEN 1 END) AS null_product_name,
  COUNT(CASE WHEN TRIM(category) = '' OR category IS NULL THEN 1 END) AS null_category,
  COUNT(CASE WHEN TRIM(sub_category) = '' OR sub_category IS NULL THEN 1 END) AS null_sub_category,
  COUNT(CASE WHEN TRIM(brand) = '' OR brand IS NULL THEN 1 END) AS null_brand,
  COUNT(CASE WHEN TRIM(price) = '' OR price IS NULL THEN 1 END) AS null_price,
  COUNT(CASE WHEN TRIM(discount_percent) = '' OR discount_percent IS NULL THEN 1 END) AS null_discount,
  COUNT(CASE WHEN TRIM(stock_quantity) = '' OR stock_quantity IS NULL THEN 1 END) AS null_stock,
  COUNT(CASE WHEN TRIM(rating) = '' OR rating IS NULL THEN 1 END) AS null_rating,
  COUNT(CASE WHEN TRIM(is_available) = '' OR is_available IS NULL THEN 1 END) AS null_is_available
FROM products;
-- Checking for Leading and Trailing Spaces in product_name Values
SELECT product_name FROM products
WHERE product_name<>TRIM(product_name);

-- Checking for case inconsistencies in product_name column
SELECT LOWER(product_name) AS normalized_product_name,COUNT(DISTINCT BINARY product_name) AS variations
FROM products
GROUP BY LOWER(product_name)
HAVING COUNT(DISTINCT BINARY product_name)>1;

-- Checking for Invalid Placeholder Values in product_name Column
SELECT product_name
FROM products
WHERE product_name IN ('N/A', 'Unknown', '-');

-- Unique Product count
SELECT COUNT(DISTINCT product_name) AS cnt FROM products
WHERE product_name IS NOT NULL AND product_name<>'';

-- Checking for Leading and Trailing Spaces in category Values
SELECT category FROM products
WHERE category<>TRIM(category);

-- Checking for case inconsistencies in category column
SELECT LOWER(category) AS normalized_category,COUNT(DISTINCT BINARY category) AS variations
FROM products
GROUP BY LOWER(category)
HAVING COUNT(DISTINCT BINARY category)>1;

-- Checking for Invalid Placeholder Values in category Column
SELECT category
FROM products
WHERE category IN ('N/A', 'Unknown', '-');

-- Unique category count
SELECT COUNT(DISTINCT category) AS cnt FROM products
WHERE category IS NOT NULL AND category<>'';

-- Checking for Leading and Trailing Spaces in sub category Values
SELECT sub_category FROM products
WHERE sub_category<>TRIM(sub_category);

-- Checking for case inconsistencies in sub category column
SELECT LOWER(sub_category) AS normalized_sub_category,COUNT(DISTINCT BINARY sub_category) AS variations
FROM products
GROUP BY LOWER(sub_category)
HAVING COUNT(DISTINCT BINARY sub_category)>1;

-- Checking for Invalid Placeholder Values in sub category Column
SELECT sub_category
FROM products
WHERE sub_category IN ('N/A', 'Unknown', '-');

-- Unique sub category count
SELECT COUNT(DISTINCT sub_category) AS cnt FROM products
WHERE sub_category IS NOT NULL AND sub_category<>'';

-- Checking for Leading and Trailing Spaces in brand Values
SELECT brand FROM products
WHERE brand<>TRIM(brand);

-- Checking for case inconsistencies in brand column
SELECT LOWER(brand) AS normalized_brand,COUNT(DISTINCT BINARY brand) AS variations
FROM products
GROUP BY LOWER(brand)
HAVING COUNT(DISTINCT BINARY brand)>1;

-- Checking for Invalid Placeholder Values in brand Column
SELECT brand
FROM products
WHERE brand IN ('N/A', 'Unknown', '-');

-- Unique brand count
SELECT COUNT(DISTINCT brand) AS cnt FROM products
WHERE brand IS NOT NULL AND brand<>'';

-- Checking for Leading and Trailing Spaces in brand Values
SELECT is_available FROM products
WHERE is_available<>TRIM(is_available);

-- Checking for case inconsistencies in is_available column
SELECT LOWER(is_available) AS normalized_is_available,COUNT(DISTINCT BINARY is_available) AS variations
FROM products
GROUP BY LOWER(is_available)
HAVING COUNT(DISTINCT BINARY is_available)>1;

-- Checking for Negative and Zero discount percent Values
SELECT CAST(discount_percent AS SIGNED) AS discount_percent FROM products
WHERE CAST(discount_percent AS SIGNED)<=0;

-- Checking for Unrealistic values
SELECT CAST(discount_percent AS SIGNED) FROM products
WHERE CAST(discount_percent AS SIGNED)>=100;

-- Analyzing discount percent Distribution
SELECT CAST(discount_percent AS SIGNED) AS discount_percent, COUNT(*) AS frequency FROM products
GROUP BY discount_percent
ORDER BY discount_percent;

-- Analyzing price discount percent
SELECT MIN(CAST(discount_percent AS SIGNED)) min_discount_percent,MAX(CAST(discount_percent AS SIGNED)) AS max_discount_percent
FROM products
WHERE discount_percent!='';

-- Checking for Negative and Zero price Values
SELECT price FROM products
WHERE price<=0 ;

-- Analyzing price Range
SELECT MIN(CAST(price AS SIGNED)) min_price,MAX(CAST(price AS SIGNED)) AS max_price
FROM products
WHERE price!='';

-- Checking for Negative and Zero stock quantity Values
SELECT stock_quantity FROM products
WHERE stock_quantity<=0 ;

-- Analyzing stock quantity Range
SELECT MIN(CAST(stock_quantity AS SIGNED)) min_stock_quantity,MAX(CAST(stock_quantity AS SIGNED)) AS max_stock_quantity
FROM products
WHERE stock_quantity!='';

-- Checking for Negative and Zero rating Values
SELECT rating FROM products
WHERE rating<=0 ;

-- Analyzing rating Range
SELECT MIN(CAST(rating AS DECIMAL(10,2))) min_rating,MAX(CAST(rating AS DECIMAL(10,2))) AS max_rating
FROM products
WHERE rating!='';

-- Analyzing rating Distribution
SELECT CAST(rating AS DECIMAL(10,2)), COUNT(*) AS frequency FROM products
GROUP BY CAST(rating AS DECIMAL(10,2))
ORDER BY CAST(rating AS DECIMAL(10,2)) DESC;


-- ====================================================================================================================================================================
-- AUDIT 3: ORDERS
-- ===================================================================================================================================================================

-- 3.1 NULL Check
SELECT 'orders' AS tbl,
  COUNT(*) AS total_rows,
  COUNT(CASE WHEN TRIM(order_id) = '' OR customer_id IS NULL THEN 1 END) AS null_order_id,
  COUNT(CASE WHEN TRIM(customer_id) = '' OR customer_id IS NULL THEN 1 END) AS null_customer_id,
  COUNT(CASE WHEN TRIM(order_date) = '' OR order_date IS NULL THEN 1 END) AS null_order_date,
  COUNT(CASE WHEN TRIM(delivery_date) = '' OR delivery_date IS NULL THEN 1 END) AS null_delivery_date,
  COUNT(CASE WHEN TRIM(status) = '' OR status IS NULL THEN 1 END) AS null_status,
  COUNT(CASE WHEN TRIM(payment_method) = '' OR payment_method IS NULL THEN 1 END) AS null_payment,
  COUNT(CASE WHEN TRIM(total_amount) = '' OR total_amount IS NULL THEN 1 END) AS null_total_amount,
  COUNT(CASE WHEN TRIM(shipping_charges) = '' OR shipping_charges IS NULL THEN 1 END) AS null_shipping,
  COUNT(CASE WHEN TRIM(discount_applied) = '' OR discount_applied IS NULL THEN 1 END) AS null_discount,
  COUNT(CASE WHEN TRIM(city) = '' OR city IS NULL THEN 1 END) AS null_city,
  COUNT(CASE WHEN TRIM(promo_code) = '' OR promo_code IS NULL THEN 1 END) AS null_promo_code
FROM orders;

-- Analyzing City Value Distribution
SELECT DISTINCT city, COUNT(*) as frequency FROM orders
GROUP BY city
ORDER BY frequency DESC;

-- Checking for case inconsistencies in city column
SELECT LOWER(city) AS normalized_city,COUNT(DISTINCT BINARY city) AS variations
FROM orders
GROUP BY LOWER(city)
HAVING COUNT(DISTINCT BINARY city)>1;

-- Checking for Leading and Trailing Spaces in City Column
SELECT city
FROM orders
WHERE city <> TRIM(city);
-- Checking Value Length in City Column 
SELECT city,LENGTH(city) AS city_length
FROM orders;

-- Checking for Numeric Values in City Column
SELECT city 
FROM orders
WHERE city REGEXP '[0-9]';

-- Checking for Invalid Placeholder Values in City Column
SELECT city
FROM orders
WHERE city IN ('N/A','NA', 'Unknown', '-');

-- Checking for Special Characters in City Column
SELECT city 
FROM orders
WHERE city REGEXP '[^A-Za-z ]';

-- Checking for Leading and Trailing Spaces in status Column
SELECT status
FROM orders
WHERE status <> TRIM(status);

-- Checking for case inconsistencies in status column
SELECT LOWER(status) AS normalized_status,COUNT(DISTINCT BINARY status) AS variations
FROM orders
GROUP BY LOWER(status)
HAVING COUNT(DISTINCT BINARY status)>1;

-- Checking for Invalid Placeholder Values in status Column
SELECT status
FROM orders
WHERE status IN ('N/A', 'Unknown','NA', '-');

-- Checking for Special Characters in status Column
SELECT status
FROM orders
WHERE status REGEXP '[^A-Za-z ]';

-- Check Status Case Inconsistencies
SELECT status COLLATE utf8mb4_bin AS case_sensitive_status, COUNT(*) as cnt
FROM orders 
GROUP BY case_sensitive_status
ORDER BY case_sensitive_status;

-- Checking for Leading and Trailing Spaces in payment_method Column
SELECT payment_method 
FROM orders
WHERE payment_method <> TRIM(payment_method );

-- Checking Value Length in payment_method Column 
SELECT DISTINCT payment_method,LENGTH(payment_method) AS payment_method_length
FROM orders;

-- Checking for case inconsistencies in payment_method column
SELECT LOWER(payment_method) AS normalized_payment_method,COUNT(DISTINCT BINARY payment_method) AS variations
FROM orders
GROUP BY LOWER(payment_method)
HAVING COUNT(DISTINCT BINARY payment_method)>1;

-- Checking for Invalid Placeholder Values in payment_method Column
SELECT payment_method
FROM orders
WHERE payment_method IN ('N/A', 'Unknown','NA', '-');

-- Checking for Special Characters in payment_method Column
SELECT payment_method
FROM orders
WHERE payment_method REGEXP '[^A-Za-z ]';

-- Check payment_method Case Inconsistencies
SELECT payment_method COLLATE utf8mb4_bin AS case_sensitive_payment_method, COUNT(*) as cnt
FROM orders 
GROUP BY case_sensitive_payment_method
ORDER BY case_sensitive_payment_method;

SELECT promo_code FROM orders;

-- Checking for Leading and Trailing Spaces in promo_code Column
SELECT promo_code 
FROM orders
WHERE promo_code <> TRIM(promo_code );

-- Checking for case inconsistencies in promo_code column
SELECT LOWER(promo_code) AS normalized_promo_code,COUNT(DISTINCT BINARY promo_code) AS variations
FROM orders
GROUP BY LOWER(promo_code)
HAVING COUNT(DISTINCT BINARY promo_code)>1;

-- Checking for Invalid Placeholder Values in promo_code Column
SELECT promo_code
FROM orders
WHERE promo_code IN ('N/A', 'Unknown','NA', '-');

-- Check promo_code Case Inconsistencies
SELECT promo_code COLLATE utf8mb4_bin AS case_sensitive_promo_code, COUNT(*) as cnt
FROM orders 
GROUP BY case_sensitive_promo_code
ORDER BY case_sensitive_promo_code;

SELECT order_date FROM orders;

-- Checking for invalid placeholder
SELECT order_date FROM orders
WHERE order_date IN ('Unknown','NA','N/A');

-- Checking for Future order Dates
SELECT DATE(order_date) AS order_date
FROM orders
WHERE DATE(order_date)>CURDATE();

-- Validating order Date Format 
SELECT 
    CASE 
        WHEN order_date REGEXP '^[0-9]{4}-[0-9]{2}-[0-9]{2}$' THEN 'YYYY-MM-DD'
        WHEN order_date REGEXP '^[0-9]{2}/[0-9]{2}/[0-9]{4}$' THEN 'DD/MM/YYYY'
        WHEN order_date REGEXP '^[0-9]{2}-[0-9]{2}-[0-9]{4}$' THEN 'DD-MM-YYYY'
        ELSE 'Other/Invalid Format'
    END AS date_format,
    COUNT(*) AS count
FROM orders
GROUP BY date_format;

SELECT delivery_date FROM orders;

-- Checking for invalid placeholder
SELECT delivery_date FROM orders
WHERE delivery_date IN ('Unknown','NA','N/A');

-- Checking for Future delivery Dates
SELECT DATE(delivery_date) AS delivery_date
FROM orders
WHERE DATE(delivery_date) > DATE_ADD(CURDATE(), INTERVAL 14 DAY);

-- Validating delivery Date Format 
SELECT 
    CASE 
        WHEN delivery_date REGEXP '^[0-9]{4}-[0-9]{2}-[0-9]{2}$' THEN 'YYYY-MM-DD'
        WHEN delivery_date REGEXP '^[0-9]{2}/[0-9]{2}/[0-9]{4}$' THEN 'DD/MM/YYYY'
        WHEN delivery_date REGEXP '^[0-9]{2}-[0-9]{2}-[0-9]{4}$' THEN 'DD-MM-YYYY'
        ELSE 'Other/Invalid Format'
    END AS date_format,
    COUNT(*) AS count
FROM orders
GROUP BY date_format;

-- Checking for Negative and Zero total amount Values
SELECT CAST(total_amount AS SIGNED) AS total_amount FROM orders
WHERE total_amount<=0;

-- Analyzing total amount Range
SELECT MIN(CAST(total_amount AS SIGNED)) min_total_amount,MAX(CAST(total_amount AS SIGNED)) AS max_total_amount
FROM orders
WHERE total_amount!='';

-- Checking for Negative and Zero shipping charges Values
SELECT CAST(shipping_charges AS SIGNED) AS shipping_charges FROM orders
WHERE shipping_charges<=0;

-- Analyzing shipping charges Range
SELECT MIN(CAST(shipping_charges AS SIGNED)) min_shipping_charges,MAX(CAST(shipping_charges AS SIGNED)) AS max_shipping_charges
FROM orders
WHERE shipping_charges!='';

-- Checking for Negative and Zero total amount Values
SELECT CAST(discount_applied AS SIGNED) AS discount_applied FROM orders
WHERE discount_applied<=0;

-- Analyzing discount applied Range
SELECT MIN(CAST(discount_applied AS SIGNED)) min_discount_applied,MAX(CAST(shipping_charges AS SIGNED)) AS max_discount_applied
FROM orders
WHERE discount_applied!='';
-- ====================================================================================================================================================================
-- AUDIT 4: ORDER_ITEMS
-- ===================================================================================================================================================================

-- 4.1 NULL Check
SELECT 'order_items' AS tbl,
  COUNT(*) AS total_rows,
  COUNT(CASE WHEN TRIM(item_id) = '' OR item_id IS NULL THEN 1 END) AS null_item_id,
  COUNT(CASE WHEN TRIM(order_id) = '' OR order_id IS NULL THEN 1 END) AS null_order_id,
  COUNT(CASE WHEN TRIM(product_id) = '' OR product_id IS NULL THEN 1 END) AS null_product_id,
  COUNT(CASE WHEN TRIM(quantity) = '' OR quantity IS NULL THEN 1 END) AS null_quantity,
  COUNT(CASE WHEN TRIM(unit_price) = '' OR unit_price IS NULL THEN 1 END) AS null_unit_price,
  COUNT(CASE WHEN TRIM(total_price) = '' OR total_price IS NULL THEN 1 END) AS null_total_price,
  COUNT(CASE WHEN TRIM(return_requested) = '' OR return_requested IS NULL THEN 1 END) AS null_return,
  COUNT(CASE WHEN TRIM(warehouse_location) = '' OR warehouse_location IS NULL THEN 1 END) AS null_warehouse
FROM order_items;

SELECT return_requested FROM order_items;

-- Checking for Leading and Trailing Spaces in return_requested Values
SELECT return_requested FROM order_items
WHERE return_requested<>TRIM(return_requested);

-- Check return_requested Case Inconsistencies
SELECT return_requested COLLATE utf8mb4_bin AS case_sensitive_return_requested, COUNT(*) as cnt
FROM order_items
GROUP BY case_sensitive_return_requested
ORDER BY case_sensitive_return_requested;

SELECT warehouse_location FROM order_items;

-- Checking for Leading and Trailing Spaces in category Values
SELECT warehouse_location FROM order_items
WHERE warehouse_location<>TRIM(warehouse_location);

-- Check return_requested Case Inconsistencies
SELECT warehouse_location COLLATE utf8mb4_bin AS case_sensitive_warehouse_location, COUNT(*) as cnt
FROM order_items
GROUP BY case_sensitive_warehouse_location
ORDER BY case_sensitive_warehouse_location;

-- Checking for invalid placeholder in warehouse_location column
SELECT warehouse_location FROM order_items
WHERE warehouse_location IN ('Unknown','NA','N/A');

-- Analyzing total_price Range
SELECT MIN(CAST(total_price AS SIGNED)) min_total_price,MAX(CAST(total_price AS SIGNED)) AS max_total_price
FROM order_items
WHERE total_price!='';

-- Checking for Negative and Zero total_price Values
SELECT total_price FROM order_items
WHERE total_price<=0 ;

SELECT unit_price FROM order_items;

-- Analyzing unit_price Range
SELECT MIN(CAST(unit_price AS SIGNED)) min_unit_price,MAX(CAST(unit_price AS SIGNED)) AS max_unit_price
FROM order_items
WHERE unit_price!='';

-- Checking for Negative and Zero unit_price Values
SELECT unit_price FROM order_items
WHERE unit_price<=0 ;

SELECT quantity FROM order_items;

-- Analyzing quantity Range
SELECT MIN(CAST(quantity AS SIGNED)) min_quantity,MAX(CAST(quantity AS SIGNED)) AS max_quantity
FROM order_items
WHERE quantity!='';

-- Checking for Negative and Zero quantity Values
SELECT quantity FROM order_items
WHERE quantity<=0 ;