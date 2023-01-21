-- Query 1 :Create a database called house_price_regression.
CREATE DATABASE house_price_regression;

USE house_price_regression;

DROP TABLE IF EXISTS house_price_data;

-- Query 2:
CREATE TABLE house_price_data(id smallint unsigned NOT NULL,
							tradeDate CHAR(10),
                            bedrooms smallint(5),
                            bathrooms smallint(5),
                            sqft_living mediumint(10),
                            sqft_lot mediumint(10),
                            floors smallint(5),
                            waterfront smallint(5),
                            house_view mediumint(10),
                            house_condition smallint(5),
                            grade smallint(5),
                            sqft_above mediumint(10),
                            sqft_basement mediumint(10),
                            yr_built smallint(5),
                            yr_renovated smallint(5),
                            zipcode mediumint(10),
                            lat double,
                            longi double,
                            sqft_living15 mediumint(10),
                            sqft_lot15 mediumint(10),
                            price mediumint(10),
PRIMARY KEY (`id`)
);

-- Query 4:
-- Select all the data from table house_price_data 
-- to check if the data was imported correctly
SELECT * FROM house_price_data;

-- Query 5:
-- Use the alter table command to drop the column date from the database, 
-- as we would not use it in the analysis with SQL. Select all the data from the table 
-- to verify if the command worked. Limit your returned results to 10.
ALTER TABLE house_price_data
DROP COLUMN date;

SELECT * FROM house_price_data
LIMIT 10;

-- Query 6:
-- Use sql query to find how many rows of data you have.
SELECT COUNT(*) FROM house_price_data;

-- Query 7:
-- What are the unique values in the column bedrooms?
-- What are the unique values in the column bathrooms?
-- What are the unique values in the column floors?
-- What are the unique values in the column condition?
-- What are the unique values in the column grade?
SELECT DISTINCT bedrooms, bathrooms, floors, condition_, grade FROM house_price_data;

-- Query 8:
-- Arrange the data in a decreasing order by the price of the house. 
-- Return only the IDs of the top 10 most expensive houses in your data.
SELECT id, price FROM house_price_data
ORDER BY price desc
LIMIT 10;

-- Query 9:
-- What is the average price of all the properties in your data?
SELECT AVG(Price) house_price_data;

-- Query 10.1:
-- What is the average price of the houses grouped by bedrooms? 
-- The returned result should have only two columns, bedrooms and Average of the
-- prices. Use an alias to change the name of the second column.
SELECT bedrooms, COUNT(bedrooms) as numberofBedrooms, AVG(price) as averagePrice  FROM house_price_data
GROUP BY bedrooms
Order by bedrooms;


-- Query 10.2: What is the average sqft_living of the houses grouped by bedrooms? 
-- The returned result should have only two columns, bedrooms and Average of the sqft_living. 
-- Use an alias to change the name of the second column.
SELECT bedrooms, AVG(sqft_living) as averagesqft_living FROM house_price_data
GROUP BY bedrooms
ORDER BY bedrooms;

-- Query 10.3: What is the average price of the houses with a waterfront and without a waterfront?
-- The returned result should have only two columns, waterfront and Average of the prices. 
-- Use an alias to change the name of the second column.
SELECT waterfront, AVG(price) as averagePrice FROM house_price_data
GROUP BY waterfront;

-- Query 10.4: Is there any correlation between the columns condition and grade? 
-- You can analyse this by grouping the data by one of the variables and then aggregating 
-- the results of the other column. Visually check if there is a positive correlation or negative correlation 
-- or no correlation between the variables.
SELECT condition_, AVg(grade) from house_price_data
group by condition_
order by condition_;
 
 
 -- Query 11: 
 SELECT id, bedrooms, bathrooms, floors, waterfront, condition_, grade, price FROM house_price_data
 WHERE (bedrooms = 3 or bedrooms = 4)
		and bathrooms >= 3.00
        and floors = 1
        and waterfront = 0
        and condition_ >= 3
        and grade >= 5
        and price < 300000;
        

-- Query 12:  whose prices are twice more than the average of all the properties in the database. 
-- Write a query to show them the list of such properties. 
-- You might need to use a sub query for this problem.

SELECT AVg(price) from house_price_data;  -- avg(price) = 540296.5735

SELECT 2*AVg(price) as doupleAvg from house_price_data; -- doupleAvg = 1080593.1470

SELECT id, price FROM house_price_data
WHERE price >
       (SELECT 2*(AVG(price)) as doupleAvgPrice
       FROM house_price_data
)
order by price;


-- Query 13: create a view of the same query(Query12).
with cte_house_price_data as (
	SELECT * FROM house_price_data)
SELECT * FROM house_price_data
	WHERE price >
       (SELECT 2*(AVG(price)) as doupleAvgPrice
       FROM house_price_data)
order by price;

-- Query 14: Most customers are interested in properties with three or four bedrooms.
-- What is the difference in average prices of the properties with three and four bedrooms?
SELECT bedrooms, Avg(price) as AveragePrice, 
	(Avg(price)-lag(avg(price),1)over()) as difference
    FROM house_price_data
GROUP BY bedrooms
having bedrooms = 3 or bedrooms = 4
order by AveragePrice;
;

-- Query 15:
-- What are the different locations where properties are available in your database? (distinct zip codes)
SELECT distinct zipcode FROM house_price_data
order by zipcode;

-- Query 16: Show the list of all the properties that were renovated.
SELECT * FROM house_price_data
Where yr_renovated > 0
order by yr_renovated;

-- Query 17: Provide the details of the property that is the 11th most expensive property in your database.
SELECT * FROM house_price_data
ORDER BY price desc
LIMIT 11;

--  Query 17- Method 2:
SELECT * FROM (
  SELECT *,
    ROW_NUMBER() OVER (ORDER BY price DESC) AS rownumber
  FROM house_price_data
) AS foo
WHERE rownumber = 11