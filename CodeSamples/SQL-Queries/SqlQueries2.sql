SELECT
 calendar_quarter_desc AS qtr,
 prod_category_desc AS category,
 SUM(CASE WHEN channel_class='Direct' THEN amount_sold ELSE NULL END) AS "Direct",
 SUM(CASE WHEN channel_class='Direct' THEN amount_sold ELSE NULL END) AS "Indirect",
 SUM(CASE WHEN channel_class='Direct' THEN amount_sold ELSE NULL END) AS "Others"  
FROM chan_prodcat_monthly_sales
WHERE calendar_year_id = '1803'
GROUP BY calendar_quarter_desc, prod_category_desc
ORDER BY calendar_quarter_desc, prod_category_desc;
---------------------------------------------------------------------------------------
SELECT *
FROM
(SELECT
 calendar_quarter_desc AS qtr,
 prod_category_desc AS category,
 channel_class AS channel,
 sum(amount_sold) AS sales
FROM chan_prodcat_monthly_sales
WHERE calendar_year_id = '1803'
GROUP BY calendar_quarter_desc, prod_category_desc, channel_class)
PIVOT(sum(sales) FOR (qtr, channel) 
                 IN (('1999-01', 'Direct'),
                    ('1999-02', 'Direct'),
                    ('1999-03', 'Direct'),
                    ('1999-04', 'Direct'),
                    ('1999-01', 'Indirect'),
                    ('1999-02', 'Indirect'),                   
                    ('1999-03', 'Indirect'),
                    ('1999-04', 'Indirect')))
ORDER BY category;
----------------------------------------------------------------------------------------
