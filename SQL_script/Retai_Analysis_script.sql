use retail_analysis;
select * from customer_profiles;
select * from product_inventory;
select * from sales_transaction;
set sql_safe_updates = 0;

--- data discrepancies was found in the sales_transaction table price column so we needed to update the sales_transaction price column.
		update sales_transaction as s join product_inventory as p on s.ProductID = p.ProductID 
		set s.price = p.price where s.price  !=  p.price; --- we have found out that 20 price rows have been changed.
--- date column in sales transaction is text and not in a standard format of YYYY-mm-dd 
		alter table sales_transaction add column TransDate date;
        update sales_transaction set TransDate = str_to_date(transactiondate,'%d/%m/%Y');
        alter table sales_transaction drop column transactiondate;
--- ***DATA ANALYSIS***.

--- (((Sales & Revenue Performance Analysis)))

	--- What is the total revenue, total quantity sold, and total number of transactions for the company?
	
				select round(sum(quantitypurchased * price),2) as total_revenue,
				sum(quantitypurchased) as totalquantitysold,
                sum(transactionid) as total_transaction
				from sales_transaction;
	
    --- How has revenue changed month-over-month?
				
                with changes as(select date_format(transdate,'%Y-%m') as Months , 
                sum(quantitypurchased* price) as total_revenue from sales_transaction group by Months),
                new as (select Months , total_revenue, lag(total_revenue) over() as previous_month_revenue from changes)
                select Months , total_revenue, previous_month_revenue ,
                round(((total_revenue-previous_month_revenue)/previous_month_revenue)*100,2)  as percentage_change from new;
	
    --- Which month generated the highest and lowest revenue?
	
				with lowest as (select date_format(transdate,'%Y-%m') as Months,
                sum(quantitypurchased * price)  as total_revenue from sales_transaction group by Months)
                select Months , total_revenue from lowest
                where total_revenue = (select max(total_revenue) from lowest) or
                total_revenue = (select min(total_revenue) from lowest);

--- (((Product Performance Analysis)))

	--- What are the top 10 products by total revenue?
				
                select P.PRODUCTNAME AS PRODUCTNAME ,  round(sum(S.QUANTITYPURCHASED * S.PRICE ),2) AS TOTAL_REVENUE FROM
                SALES_TRANSACTION S JOIN PRODUCT_INVENTORY AS P ON P.PRODUCTID=S.PRODUCTID
                GROUP BY p.PRODUCTNAME ORDER BY TOTAL_REVENUE DESC LIMIT 10;
	
    --- What are the bottom 10 products by units sold (excluding products with zero sales)?
				
                select P.PRODUCTNAME AS PRODUCTNAME ,  sum(S.QUANTITYPURCHASED) AS TOTAL_QUANTITY 
                FROM
                SALES_TRANSACTION S JOIN PRODUCT_INVENTORY AS P ON P.PRODUCTID=S.PRODUCTID
                GROUP BY p.PRODUCTNAME HAVING SUM(S.QUANTITYPURCHASED) > 0
                ORDER BY TOTAL_QUANTITY ASC LIMIT 10;
	
    --- Which product categories generate the highest revenue?
				
                select P.CATEGORY AS PRODUCT_CATEGOY ,  round(sum(S.QUANTITYPURCHASED * S.PRICE ),2) AS TOTAL_REVENUE FROM
                SALES_TRANSACTION S JOIN PRODUCT_INVENTORY AS P ON P.PRODUCTID=S.PRODUCTID
                GROUP BY p.CATEGORY ORDER BY TOTAL_REVENUE DESC;
				
	--- Which products have never been sold?
				
                SELECT  P.PRODUCTNAME AS PRODUCT , SUM(S.QUANTITYPURCHASED) AS TOTAL_QUANTITY
                FROM PRODUCT_INVENTORY AS P left JOIN SALES_TRANSACTION S ON P.PRODUCTID=S.PRODUCTID
                GROUP BY P.PRODUCTNAME HAVING SUM(S.QUANTITYPURCHASED) = 0 ;
                
	--- Which products have high sales volume but low stock levels?
				WITH PRODUCT_STOCK AS 
                (SELECT  P.PRODUCTNAME AS PRODUCT , SUM(S.QUANTITYPURCHASED) AS TOTAL_QUANTITY_SOLD, (P.STOCKLEVEL) TOTAL_STOCK
                FROM SALES_TRANSACTION S JOIN PRODUCT_INVENTORY AS P ON P.PRODUCTID=S.PRODUCTID
                GROUP BY P.PRODUCTNAME,P.STOCKLEVEL)
                SELECT * FROM PRODUCT_STOCK WHERE TOTAL_STOCK < 50 ORDER BY TOTAL_STOCK ASC,TOTAL_QUANTITY_SOLD DESC;

