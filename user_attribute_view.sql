--user attribute view--

SELECT *
      ,CASE
        WHEN age BETWEEN 10 AND 19 THEN "10代"
        WHEN age BETWEEN 20 AND 29 THEN "20代"
        WHEN age BETWEEN 30 AND 39 THEN "30代"
        WHEN age BETWEEN 40 AND 49 THEN "40代"
        WHEN age BETWEEN 50 AND 59 THEN "50代"
        WHEN age BETWEEN 60 AND 69 THEN "60代"
        WHEN age BETWEEN 70 AND 79 THEN "70代"
        WHEN age BETWEEN 80 AND 89 THEN "80代"
        WHEN age BETWEEN 90 AND 99 THEN "90代"
        ELSE "その他"
        END generation
      ,NTILE(10) OVER(ORDER BY revenue DESC) AS NTILE
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
      GROUP BY user_id)