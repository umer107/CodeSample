SELECT
 prod_subcategory_desc AS category,
 calendar_month_desc AS month,
 amount_sold AS sales,
 SUM(amount_sold) OVER (ORDER BY calendar_month_id) AS cum_sales
FROM PRODCAT_MONTHLY_SALES
WHERE prod_subcategory_desc ='Cameras'
AND calendar_year_id >='1803';

-----------------------------------------------------------------------------------
SELECT
 pms1.prod_subcategory_desc AS subcategory,
 pms1.calendar_month_desc AS month,
 pms1.amount_sold AS sales,
 (SELECT 
   SUM(amount_sold)
  FROM PRODCAT_MONTHLY_SALES pms2
  WHERE calendar_year_id ='1803'
  AND prod_subcategory_desc ='Cameras'
  AND pms2.calendar_month_id <= pms1.calendar_month_id) AS cum_sales
FROM PRODCAT_MONTHLY_SALES pms1
WHERE prod_subcategory_desc ='Cameras'
AND calendar_year_id ='1803'
ORDER BY pms1.calendar_month_id;
-----------------------------------------------------------------------------------
SELECT
 pms1.prod_subcategory_desc AS subcategory,
 pms1.calendar_quarter_desc AS quarter, 
 pms1.calendar_month_desc AS month,
 pms1.amount_sold AS sales,
 pms2.tot_qtr_sales
FROM PRODCAT_MONTHLY_SALES pms1,
(SELECT
  calendar_quarter_id,
  SUM(amount_sold) as tot_qtr_sales
FROM PRODCAT_MONTHLY_SALES
WHERE prod_subcategory_desc ='Cameras'
AND calendar_year_id ='1803'
GROUP BY calendar_quarter_id) pms2
WHERE pms1.prod_subcategory_desc ='Cameras'
AND pms1.calendar_year_id ='1803'
AND pms2.calendar_quarter_id = pms1.calendar_quarter_id
ORDER BY pms1.calendar_quarter_id, pms1.calendar_month_id;
--------------------------------------------------------------------------------------
SELECT
  channel_class AS channel,
  prod_subcategory_desc,
  SUM(amount_sold) AS sales,
  RANK () OVER (PARTITION BY channel_class ORDER BY SUM(amount_sold) DESC) as s_rank
FROM chan_prodcat_monthly_sales
GROUP BY channel_class, prod_subcategory_desc;
--------------------------------------------------------------------------------------
SELECT
  channel_class AS channel,
  prod_subcategory_desc,
  TRUNC(amount_sold,0) AS sales,  
  RANK() OVER (PARTITION BY channel_class ORDER BY amount_sold DESC) as s_rank,
  DENSE_RANK() OVER (PARTITION BY channel_class ORDER BY amount_sold DESC) as d_rank,
  TRUNC(CUME_DIST() OVER (PARTITION BY channel_class ORDER BY amount_sold DESC),2) as c_dist,
  TRUNC(PERCENT_RANK() OVER (PARTITION BY channel_class ORDER BY amount_sold DESC),2) as p_rank
FROM duplicate_rank_rows;
--------------------------------------------------------------------------------------
SELECT * FROM
(SELECT
  prod_subcategory_desc AS subcategory,
  calendar_month_desc as months,
  amount_sold as sales,   
  LAG(amount_sold, 12) OVER (ORDER BY calendar_month_id) AS Lyr_sales,
  TRUNC(amount_sold - LAG(amount_sold, 12) OVER (ORDER BY calendar_month_id,0)) AS sales_var,
  TRUNC(((amount_sold - LAG(amount_sold, 12) OVER (ORDER BY calendar_month_id))/LAG(amount_sold, 12) OVER (ORDER BY calendar_month_id))*100 , 0) AS var_pct
FROM prodcat_monthly_sales
WHERE prod_subcategory_desc = 'Cameras')
WHERE var_pct < -50;
--------------------------------------------------------------------------------------
select
       prod_category_desc,
       min(prod_list_price)                                           "Min.", 
       percentile_cont(0.25) within group (order by prod_list_price)  "1st Qu.", 
       trunc(median(prod_list_price),2)                               "Median", 
       trunc(avg(prod_list_price),2)                                  "Mean", 
       percentile_cont(0.75) within group (order by prod_list_price)  "3rd Qu.", 
       max(prod_list_price)                                           "Max.", 
       count(*) - count(prod_list_price)                              "NA's"
from products
GROUP BY prod_category_desc; 
--------------------------------------------------------------------------------------
SELECT 
    SUBSTR(cust_income_level, 1, 22) income_level, 
    TRUNC(AVG(DECODE(cust_gender, 'M', amount_sold, null)),2) sold_to_men, 
    TRUNC(AVG(DECODE(cust_gender, 'F', amount_sold, null)),2) sold_to_women, 
    TRUNC(STATS_T_TEST_INDEPU(cust_gender, amount_sold, 'STATISTIC', 'F'),4) t_observed, 
    TRUNC(STATS_T_TEST_INDEPU(cust_gender, amount_sold),4) two_sided_p_value 
FROM sh.customers c, sh.sales s 
WHERE c.cust_id = s.cust_id 
GROUP BY ROLLUP(cust_income_level) 
ORDER BY income_level; 

