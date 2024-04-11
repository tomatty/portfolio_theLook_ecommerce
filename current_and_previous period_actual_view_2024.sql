--current period and previous period actual wiew-- 

WITH
--当期の実績と将来予測を月別に取得--
current_period AS(
--当期の実績を月別に取得--
SELECT  month
       ,SUM(current_revenue) AS current_revenue
       ,SUM(current_cost) AS current_cost
       ,SUM(current_profit) AS current_profit
FROM(
      SELECT month
            ,current_revenue
            ,current_cost
            ,current_profit
      FROM(
            SELECT FORMAT_DATE("%m",date) AS month
                  ,ROUND(SUM(revenue),3) AS current_revenue
                  ,ROUND(SUM(cost_of_sales),3) AS current_cost
                  ,ROUND(SUM(profit),3) AS current_profit
            FROM `river-octagon-379701.portfolio_thelook_ecommerce.basic_view_sales`
            WHERE date BETWEEN "2024-01-01" AND "2024-12-31" --当期の期間を指定
            GROUP BY month
            ORDER BY month)

--当期末までの時系列予測データを結合 予測期間:2024/04/14~2024/12/31--
UNION ALL
SELECT FORMAT_TIMESTAMP("%m",forecast_timestamp) AS month
      ,ROUND(SUM(forecast_value),3) AS current_revenue
      ,NULL AS current_cost
      ,NULL AS current_profit
FROM ML.FORECAST(MODEL portfolio_thelook_ecommerce.revenue_arima_model,STRUCT(266 AS horizon, 0.8 AS confidence_level))
WHERE FORMAT_TIMESTAMP("%Y-%m-%d",forecast_timestamp) <= "2024-12-31"
GROUP BY month)

GROUP BY month --重複月のレコードを集計
ORDER BY month),

--前期の実績を月別に取得--
previous_period AS(
SELECT FORMAT_DATE("%m",date) AS month
      ,ROUND(SUM(revenue),3) AS previous_revenue
      ,ROUND(SUM(cost_of_sales),3) AS previous_cost
      ,ROUND(SUM(profit),3) AS previous_profit
FROM `river-octagon-379701.portfolio_thelook_ecommerce.basic_view_sales`
WHERE date BETWEEN "2023-01-01" AND "2023-12-31" --前期の期間を指定
GROUP BY month
ORDER BY month),

--当期と前期の実績を結合--
join_table AS(
SELECT current_period.month
      ,current_period.current_revenue
      ,previous_period.previous_revenue
      ,current_period.current_cost
      ,previous_period.previous_cost
      ,current_period.current_profit
      ,previous_period.previous_profit
FROM current_period
INNER JOIN previous_period
ON current_period.month = previous_period.month
ORDER BY month),

--"categoryフィールド"を追加し、データを横持ちから縦持ちに変換--
conversion_table AS(
SELECT join_table.month
      ,"1_revenue" AS category
      ,join_table.current_revenue AS current_period
      ,join_table.previous_revenue AS previous_period
FROM join_table
UNION ALL
SELECT join_table.month
      ,"2_cost_of_sales" AS category
      ,join_table.current_cost AS current_period
      ,join_table.previous_cost AS previous_period
FROM join_table
UNION ALL
SELECT join_table.month
      ,"3_profit" AS category
      ,join_table.current_profit AS current_period
      ,join_table.previous_profit AS previous_period
FROM join_table
ORDER BY month)

--前年同月比計算フィールドを追加--
SELECT conversion_table.month
      ,conversion_table.category
      ,conversion_table.current_period
      ,conversion_table.previous_period
      ,ROUND((conversion_table.current_period / conversion_table.previous_period),3) AS ratio
FROM conversion_table
ORDER BY month
        ,category