--- (((Customer Purchasing Behavior Analysis)))

	--- How many transactions has each customer made?
				
                SELECT customerID , count(*) as Number_of_transaction 
                from sales_transaction group by customerid order by count(*) desc;
	
    --- Who are the top 10 customers by total spending?
				SELECT customerID , round(sum(quantitypurchased * price),2) as Total_Revenue 
                from sales_transaction
                group by customerid order by total_revenue desc limit 10;
	--- Who are the customers with the lowest purchasing activity?
				
                SELECT customerID , round(sum(quantitypurchased * price),2) as Total_Revenue 
                from sales_transaction
                group by customerid order by total_revenue asc limit 10;
	
    --- What is the Average Order Value (AOV)?
				
                select customerid, 
                round(sum(quantitypurchased * price)/count(distinct transactionid),2) as customer_average_order_value 
                from sales_transaction 
                group by customerid 
                order by customer_average_order_value desc;

--- (((Customer Loyalty & Retention)))
	--- What percentage of customers are repeat customers?
				with repeat_customer as (select distinct customerid  as distinct_customer, count(customerid) as times_bought
                from sales_transaction
                group by customerid 
                having times_bought > 1),
                one_time as (select distinct customerid , count(customerid) as times_bought
                from sales_transaction
                group by customerid 
                having times_bought =1)
                select round(( count(distinct_customer) / (select count(customerid) from customer_profiles) * 100 ),2) as percentage_of_repeat_customer
                from repeat_customer ;
				
	--- What is the duration between the first and last purchase for each customer?
				with transaction_duration as (select distinct customerid as customer_id ,
                min(transdate) as first_purchase_date,
                max(transdate) as last_transaction_date
                from sales_transaction group by customerid),
				segment as (select customer_id , datediff(last_transaction_date ,first_purchase_date) as duration
                from transaction_duration order by duration asc)
                select customer_id , 
                case 
					when  duration = 0 then 'one time customer'
                    when  duration between 1 and 30 then 'short-term-customer' 
                    when duration between 31 and 180 then 'moderately-engaged-customer'
                    when duration > 180 then 'long-term-customer'
                    end as customer_segment
                    from segment group by customer_id;
	--- customers who are registeded but never bought any product.
				select c.customerid , s.* from customer_profiles c 
                left join sales_transaction s 
                on c.customerid = s.customerid where s.customerid is null  ;
				
--- (((Customer Segmentation)))
	--- Segment customers based on total quantity purchased and count customers in each segment?
				with segment as (select c.customerid  as customer_id, s.quantitypurchased as quantity
                
                from customer_profiles c 
                left join sales_transaction s 
                on c.customerid = s.customerid ),
                customer_segment as (select customer_id , 
                case 
					when sum(quantity) is null then 'No Order'
                    when sum(quantity) between 1 and 10 then 'Low'
                    when sum(quantity) between 11 and 30 then 'Medium'
                    when sum(quantity) > 30 then 'High'
                    
                end as customer_segment from segment  
                group by customer_id )
                select customer_segment , 
                count(*) as total_count 
                from customer_segment group by customer_segment order by total_count asc;
                

