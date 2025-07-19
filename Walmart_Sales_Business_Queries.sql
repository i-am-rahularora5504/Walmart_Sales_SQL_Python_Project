-- Basic Exploration of data in mysql
use walmart_db;
select * from walmart;

select count(*) from walmart;

#Find the number of sales from different payment methods.
select 
     count(*),
     payment_method
     from walmart
	group by payment_method;
    
#Find the number of distinct Branchat which order is made.
select
     count(distinct Branch)
from walmart;

#Find the the minimum and maximum number of quantities ordered.
select min(quantity),max(quantity) from walmart;

-- Business Problems

-- 1.Find the different payment method and their number of transaction, number of quantity sold.
select 
payment_method ,
count(invoice_id) as Transactions,
Sum(quantity) as Quantity_Sold
from walmart
group by payment_method

-- 2.Find the highest rated category in each branch displaying branch, category and avg rating.


select branch,
     category,
     Rating_Average
     
from
(select branch,
     category,
     avg(rating) as Rating_Average,
     rank() over (partition by branch order by avg(rating) desc) as Ranking
from walmart
group by branch, category) as t1 where Ranking = 1;

-- 3.Find the busiest date for each branch based on number of transactions.
select branch ,
     date ,
     day,
     No_of_Transaction
from
(select branch ,
     date ,
     count(invoice_id) as No_of_Transaction,
     rank() over (partition by branch order by count(invoice_id) desc) as ranking
from walmart
group by branch, date) as t1
where ranking = 1;

-- 4.Calculate the total quantity of items sold per payment method.

select payment_method,
     sum(quantity) as Total_quantity
from walmart
group by payment_method;

-- 5.Determine the average, minimum and maximum rating of category for each city.
-- List the city, category, average_rating,minimum_rating and maximum_rating.

select city,
     category,
     avg(rating) as average_rating,
     min(rating) as minimum_rating,
     max(rating) as maximum_rating
from walmart 
group by city, category;

-- 6.Calculate the total profit for each category. 
-- list total_profit and category ordered from hghest to lowest.

select category , 
      sum(total_price * profit_margin) as total_profit
from walmart group by category
order by 2 desc;

-- 7.Display the most common payment method for each branch. 
-- list the branch and preffered_payment_method.
select branch ,
payment_method as preffered_payment_method
from
(select branch ,
payment_method,
count(*) as no_of_tranaction,
rank() over(partition by branch order by count(*) desc) as Ranking
from walmart 
group by 1,2) as t1
where Ranking =1;

With cte 
as
(select branch ,
payment_method,
count(*) as no_of_tranaction,
rank() over(partition by branch order by count(*) desc) as Ranking
from walmart 
group by 1,2)

select * from cte where 
Ranking =1;

-- 8.categorize sales into three groups MORING, AFTERNOON, EVENING
-- Find out each of the shift for different branch and their no. of invoices.

select branch ,
CASE 
           WHEN (HOUR) < 12 Then 'Morning'
           WHEN (HOUR) Between 12 and 17 Then 'Afternoon'
           Else 'Evening'
	 End as shift_of_the_day,
     count(*)
     from
     (select branch,
     time, 
     hour(time) as HOUR from walmart)
     as t1

group by 1,2
order by 1,3 desc;



     
           
 



                                    















