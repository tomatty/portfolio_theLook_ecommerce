--product abc analysis view--

WITH
--product_id別にグルーピングし、売上高を集計--
base_table AS(
SELECT product_id
      ,MAX(category) AS category
      ,MAX(name) AS name
      ,SUM(revenue) AS revenue_by_product
FROM `river-octagon-379701.portfolio_thelook_ecommerce.basic_view_sales`
WHERE date BETWEEN "2023-04-01" AND "2024-3-31"
GROUP BY product_id),

--売上高の高い順に商品を10個のグループに分割するフィールド、全体の売上高フィールドを追加--
ntile_table AS(
SELECT product_id
      ,category
      ,name
      ,revenue_by_product
      ,NTILE(10) OVER(ORDER BY revenue_by_product DESC) AS NTILE
      ,SUM(revenue_by_product) OVER() AS total_revenue
FROM base_table),

--10個のグループごとの総売上高フィールドを追加--
ntile_revenue_table AS(
SELECT NTILE
      ,product_id
      ,category
      ,name
      ,revenue_by_product
      ,SUM(revenue_by_product) OVER(PARTITION BY NTILE ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING) AS revenue_by_NTILE
      ,total_revenue
FROM ntile_table)

--総売上高に対する各グループの売上高比を計算するフィールドを追加--
SELECT NTILE
      ,product_id
      ,category
      ,name
      ,revenue_by_product
      ,revenue_by_NTILE
      ,total_revenue
      ,ROUND(revenue_by_NTILE / total_revenue,3) AS percentage --売上高比フィールド
FROM ntile_revenue_table
ORDER BY NTILE