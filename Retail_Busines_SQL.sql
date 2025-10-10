select *
from Sales_Data

SELECT TOP 10 * FROM Sales_Data;

SELECT COUNT(*) AS TotalRows FROM Sales_Data;

SELECT
    SUM(CASE WHEN Ship_Mode IS NULL OR Ship_Mode = '' THEN 1 ELSE 0 END) AS Null_ShipMode,
    SUM(CASE WHEN Segment IS NULL OR Segment = '' THEN 1 ELSE 0 END) AS Null_Segment,
    SUM(CASE WHEN City IS NULL OR City = '' THEN 1 ELSE 0 END) AS Null_City,
    SUM(CASE WHEN State IS NULL OR State = '' THEN 1 ELSE 0 END) AS Null_State,
    SUM(CASE WHEN Sales IS NULL THEN 1 ELSE 0 END) AS Null_Sales,
    SUM(CASE WHEN Profit IS NULL THEN 1 ELSE 0 END) AS Null_Profit
FROM Sales_Data;

DELETE FROM Sales_Data
WHERE City IS NULL OR City = ''
   OR State IS NULL OR State = ''
   OR Sales IS NULL OR Profit IS NULL;

UPDATE Sales_Data
SET 
    Ship_Mode = LTRIM(RTRIM(Ship_Mode)),
    Segment = LTRIM(RTRIM(Segment)),
    City = LTRIM(RTRIM(City)),
    State = LTRIM(RTRIM(State)),
    Region = LTRIM(RTRIM(Region)),
    Category = LTRIM(RTRIM(Category)),
    Sub_Category = LTRIM(RTRIM(Sub_Category));

ALTER TABLE Sales_Data ALTER COLUMN Sales FLOAT;
ALTER TABLE Sales_Data ALTER COLUMN Profit FLOAT;
ALTER TABLE Sales_Data ALTER COLUMN Discount FLOAT;
ALTER TABLE Sales_Data ALTER COLUMN Quantity INT;

ALTER TABLE Sales_Data ADD ProfitMargin FLOAT;

UPDATE Sales_Data
SET ProfitMargin = 
    CASE WHEN Sales <> 0 THEN ROUND((Profit / Sales) * 100, 2)
         ELSE NULL END;

SELECT * FROM Sales_Data
WHERE Sales < 0 OR Profit < -1000;

SELECT
    COUNT(*) AS TotalRows,
    SUM(Sales) AS TotalSales,
    SUM(Profit) AS TotalProfit,
    ROUND(AVG(ProfitMargin),2) AS AvgProfitMargin
FROM Sales_Data;

SELECT * INTO Sales_Data_Cleaned FROM Sales_Data;

/*Overall Sales, Profit, and Profit Margin*/
SELECT 
    SUM(Sales) AS TotalSales,
    SUM(Profit) AS TotalProfit,
    ROUND(SUM(Profit)/SUM(Sales)*100, 2) AS ProfitMarginPercent
FROM Sales_Data;

/* Category vs Sub-Category Performance*/
SELECT 
    Category,
    Sub_Category,
    SUM(Sales) AS TotalSales,
    SUM(Profit) AS TotalProfit,
    ROUND(SUM(Profit)/SUM(Sales)*100, 2) AS ProfitMargin
FROM Sales_Data
GROUP BY Category, Sub_Category
ORDER BY TotalSales DESC;

--Region and State Analysis
SELECT 
    Region,
    State,
    SUM(Sales) AS TotalSales,
    SUM(Profit) AS TotalProfit,
    ROUND(SUM(Profit)/SUM(Sales)*100, 2) AS ProfitMargin
FROM Sales_Data
GROUP BY Region, State
ORDER BY TotalSales DESC;

--Segment-wise Sales & Profit
SELECT 
    Segment,
    SUM(Sales) AS TotalSales,
    SUM(Profit) AS TotalProfit,
    ROUND(SUM(Profit)/SUM(Sales)*100, 2) AS ProfitMargin
FROM Sales_Data
GROUP BY Segment
ORDER BY TotalSales DESC;

--Ship Mode Performance
SELECT 
    Ship_Mode,
    COUNT(*) AS TotalOrders,
    SUM(Sales) AS TotalSales,
    SUM(Profit) AS TotalProfit,
    ROUND(SUM(Profit)/SUM(Sales)*100, 2) AS ProfitMargin
FROM Sales_Data
GROUP BY Ship_Mode
ORDER BY TotalProfit DESC;

--Discount Impact on Profit
SELECT 
    Category,
    ROUND(AVG(Discount)*100, 2) AS AvgDiscountPercent,
    ROUND(SUM(Profit)/SUM(Sales)*100, 2) AS ProfitMargin
FROM Sales_Data
GROUP BY Category
ORDER BY AvgDiscountPercent DESC;

--Top 10 Cities by Sales
SELECT TOP 10 
    City,
    State,
    SUM(Sales) AS TotalSales,
    SUM(Profit) AS TotalProfit
FROM Sales_Data
GROUP BY City, State
ORDER BY TotalSales DESC;

--Loss-Making Sub-Categories
SELECT 
    Sub_Category,
    SUM(Sales) AS TotalSales,
    SUM(Profit) AS TotalProfit,
    ROUND(SUM(Profit)/SUM(Sales)*100, 2) AS ProfitMargin
FROM Sales_Data
GROUP BY Sub_Category
HAVING SUM(Profit) < 0
ORDER BY ProfitMargin ASC;

--Quantity Sold vs Profit Correlation
SELECT 
    Sub_Category,
    SUM(Quantity) AS TotalQuantity,
    SUM(Profit) AS TotalProfit
FROM Sales_Data
GROUP BY Sub_Category
ORDER BY TotalQuantity DESC;

--Region-wise Profit Margin Ranking
SELECT 
    Region,
    SUM(Sales) AS TotalSales,
    SUM(Profit) AS TotalProfit,
    ROUND(SUM(Profit)/SUM(Sales)*100, 2) AS ProfitMargin
FROM Sales_Data
GROUP BY Region
ORDER BY ProfitMargin DESC;
--Coorelation of discount with profit
SELECT 
    ROUND(AVG(Discount)*100,2) AS AvgDiscountPercent,
    ROUND(AVG(ProfitMargin),2) AS AvgProfitMargin
FROM Sales_Data;

