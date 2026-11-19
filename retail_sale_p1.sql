-- DATA ANALYSIS AND BUSINESS KEY PROBLEMS

-- 1. **Write a SQL query to retrieve all columns for sales made on '2022-11-05**:
SELECT * FROM retail_sales
WHERE sale_date = '2022-11-05';

-- alter column
alter table retail_sales
rename column quantiy to quantity;

-- 2. **Write a SQL query to retrieve all transactions where the category is 'Clothing' and the quantity sold is more than 3 in the month of Nov-2022**:
SELECT sale_date, category, quantity
from retail_sales
where category = 'Clothing' and quantity >= 3 and TO_CHAR(sale_date, 'yyyy-mm')= '2022-11';

-- 3. **Write a SQL query to calculate the total sales (total_sale) for each category.
select category, sum(total_sale) as total_sales
from retail_sales
group by category;

-- 4. **Write a SQL query to find the average age of customers who purchased items from the 'Beauty' category.**:
select ROUND(avg(age),2) as avg_age
from retail_sales
where category = 'Beauty';

-- 5. **Write a SQL query to find all transactions where the total_sale is greater than 1000.**:
select * from retail_sales
where total_sale > 1000;

-- 6. **Write a SQL query to find the total number of transactions (transaction_id) made by each gender in each category.**:
select category, gender, count(*) as total_transaction
from retail_sales
group by category, gender;

-- 7. **Write a SQL query to calculate the average sale for each month. Find out best selling month in each year**:

select 
	year,
	month,
	avg_sales
from
	(
		select 
			extract(YEAR from sale_date) as year,
			extract(MONTH from sale_date) as month,
			avg(total_sale) as avg_sales,
			rank() over(partition by extract(YEAR from sale_date) order by avg(total_sale) desc) as rank
		from retail_sales
		group by 1,2
	) as t1
where rank = 1;

-- 8. **Write a SQL query to find the top 5 customers based on the highest total sales **:
select customer_id, sum(total_sale) as total_sales
from retail_sales
group by customer_id
order by total_sales desc
limit 5;

-- 9. **Write a SQL query to find the number of unique customers who purchased items from each category.**:
select count(distinct customer_id), category
from retail_sales
group by category;

-- 10. **Write a SQL query to create each shift and number of orders (Example Morning <12, Afternoon Between 12 & 17, Evening >17)**:
WITH hourly_sale
AS
(select *,
	case
		WHEN EXTRACT(HOUR from sale_time) > 12 THEN 'Morning'
		WHEN EXTRACT(HOUR from sale_time) between 12 and 17 THEN 'Afternoon'
		ELSE 'Evening'
	END as shift
FROM retail_sales
)
select shift,
	count(*) as total_orders
from hourly_sale
group by shift;