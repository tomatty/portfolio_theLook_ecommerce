--NTILE Analysis view--

SELECT NTILE
      ,ROUND(SUM(revenue),3) AS sum_rev
      ,ROUND(SUM(revenue) / MAX(total_revenue),3) AS percentage
FROM(
      SELECT *
            ,NTILE(10) OVER(ORDER BY revenue DESC) AS NTILE
            ,SUM(revenue) OVER() AS total_revenue
      FROM(
            SELECT user_id
                  ,MAX(age) AS age
                  ,MAX(gender) AS gender
                  ,MAX(state) AS state
                  ,MAX(country) AS country
                  ,MAX(city) AS city
                  ,ROUND(SUM(revenue),3) AS revenue
            FROM `river-octagon-379701.portfolio_thelook_ecommerce.basic_view_sales`
            WHERE date BETWEEN "2023-04-01" AND "2024-03-31"
            GROUP BY user_id))
GROUP BY NTILE
ORDER BY NTILE