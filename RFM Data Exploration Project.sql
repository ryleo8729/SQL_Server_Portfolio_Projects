-- Inspecting Data
SELECT *
  FROM [PerformanceDB].[dbo].[sales_data_sample]

-- Checking Unique Values
SELECT DISTINCT STATUS
  FROM [PerformanceDB].[dbo].[sales_data_sample] -- Good to Plot
SELECT DISTINCT YEAR_ID
  FROM [PerformanceDB].[dbo].[sales_data_sample]
SELECT DISTINCT PRODUCTLINE
  FROM [PerformanceDB].[dbo].[sales_data_sample] -- Good to Plot
SELECT DISTINCT COUNTRY
  FROM [PerformanceDB].[dbo].[sales_data_sample] -- Good to Plot
SELECT DISTINCT DEALSIZE
  FROM [PerformanceDB].[dbo].[sales_data_sample] -- Good to Plot
SELECT DISTINCT TERRITORY
  FROM [PerformanceDB].[dbo].[sales_data_sample] -- Good to Plot

-- Grouping Sales by Productline
 
 SELECT PRODUCTLINE, SUM(SALES) REVENUE
 FROM [PerformanceDB].[dbo].[sales_data_sample]
 GROUP BY PRODUCTLINE
 ORDER BY 2 DESC

-- Grouping Sales by Year

SELECT YEAR_ID, SUM(SALES) REVENUE
 FROM [PerformanceDB].[dbo].[sales_data_sample]
 GROUP BY YEAR_ID
 ORDER BY 2 DESC

-- Grouping Sales by Deal Size

SELECT DEALSIZE, SUM(SALES) REVENUE
 FROM [PerformanceDB].[dbo].[sales_data_sample]
 GROUP BY DEALSIZE
 ORDER BY 2 DESC

-- Best Month of Sales in a Specific Year

SELECT MONTH_ID, SUM(SALES) REVENUE, COUNT(ORDERNUMBER) FREQUENCY
 FROM [PerformanceDB].[dbo].[sales_data_sample]
 WHERE YEAR_ID = 2004
 GROUP BY MONTH_ID
 ORDER BY 2 DESC

-- November saw highest sales in 2003 and 2004, what products are they selling?

SELECT MONTH_ID, PRODUCTLINE, SUM(SALES) REVENUE, COUNT(ORDERNUMBER) FREQUENCY
 FROM [PerformanceDB].[dbo].[sales_data_sample]
 WHERE YEAR_ID = 2004 AND MONTH_ID = 11
 GROUP BY MONTH_ID, PRODUCTLINE
 ORDER BY 4 DESC
-- Classic Cars were best selling

-- Best Customer through Recency-Frequency-Monetary (RFM) Analysis
DROP TABLE IF EXISTS #RFM;
WITH RFM AS
(
	SELECT
		CUSTOMERNAME,
		SUM(SALES) MONETARYVALUE,
		AVG(SALES) AVERAGEMONETARYVALUE,
		COUNT(ORDERNUMBER) FREQUENCY,
		MAX(ORDERDATE) LASTORDERDATE,
		(SELECT MAX(ORDERDATE) FROM [PerformanceDB].[dbo].[sales_data_sample]) MAXORDERDATE,
		DATEDIFF (DD, MAX(ORDERDATE), (SELECT MAX(ORDERDATE) FROM [PerformanceDB].[dbo].[sales_data_sample])) RECENCY
	 FROM [PerformanceDB].[dbo].[sales_data_sample]
	 GROUP BY CUSTOMERNAME
),
RFM_CALC AS
(

	SELECT R.*,
		NTILE(4) OVER (ORDER BY RECENCY DESC) RFM_RECENCY,
		NTILE(4) OVER (ORDER BY FREQUENCY) RFM_FREQUENCY,
		NTILE(4) OVER (ORDER BY MONETARYVALUE) RFM_MONETARY
	FROM RFM R

)
SELECT 
	RFMC.*, RFM_RECENCY + RFM_FREQUENCY + RFM_MONETARY RFM_CELL,
	CAST(RFM_RECENCY AS VARCHAR) + CAST(RFM_FREQUENCY AS VARCHAR) + CAST(RFM_MONETARY AS VARCHAR) RFM_CELL_STRING
INTO #RFM
FROM RFM_CALC AS RFMC

SELECT CUSTOMERNAME, RFM_RECENCY, RFM_FREQUENCY, RFM_MONETARY,
	CASE
		WHEN RFM_CELL_STRING IN (111,112,121,122,123,132,211,212,214,241) THEN 'LOST CUSTOMERS' -- Lost Customers
		WHEN RFM_CELL_STRING IN (133.134,143,244,334,343,344,144) THEN 'SLIPPING AWAY, CANNOT LOSE' -- Big spenders who haven't purchased recently
		WHEN RFM_CELL_STRING IN (311,411,331) THEN 'NEW CUSTOMERS'
		WHEN RFM_CELL_STRING IN (222,223,233,322) THEN 'POTENTIAL CHURNERS'
		WHEN RFM_CELL_STRING IN (323,333,321,422,332,432) THEN 'ACTIVE' -- Customers who buy often and recenly, but at low price points
		WHEN RFM_CELL_STRING IN (433,434,443,444) THEN 'LOYAL'
	END RFM_SEGMENT

FROM #RFM

-- What products are usually sold together?
-- Select * from [PerformanceDB].[dbo].[sales_data_sample] where ORDERNUMBER = 10411
SELECT DISTINCT ORDERNUMBER, STUFF(

	(SELECT ',' + PRODUCTCODE
	FROM [dbo].[sales_data_sample] P
	WHERE ORDERNUMBER IN
		(

			SELECT ORDERNUMBER
			FROM (
				SELECT ORDERNUMBER, COUNT(*) RN
				FROM [PerformanceDB].[dbo].[sales_data_sample]
				WHERE STATUS = 'Shipped'
				GROUP BY ORDERNUMBER
			)m
			WHERE RN = 3
		)
		AND P.ORDERNUMBER = S.ORDERNUMBER
		FOR xml path (''))
		
		, 1, 1, '') PRODUCTCODES

FROM [dbo].[sales_data_sample] S
ORDER BY 2 DESC
