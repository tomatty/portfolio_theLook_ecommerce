--time series prediction input view "revenue"-- 
SELECT date
      ,SUM(revenue) AS sum_revenue
      ,SUM(profit) AS sum_profit
FROM `river-octagon-379701.portfolio_thelook_ecommerce.basic_view_sales`
GROUP BY date
ORDER BY date