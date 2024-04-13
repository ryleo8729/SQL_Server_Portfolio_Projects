
-- 1. What is the total number of parts per theme

CREATE VIEW dbo.analytics_main AS

SELECT s.set_num AS set_name, s.name, s.year, s.theme_id, CAST(s.num_parts AS numeric) num_parts, t.name AS theme_name, t.parent_id, p.name AS parent_theme_name
FROM sets s
LEFT JOIN Rebrickable.dbo.themes t
	ON s.theme_id = t.id
LEFT JOIN Rebrickable.dbo.themes p
	ON t.parent_id = p.id

	SELECT theme_name, SUM(num_parts) as total_num_parts
	FROM analytics_main
	--WHERE parent_theme_name IS NOT NULL
	GROUP BY theme_name
	ORDER BY 2 DESC


-- 2. What are the total number of parts per year

SELECT
	year,
	SUM(num_parts) AS total_num_parts
	FROM analytics_main
	WHERE parent_theme_name IS NOT NULL
	GROUP BY year
	ORDER BY 2 DESC


-- 3. How many sets were created in each century in the dataset

ALTER VIEW analytics_main AS

SELECT s.set_num, s.name AS set_name, s.year, s.theme_id, CAST(s.num_parts AS numeric) num_parts, t.name AS theme_name, t.parent_id, p.name AS parent_theme_name,
CASE
	WHEN s.year BETWEEN 1901 AND 2000 THEN '20th_Century'
	WHEN s.year BETWEEN 2001 AND 2100 THEN '21st_Century'
	END AS Century
FROM sets s
LEFT JOIN Rebrickable.dbo.themes t
	ON s.theme_id = t.id
LEFT JOIN Rebrickable.dbo.themes p
	ON t.parent_id = p.id
GO

SELECT *
FROM analytics_main

SELECT
	Century,
	COUNT(set_num) AS total_set_num
	FROM analytics_main
	--WHERE parent_theme_name IS NOT NULL
	GROUP BY Century


-- 4. What percentage of sets released in the 21st Century were Trains Themed

;WITH cte AS
(
	SELECT 
		Century,
		theme_name,
		COUNT(set_num) total_set_num
	FROM analytics_main
	WHERE Century = '21st_Century'
	GROUP BY Century, theme_name
)

SELECT SUM(total_set_num) total_trains_sets, SUM(percentage) total_trains_sets_percentage
FROM(
	SELECT 
		Century,
		theme_name,
		total_set_num,
		SUM(total_set_num) OVER() AS total,
		CAST(1.00 * total_set_num / SUM(total_set_num) OVER() AS decimal(5,4)) * 100 Percentage
		FROM cte
		--ORDER BY 3 DESC
		)m
	WHERE theme_name LIKE '%train%'


-- 5. What was the most popular them by year in the 21st Century
SELECT year, theme_name, total_set_num
FROM(
	SELECT year, theme_name, COUNT(set_num) total_set_num, ROW_NUMBER() OVER (PARTITION BY year ORDER BY COUNT(set_num) DESC) 'row_number'
	FROM analytics_main
	WHERE Century = '21st_Century'
	GROUP BY year, theme_name
)m
WHERE row_number = 1
ORDER BY year DESC


-- 6. What is the most produced LEGO colour in terms of quantity of parts?

SELECT color_name, SUM(quantity) AS quantity_of_parts
FROM
	(
		SELECT 
			inv.color_id, inv.inventory_id, inv.part_num, CAST(inv.quantity AS numeric) quantity, inv.is_spare, c.name AS color_name, c.rgb, p.name AS part_time, p.part_material, pc.name AS category_name
		FROM inventory_parts inv
		INNER JOIN colors c
			ON inv.color_id = c.id
		INNER JOIN parts p
			ON inv.part_num = p.part_num
		INNER JOIN part_categories pc
			ON part_cat_id = pc.id
	) main

GROUP BY color_name
ORDER BY 2 DESC