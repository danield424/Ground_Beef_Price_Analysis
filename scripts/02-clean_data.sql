-- Preamble
-- Purpose: Loads the SQL dataset and saves it to CSV
-- Author: Daniel Du
-- Date: 14 November 2024
-- Contact: danielc.du@mail.utoronto.ca
-- License: MIT
-- Any other information needed? Use software like DB Browser for SQLite to clean
-- the data and export it as a .sql file.

CREATE TABLE cleaned_table AS
WITH ranked_data AS (
    -- Filter and remove redundant entries
    SELECT 
        raw.nowtime,
        product.vendor,
        product.product_name,
        product.units,
        raw.current_price,
        raw.price_per_unit,
        raw.old_price,
        raw.other,
        ROW_NUMBER() OVER (
            PARTITION BY product.vendor, product.product_name, product.units, raw.current_price, raw.price_per_unit 
            ORDER BY raw.nowtime ASC
        ) AS row_num
    FROM raw
    INNER JOIN product ON raw.product_id = product.id
    WHERE product.product_name LIKE '%ground beef%'
),
cleaned_data AS (
    -- Keep only the earliest timestamp for each unique combination
    SELECT 
        nowtime, 
        vendor, 
        product_name, 
        units, 
        current_price, 
        price_per_unit, 
        old_price, 
        other
    FROM ranked_data
    WHERE row_num = 1
),
transformed_data AS (
    -- Convert `price_per_unit` to per lb 
    SELECT 
        nowtime,
        vendor,
        product_name,
        units,
        current_price,
        old_price,
        other,
        price_per_unit,
        CASE 
            WHEN price_per_unit LIKE '%/100g%' THEN 
                CONCAT('$', ROUND(SUBSTR(price_per_unit, 2, INSTR(price_per_unit, '/') - 2) * 4.54, 2), '/lb')
            ELSE 
                price_per_unit  -- Keep original if already per lb
        END AS price_per_unit_lb,
        -- Calculate numeric value of price_per_unit_lb for filtering
        CASE 
            WHEN price_per_unit LIKE '%/100g%' THEN 
                ROUND(SUBSTR(price_per_unit, 2, INSTR(price_per_unit, '/') - 2) * 4.54, 2)
            ELSE 
                CAST(SUBSTR(price_per_unit, 2) AS DECIMAL(10, 2))
        END AS price_value
    FROM cleaned_data
)

-- Final query with filtering and sorting
SELECT 
    nowtime,
    vendor,
    product_name,
    units,
    current_price,
    price_per_unit_lb
FROM transformed_data
WHERE 
    -- Filter out entries where price_per_unit_lb is not valid
    price_value >= 1
    AND price_value <= 1000
	AND units <= 500
	AND units >= 400
	AND (
		(product_name LIKE '%ground%' AND product_name LIKE '%beef%' AND product_name LIKE '%lean%') OR
		(product_name LIKE '%ground%' AND product_name LIKE '%beef%' AND product_name LIKE '%medium%')
	)

    AND (
-- 		product_name NOT LIKE '%Extra%' AND -- filter extra lean
        product_name NOT LIKE '%Beyond Meat%' AND
		product_name NOT LIKE '%Uncooked%' AND
		product_name NOT LIKE '%Pork%' AND
		product_name NOT LIKE '%Top Grass%' AND
		product_name NOT LIKE '%Fine Grind%' AND
		product_name NOT LIKE '%Frozen%' AND
        product_name NOT LIKE '%Plant-Based%' AND
        product_name NOT LIKE '%Spices%' AND
        product_name NOT LIKE '%Patty%' AND
        product_name NOT LIKE '%Burger%' AND
        product_name NOT LIKE '%Halal%' AND
        product_name NOT LIKE '%Kosher%'
    )
ORDER BY 
    vendor ASC,         -- Sort by vendor alphabetically
    nowtime ASC;        -- Then by timestamp from earliest to latest

-- .mode csv
-- .output 'data/02-analysis_data/cleaned_data.csv'
-- SELECT * FROM cleaned_table;
-- .output stdout  -- Reset output back to standard display


