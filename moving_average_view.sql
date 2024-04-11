--moving average view　"n=5"-- 

WITH
master AS(
SELECT FORMAT_DATE("%Y-%m",date) AS year_month
      ,ROUND(SUM(revenue),3) AS sum_revenue
      ,ROUND(SUM(profit),3) AS sum_profit
FROM `river-octagon-379701.portfolio_thelook_ecommerce.basic_view_sales`
GROUP BY year_month
ORDER BY year_month)

SELECT PARSE_DATE("%Y-%m",year_month) AS year_month
      ,sum_revenue
      ,AVG(sum_revenue) OVER(ORDER BY year_month ROWS BETWEEN 2 PRECEDING AND 2 FOLLOWING) AS five_ma_rev --5項移動平均
      ,sum_profit
      ,AVG(sum_profit) OVER(ORDER BY year_month ROWS BETWEEN 2 PRECEDING AND 2 FOLLOWING) AS five_ma_profit --5項移動平均
FROM master
ORDER BY year_month