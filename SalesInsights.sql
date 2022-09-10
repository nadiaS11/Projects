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
SELECT  COUNT(*) currency from transactions  where currency="INR" ;
SELECT COUNT(*) currency from transactions  where currency="INR\r" ;
 SELECT COUNT(*) currency from transactions  where currency="USD" ;
 SELECT COUNT(*) currency from transactions  where currency="USD\r";

-- transactions where currency in USD --

SELECT * from transactions where currency="USD\r" ;

--  transactions in 2019 join by date table --

SELECT transactions.*, date.* FROM transactions INNER JOIN date ON transactions.order_date=date.date where date.year=2019;

-- Total revenue in year 2019 --

SELECT SUM(transactions.sales_amount)  as revenue
FROM transactions 
INNER JOIN date  as d
ON transactions.order_date = d.date 
where d.year=2019 and transactions.currency="INR\r" or transactions.currency="USD\r"  ;

 
--  total revenue in year 201, January Month --

SELECT SUM(transactions.sales_amount) 
FROM transactions INNER JOIN date 
ON transactions.order_date=date.date 
where date.year= 2019 and and date.month_name= 'January' and (transactions.currency= 'INR\r' or transactions.currency= 'USD\r');

-- Show total revenue in year 2020 in Chennai --

-SELECT SUM(transactions.sales_amount) 
FROM transactions 
INNER JOIN date 
ON transactions.order_date=date.date 
where date.year=2020 and transactions.market_code="Mark001";

-- Top 5 customer-

SELECT c.custmer_name, sum(t.sales_amount) as revenue
 FROM customers as c
 Inner join transactions as t
 on c.customer_code=t.customer_code
 where transactions.currency="INR\r" or transactions.currency="USD\r"
 group by custmer_name
 order  by revenue desc  
 Limit 5;
 

 /* 
 ----- Data Analysis Using Power BI to create a column to convrt the currency from USD to INR -----
 
= Table.AddColumn(#"ConvertedCurrency", "norm_amount", each if [currency] = "USD" or [currency] ="USD#(cr)" then [sales_amount]*75 else [sales_amount], type any)
 /*
 
 
 
 
 