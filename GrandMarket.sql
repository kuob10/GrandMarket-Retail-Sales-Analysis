-- Quieres for the GrandMarket team --

-- Sales Overtime --
WITH t2 AS(
	SELECT MONTH(date) AS month_number,
		LEFT(DATENAME(MONTH, date), 3) AS month,
		ROUND(SUM(total_price), 2) AS monthly_total
		 FROM [Sales Performance Data].[dbo].[sales]
    GROUP BY MONTH(date), LEFT(DATENAME(MONTH, date), 3)
	)
	SELECT
		month_number,
		month,
		monthly_total,
		ROUND(AVG(monthly_total) OVER(), 2) as avg_monthly
	FROM t2
	ORDER BY month_number;

-- Total number of orders --

WITH t2 AS (
	SELECT MONTH(date) AS month_number,
	LEFT(DATENAME(MONTH, date),3) AS month,
	COUNT(DISTINCT sale_id) AS total_orders
FROM [Sales Performance Data].[dbo].[sales]
GROUP BY MONTH(date),LEFT(DATENAME(MONTH, date),3)
)
SELECT month_number,
	month,
	total_orders,
	AVG(total_orders) OVER() as average_sales
FROM t2
ORDER BY month_number;

-- AOV calculation --
WITH t2 AS(
	SELECT MONTH(date) AS month_number,
		LEFT(DATENAME(MONTH, date), 3) AS month,
		ROUND(SUM(total_price) / COUNT(DISTINCT sale_id),2) AS AOV
		 FROM [Sales Performance Data].[dbo].[sales]
    GROUP BY MONTH(date), LEFT(DATENAME(MONTH, date), 3)
	)
	SELECT
		month_number,
		month,
		AOV,
		ROUND(AVG(AOV) OVER(), 2) as avg_AOV
	FROM t2
	ORDER BY month_number;

-- sales of product overtime -- 
SELECT MONTH(s.date) AS month_number,
	LEFT(DATENAME(MONTH, s.date),3) AS month,
	ROUND(SUM(total_price), 2) AS total_sales_rev,
	s.product_id,
	p.category
  FROM [Sales Performance Data].[dbo].[sales] AS s
  LEFT JOIN [Sales Performance Data].[dbo].[products] AS p ON p.product_id = s.product_id
GROUP BY MONTH(date), LEFT(DATENAME(MONTH, date),3), s.product_id, p.category
ORDER BY month_number, p.category;

-- Product AOV --

SELECT MONTH(s.date) AS month_number,
LEFT(DATENAME(MONTH, s.date), 3) AS month_name,
p.category,
ROUND(SUM(total_price) / COUNT(DISTINCT s.sale_id), 2) as prod_AOV
  FROM [Sales Performance Data].[dbo].[sales] AS s
LEFT JOIN[Sales Performance Data].[dbo].[products] AS p ON p.product_id = s.product_id
GROUP BY MONTH(date), LEFT(DATENAME(MONTH, date),3), p.category
ORDER BY month_number, p.category;

-- total sales rev per Loyalty Program -- 

SELECT c.loyalty_tier,
	MONTH(s.date) as month_number,
	LEFT(DATENAME(MONTH, s.date),3) AS month,
	ROUND(SUM(total_price),2) AS total_sales_rev 
  FROM [Sales Performance Data].[dbo].[sales] as s
  LEFT JOIN [Sales Performance Data].[dbo].[customers] AS c 
			ON s.customer_id = c.customer_id
 GROUP BY MONTH(s.date), LEFT(DATENAME(MONTH, s.date),3), c.loyalty_tier
 ORDER BY c.loyalty_tier, month_number;

-- numb of orders per loyalty --

SELECT c.loyalty_tier,
	MONTH(s.date) as month_number,
	LEFT(DATENAME(MONTH, s.date),3) AS month,
	 COUNT(DISTINCT s.sale_id) AS total_orders
	FROM [Sales Performance Data].[dbo].[sales] AS s
	LEFT JOIN [Sales Performance Data].[dbo].[customers] AS c 
			ON s.customer_id = c.customer_id
 GROUP BY MONTH(s.date), LEFT(DATENAME(MONTH, s.date),3), c.loyalty_tier
 ORDER BY c.loyalty_tier, month_number;

-- Loyalty tier AOV --

SELECT c.loyalty_tier,
	MONTH(s.date) as month_number,
	LEFT(DATENAME(MONTH, s.date),3) AS month,
	ROUND(SUM(total_price) / COUNT(DISTINCT s.sale_id),2) AS loyalty_AOV
	FROM [Sales Performance Data].[dbo].[sales] AS s
	LEFT JOIN [Sales Performance Data].[dbo].[customers] AS c 
			ON s.customer_id = c.customer_id
 GROUP BY MONTH(s.date), LEFT(DATENAME(MONTH, s.date),3), c.loyalty_tier
 ORDER BY c.loyalty_tier, month_number;

-- Region rev vs Avg region rev
WITH t2 AS (

SELECT 
	MONTH(s.date) AS month_number,
	LEFT(DATENAME(MONTH, s.date),3) AS month,
	st.region,
	ROUND(SUM(total_price),2) as reg_revenue
FROM [Sales Performance Data].[dbo].[sales] AS s
LEFT JOIN [Sales Performance Data].[dbo].[stores] AS st
	ON s.store_id = st.store_id
GROUP BY MONTH(s.date), LEFT(DATENAME(MONTH, s.date),3), st.region

)

SELECT month_number,
	month,
	region,
	ROUND(AVG(reg_revenue) OVER (PARTITION BY month_number),2) AS avg,
	reg_revenue
FROM t2
ORDER BY month_number, region

