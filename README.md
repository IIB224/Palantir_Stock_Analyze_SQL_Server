# Palantir_Stock_Analyze_SQL_Server
# Hi, This is the project done by SQL to show some insight for the Palantir
Data is from the Yearly Report of Palantir. Revenue scale is millions

Step 1 . CHECK THE DATASET
(https://github.com/IIB224/Palantir_Stock_Analyze_SQL_Server/issues/1#issue-2432244966)

Step 2 . CORRECT THE TYPO (exec sp_rename)
(https://github.com/IIB224/Palantir_Stock_Analyze_SQL_Server/issues/2#issue-2432246314)

Step 3 . LOOKING AT TOTAL REVENUE VS US REVENUE 
(JOIN, ON, WHERE, ORDER BY)
(https://github.com/IIB224/Palantir_Stock_Analyze_SQL_Server/issues/3#issue-2432247677)

Step 4 . LOOKING AT TOTAL REVENUE VS NON US REVENUE
(CTE, ROUND)
(https://github.com/IIB224/Palantir_Stock_Analyze_SQL_Server/issues/4#issue-2432248689)

Step 5 . LOOKING AT QUARTER WITH HIGHEST US_REVENUE RATIO WITH THE TOTAL REVENUE
(CTE, MAX)
(https://github.com/IIB224/Palantir_Stock_Analyze_SQL_Server/issues/5#issue-2432249617)

Step 6 . BREAK DOWN THE REVENUE BY YEAR
(SUM, GROUP BY, ORDER BY DESC)
(https://github.com/IIB224/Palantir_Stock_Analyze_SQL_Server/issues/6#issue-2432250221)

Step 7 . CREATE A VIEW  + USE CTE FOR QUATERLY QoQ %
(CREATE VIEW, DATEPART, CTE, CASE, LAG, OVER(ORDER BY))
(https://github.com/IIB224/Palantir_Stock_Analyze_SQL_Server/issues/7#issue-2432250876)

Step 8 . CREATE A VIEW  + USE CTE FOR QUATERLY YoY %
(CREATE VIEW, DATEPART, CTE, CASE, LAG, OVER(PARTITION BY))
(https://github.com/IIB224/Palantir_Stock_Analyze_SQL_Server/issues/8#issue-2432251243)

Step 9 . TEMP TABLE
(DROP TABLE, CREATE TABLE, INSERT INTO, JOIN 2 VIEWS)
(https://github.com/IIB224/Palantir_Stock_Analyze_SQL_Server/issues/9#issue-2432252401)

--In conclusion:
60 percent of the revenue comes from the US, and more than half of the revenue comes from government sources. As a personal investor, I would like to see more revenue generated from outside the US and less dependence on government sources.





