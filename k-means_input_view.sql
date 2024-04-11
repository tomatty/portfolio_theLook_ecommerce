--k-means input view--

SELECT  user_id
       ,MAX(date) AS latest_purchase
       ,COUNT(order_id) AS frequency
       ,MAX(age) AS age
       ,MAX(gender) AS gender
       ,MAX(state) AS state
       ,MAX(country) AS country
       ,MAX(city) AS city
       ,ROUND(SUM(revenue),3) AS revenue
FROM `river-octagon-379701.portfolio_thelook_ecommerce.basic_view_sales`
GROUP BY user_id
ORDER BY frequency DESC