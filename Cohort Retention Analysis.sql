;WITH online_retail AS
(
	SELECT [InvoiceNo]
		  ,[StockCode]
		  ,[Description]
		  ,[Quantity]
		  ,[InvoiceDate]
		  ,[UnitPrice]
		  ,[CustomerID]
		  ,[Country]
	  FROM [CRADB].[dbo].[online_retail]
	  WHERE CustomerID IS NOT NULL

  )
  , quantity_unit_price AS
  (
  -- 397,884 Records with positive quantity and unit price
  SELECT *
  FROM online_retail
  WHERE Quantity > 0 AND UnitPrice > 0
  )
  , dup_check AS
  (
	  -- Check for duplicates
	  SELECT *, ROW_NUMBER() OVER (PARTITION BY InvoiceNo, StockCode, Quantity ORDER BY InvoiceDate) dup_flag
	  FROM quantity_unit_price

  )
  -- 392669 distinct entries
  -- 5215 duplicate records
  --
  SELECT *
  INTO #online_retail_main
  FROM dup_check
  WHERE dup_flag = 1


  -- Clean Data
  -- Begin Cohort Analysis
  SELECT *
  FROM #online_retail_main

  -- Unique Identifier is CustomerID
  -- Initial Start Date (First Invoice Date)
  -- Revenue Data

  SELECT
	CustomerID,
	MIN(InvoiceDate) first_purchase_date,
	DATEFROMPARTS(year(MIN(InvoiceDate)), month(MIN(InvoiceDate)), 1) Cohort_Date
INTO #cohort
FROM #online_retail_main
GROUP BY CustomerID
	
SELECT *
FROM #cohort 

-- Create Cohort Index
SELECT
	mmm.*,
	cohort_index = year_diff * 12 + month_diff + 1
	INTO #cohort_retention
	FROM 
		(
		SELECT
			mm.*,
			year_diff = invoice_year - cohort_year,
			month_diff = invoice_month - cohort_month
		FROM 
			(
			SELECT 
				m.*,
				c.Cohort_Date,
				year(m.InvoiceDate) invoice_year,
				month(m.invoiceDate) invoice_month,
				year(c.Cohort_Date) cohort_year,
				month(c.Cohort_Date) cohort_month
			FROM #online_retail_main m
			LEFT JOIN #cohort c
				ON m.CustomerID = c.CustomerID
			) mm
		)mmm
--WHERE CustomerID = 14733

-- Pivot Data to see the cohort table
SELECT *
INTO #cohort_pivot
FROM(
	SELECT 
		DISTINCT CustomerID,
		Cohort_Date,
		cohort_index
	FROM #cohort_retention
)tb1
pivot(
	COUNT(CustomerID)
	FOR Cohort_Index In
			(
		[1],
		[2],
		[3],
		[4],
		[5],
		[6],
		[7],
		[8],
		[9],
		[10],
		[11],
		[12],
		[13])

) AS pivot_table
ORDER BY Cohort_Date

SELECT Cohort_Date,
	1.0*[1]/[1] * 100 AS [1], 
	1.0*[2]/[1] * 100 AS [2],
	1.0*[3]/[1] * 100 AS [3],
	1.0*[4]/[1] * 100 AS [4],
	1.0*[5]/[1] * 100 AS [5],
	1.0*[6]/[1] * 100 AS [6],
	1.0*[7]/[1] * 100 AS [7],
	1.0*[8]/[1] * 100 AS [8],
	1.0*[9]/[1] * 100 AS [9],
	1.0*[10]/[1] * 100 AS [10],
	1.0*[11]/[1] * 100 AS [11],
	1.0*[12]/[1] * 100 AS [12],
	1.0*[13]/[1] * 100 AS [13]
FROM #cohort_pivot
ORDER BY Cohort_Date
