use sales_territory_analysis;

show tables;

SELECT COUNT(*) FROM sales_data_raw;

SELECT * FROM sales_data_raw LIMIT 10;

DROP TABLE IF EXISTS sales_data_raw;

CREATE TABLE sales_data_raw (
    ORDERNUMBER INT,
    QUANTITYORDERED INT,
    PRICEEACH DECIMAL(10,2),
    ORDERLINENUMBER INT,
    SALES DECIMAL(10,2),
    ORDERDATE VARCHAR(20),   
    STATUS VARCHAR(20),
    QTR_ID INT,
    MONTH_ID INT,
    YEAR_ID INT,
    PRODUCTLINE VARCHAR(50),
    MSRP INT,
    PRODUCTCODE VARCHAR(50),
    CUSTOMERNAME VARCHAR(100),
    PHONE VARCHAR(50),
    ADDRESSLINE1 VARCHAR(100),
    ADDRESSLINE2 VARCHAR(100),
    CITY VARCHAR(50),
    STATE VARCHAR(50),
    POSTALCODE VARCHAR(20),
    COUNTRY VARCHAR(50),
    TERRITORY VARCHAR(50),
    CONTACTLASTNAME VARCHAR(50),
    CONTACTFIRSTNAME VARCHAR(50),
    DEALSIZE VARCHAR(20)
);

SELECT COUNT(*) FROM sales_data_raw;

SELECT ORDERNUMBER, ORDERDATE, TERRITORY, SALES
FROM sales_data_raw
LIMIT 10;

ALTER TABLE sales_data_raw
ADD order_date DATE;

SET SQL_SAFE_UPDATES = 0;

UPDATE sales_data_raw
SET order_date = STR_TO_DATE(ORDERDATE, '%m/%d/%Y %H:%i');

SET SQL_SAFE_UPDATES = 1;

SELECT ORDERDATE, order_date
FROM sales_data_raw
LIMIT 10;

-- checking missing values

SELECT
    SUM(SALES IS NULL) AS missing_sales,
    SUM(TERRITORY IS NULL OR TRIM(TERRITORY) = '') AS missing_territory,
    SUM(PRODUCTLINE IS NULL OR TRIM(PRODUCTLINE) = '') AS missing_product,
    SUM(order_date IS NULL) AS missing_order_date
FROM sales_data_raw;

-- handling missing sales(sales = 0)

DELETE
FROM sales_data_raw
WHERE SALES IS NULL OR SALES = 0;

-- handling missing territory(replace with standard label)

UPDATE sales_data_raw
SET TERRITORY = 'UNKNOWN'
WHERE TERRITORY IS NULL OR TRIM(TERRITORY) = '';

-- handling missing product
UPDATE sales_data_raw
SET PRODUCTLINE = 'UNSPECIFIED'
WHERE PRODUCTLINE IS NULL OR TRIM(PRODUCTLINE) = '';

-- handling missing date
DELETE
FROM sales_data_raw
WHERE order_date IS NULL;

-- normalizing case and whitespaces
UPDATE sales_data_raw
SET TERRITORY = UPPER(TRIM(TERRITORY));

-- standardizing known variants
UPDATE sales_data_raw
SET TERRITORY = 'NORTH AMERICA'
WHERE TERRITORY IN ('NA', 'NORTH-AMERICA', 'N AMERICA');

UPDATE sales_data_raw
SET TERRITORY = 'EUROPE'
WHERE TERRITORY IN ('EU', 'EUROPE ');

-- validating territories

SELECT DISTINCT TERRITORY
FROM sales_data_raw
ORDER BY TERRITORY;

-- ideentifying duplicates
SELECT
    ORDERNUMBER,
    PRODUCTLINE,
    SALES,
    COUNT(*) AS duplicate_count
FROM sales_data_raw
GROUP BY ORDERNUMBER, PRODUCTLINE, SALES
HAVING COUNT(*) > 1;

-- adding flag column
ALTER TABLE sales_data_raw
ADD COLUMN is_duplicate TINYINT DEFAULT 0;

-- flagging duplicates using windows function
UPDATE sales_data_raw r
JOIN (
    SELECT
        id,
        ROW_NUMBER() OVER (
            PARTITION BY ORDERNUMBER, PRODUCTLINE, SALES
            ORDER BY id
        ) AS rn
    FROM sales_data_raw
) d
ON r.id = d.id
SET r.is_duplicate = CASE WHEN d.rn > 1 THEN 1 ELSE 0 END;

-- removing duplicates
DELETE FROM sales_data_raw
WHERE is_duplicate = 1;

-- creating clean tables
CREATE TABLE sales_data_clean AS
SELECT
    ORDERNUMBER AS order_id,
    order_date,
    PRODUCTLINE AS product,
    TERRITORY AS territory,
    SALES AS sales_amount,
    COUNTRY,
    DEALSIZE
FROM sales_data_raw
WHERE is_duplicate = 0;

SELECT COUNT(*) FROM sales_data_clean;

select * from sales_data_clean limit 10;

SELECT
    COUNT(DISTINCT ordernumber) AS orders,
    COUNT(DISTINCT territory) AS territories,
    MIN(order_date) AS first_order,
    MAX(order_date) AS last_order
FROM sales_data_clean;































