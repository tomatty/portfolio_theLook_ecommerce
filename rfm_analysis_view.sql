--RFM Analysis view--

WITH
--basic_viewをuser_idでグルーピングし、Recency,Frequency,Monetaryフィールドを追加--
base_table AS(
SELECT order_id
      ,MAX(age) AS age
      ,MAX(gender) AS gender
      ,MAX(country) AS country
      ,MAX(date) AS Recency
      ,COUNT(order_id) AS Frequency
      ,SUM(revenue) AS Monetary
FROM `river-octagon-379701.portfolio_thelook_ecommerce.basic_view_sales`
GROUP BY order_id),

--Recencyの新しい順に,Frequencyの多い順に,Monetaryの多い順に、それぞれ５段階のランキングフィールドを追加--
rank_table AS(
SELECT order_id
      ,base_table.age
      ,base_table.gender
      ,base_table.country
      ,Recency
      ,Frequency
      ,Monetary
      ,NTILE(5) OVER(ORDER BY base_table.Recency DESC) AS Recency_rank
      ,NTILE(5) OVER(ORDER BY base_table.Frequency DESC) AS Frequency_rank
      ,NTILE(5) OVER(ORDER BY base_table.Monetary DESC) AS Monetary_rank
FROM base_table)

--各ランキングの総和をRFM_rankフィールドとして追加--
SELECT order_id
      ,age
      ,gender
      ,country
      ,Recency_rank + Frequency_rank + Monetary_rank AS RFM_rank
      ,Recency_rank
      ,Frequency_rank
      ,Monetary_rank
      ,Recency
      ,Frequency
      ,Monetary
FROM rank_table
ORDER BY RFM_rank ASC