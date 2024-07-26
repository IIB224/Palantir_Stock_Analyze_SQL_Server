------CHECK THE DATASET
--SELECT *
--FROM US_Revenue$
--ORDER BY 1,2

--SELECT *
--FROM Palantir$
--ORDER BY 1,2



------CORRECT THE TYPO
--EXEC sp_rename 'dbo.US_Revenue$.[US Comercial Revenue]', 'US Commercial Revenue', 'COLUMN'

------LOOKING AT TOTAL REVENUE VS US REVENUE 
--SELECT p.Date, p.Time,p.Revenue_Million AS Total_Revenue, u.Total_Revenue AS US_Revenue, (u.Total_Revenue/p.Revenue_Million)*100 as US_revenue_ratio
--FROM Palantir$ p
--JOIN US_Revenue$ u
--ON p.Date = u.Date and p.Time = u.Time
--WHERE p.Time LIKE '%2024%' (if you want to narrow down to certain period)
--ORDER BY 1,2

------LOOKING AT TOTAL REVENUE VS NON US REVENUE
--WITH Non_US_Revenue_Calculation AS(
--SELECT p.Date, p.Time,p.Revenue_Million AS Total_Revenue, p.Revenue_Million - u.Total_Revenue as Non_US_revenue
--FROM Palantir$ p 
--JOIN US_Revenue$ u
--ON p.Date = u.Date and p.Time = u.Time
--),
--Non_US_Revenue_Ratio AS(
--SELECT Time, Date, Round((Non_US_revenue/Total_Revenue)*100, 2) AS Non_US_Ratio 
--FROM Non_US_Revenue_Calculation
--)
--SELECT nuc.Date, nuc.Time, nuc.Total_Revenue, nuc.Non_US_revenue, nur.Non_US_Ratio
--FROM Non_US_Revenue_Calculation nuc 
--JOIN Non_US_Revenue_Ratio nur
--ON nuc.Date = nur.Date AND nuc.Time = nur.Time
--ORDER BY 1,2

------LOOKING AT QUARTER WITH HIGHEST US_REVENUE RATIO WITH THE TOTAL REVENUE
--WITH Revenue_Calculations AS (
--    SELECT p.Date, p.Time, p.[Revenue_Million] AS Total_Revenue, u.Total_Revenue AS US_Revenue, Round((u.Total_Revenue / p.[Revenue_Million]) * 100, 2) AS US_Revenue_Ratio
--FROM Palantir$ p
--JOIN US_Revenue$ u
--ON p.Date = u.Date AND p.Time = u.Time
--),
--Max_US_Revenue_Ratio AS (
--SELECT MAX(US_Revenue_Ratio) AS Max_Ratio
--FROM Revenue_Calculations
--)
--SELECT rc.Date, rc.Time, rc.Total_Revenue, rc.US_Revenue, rc. US_Revenue_Ratio
--FROM Revenue_Calculations rc
--JOIN Max_US_Revenue_Ratio mrr
--ON rc.US_Revenue_Ratio = mrr.Max_Ratio
--ORDER BY rc.Date, rc.Time

------BREAK DOWN THE REVENUE BY YEAR
--SELECT YEAR(p.Date) AS Year, SUM(P.Revenue_Million) AS Yearly_Revenue
--FROM Palantir$ p	
--JOIN US_Revenue$ u
--ON p.Date = u.Date and p.Time = u.Time
--GROUP BY YEAR(p.Date)
--ORDER BY YEAR(p.Date) DESC

------CREATE A VIEW  + USE CTE FOR QUATERLY QoQ %
--CREATE VIEW dbo.QuarterlyRevenueQoQ AS
--WITH Quarterly_Revenue AS(
--SELECT YEAR(Date) AS Year, DATEPART(QUARTER,Date) AS Quarter, SUM(Revenue_Million) AS Total_Revenue
--FROM Palantir$
--GROUP BY YEAR(Date), DATEPART(QUARTER,Date)
--),
--QoQ AS(
--SELECT Year, Quarter , Total_Revenue, LAG(Total_Revenue) OVER(ORDER BY Year, Quarter) AS Previous_Quarter_Revenue,
--CASE 
--WHEN Total_Revenue  IS NULL THEN NULL
--ELSE ROUND((Total_Revenue - LAG(Total_Revenue) OVER(ORDER BY Year, Quarter)) / LAG(Total_Revenue) OVER(ORDER BY Year, Quarter) *100, 2)
--END AS "QoQ%"
--FROM Quarterly_Revenue
--)

--SELECT * FROM dbo.QuarterlyRevenueQoQ

------CREATE A VIEW  + USE CTE FOR QUATERLY YoY %
--CREATE VIEW dbo.QuarterlyRevenueYoY AS
--WITH Quarterly_Revenue AS(
--SELECT YEAR(Date) AS Year, DATEPART(QUARTER,Date) AS Quarter, SUM(Revenue_Million) AS Total_Revenue
--FROM Palantir$
--GROUP BY YEAR(Date), DATEPART(QUARTER,Date)
--),
--YoY AS(
--SELECT Year, Quarter , Total_Revenue, LAG(Total_Revenue) OVER(PARTITION BY Quarter ORDER BY Year) AS Previous_Quarter_Revenue,
--CASE 
--WHEN Total_Revenue  IS NULL THEN NULL
--ELSE ROUND((Total_Revenue - LAG(Total_Revenue) OVER(PARTITION BY Quarter ORDER BY Year)) / LAG(Total_Revenue) OVER(PARTITION BY Quarter ORDER BY Year) *100, 2)
--END AS "YoY%"
--FROM Quarterly_Revenue
--)

--SELECT * FROM dbo.QuarterlyRevenueYoY
--ORDER BY Year, Quarter 


------TEMP TABLE
--DROP TABLE IF EXISTS #TEMPPalantir_Revenue 
--CREATE TABLE #TEMPPalantir_Revenue(
--Date NVARCHAR(255), 
--Time NVARCHAR(255),
--"Revenue Million" Numeric,
--"Commercial_Revenue" Numeric,
--"Government_Revenue" Numeric,
--"US_Commercial_Revenue" Numeric,
--"US_Government_Revenue" Numeric,
--"Total_Revenue" Numeric,
--)
--INSERT INTO #TEMPPalantir_Revenue
--SELECT p.Date, p.Time, p.Revenue_Million, p.[Commercial Revenue], p.[Government Revenue], 
--       u.[US Commercial Revenue], u.[US Government Revenue], u.Total_Revenue
--FROM Palantir$ p
--JOIN US_Revenue$ u
--ON p.Date = u.Date
--AND p.Time = u.Time
--ORDER BY p.Date, p.Time
--SELECT * FROM #TEMPPalantir_Revenue 

--SELECT #TEMPPalantir_Revenue.*, YoY.[YoY%], QoQ.[QoQ%]
--FROM #TEMPPalantir_Revenue 
--JOIN dbo.QuarterlyRevenueQoQ QoQ
--ON #TEMPPalantir_Revenue.[Revenue Million]  = QoQ.Total_Revenue
--JOIN dbo.QuarterlyRevenueYoY YoY
--ON #TEMPPalantir_Revenue.[Revenue Million] = YoY.Total_Revenue
--ORDER BY #TEMPPalantir_Revenue.Date
