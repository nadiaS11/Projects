-- For all customer records --

SELECT * FROM customers;

-- total number of customers --

SELECT count(*) FROM customers;


-- Show transactions for for a specific market (Market code 'Mark006' is for'Bengaluru')--

SELECT * FROM transactions where market_code='Mark006';

-- Products that were sold in Bengaluru only  --

SELECT distinct product_code FROM transactions where market_code='Mark006';

-- To check all the different types of currency in the dataset -- 
SELECT distinct currency from transactions 

-- Determining the number of records in each currency --

SELECT  COUNT(*) currency from transactions  where currency='INR'; --  the answer is 279 --
SELECT COUNT(*) currency from transactions  where currency='INR\r' ;--  the answer is150000 --
SELECT COUNT(*) currency from transactions  where currency='USD'; --  the answer is 2 --
SELECT COUNT(*) currency from transactions  where currency='USD\r'; --  the answer is 2 --

-- transactions where currency in USD --

SELECT * from transactions where currency="USD\r" ;

--  transactions in 2019 join by date table --

SELECT transactions.*, date.* FROM transactions INNER JOIN date ON transactions.order_date=date.date where date.year=2019;

-- Total revenue in year 2019 --

SELECT SUM(transactions.sales_amount)  as revenue
FROM transactions 
INNER JOIN date  as d
ON transactions.order_date = d.date 
where d.year=2019 and transactions.currency='INR\r' or transactions.currency='USD\r'  ; --  the answer is 33601952 --

 
--  total revenue in year 201, January Month --

SELECT SUM(t.sales_amount) as revenue
FROM transactions as t
INNER JOIN date as d
ON t.order_date=d.date 
where (t.currency= 'INR\r' or t.currency= 'USD\r') and d.year= 2019 and d.month_name= 'January'; -- the answer is 31530566 --

-- Show total revenue in year 2020 in Chennai --
SELECT SUM(t.sales_amount) as revenue
FROM transactions as t
INNER JOIN date as d
ON t.order_date=d.date 
where t.market_code='Mark001' and  d.year=2020; -- the answer is 2463024 --

-- Top 5 customer-

SELECT c.custmer_name, sum(t.sales_amount) as revenue
 FROM customers as c
 Inner join transactions as t
 on c.customer_code=t.customer_code
 where t.currency="INR\r" or t.currency='USD\r'
 group by custmer_name
 order  by revenue desc  
 Limit 5; 
 



 /* 
 ----- Data Analysis Using Power BI to create a column to convrt the currency from USD to INR -----
 
= Table.AddColumn(#"ConvertedCurrency", "norm_amount", each if [currency] = "USD" or [currency] ="USD#(cr)" then [sales_amount]*75 else [sales_amount], type any)
 /*
 
 
 
 
 
