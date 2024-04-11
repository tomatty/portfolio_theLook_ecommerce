--history_of_number_of_users_view--

--年度ごとのユーザー数を取得--
WITH 
master AS(

--2023年度のユーザー数を取得--
SELECT "FY2023" AS fiscal_year
      ,COUNT(DISTINCT user_id) AS users
FROM `river-octagon-379701.portfolio_thelook_ecommerce.basic_view_sales`
WHERE FORMAT_DATE("%Y",date) = "2023"
GROUP BY fiscal_year

--2022年度のユーザー数を取得し、結合--
UNION ALL
SELECT "FY2022" AS fiscal_year
      ,COUNT(DISTINCT user_id) AS users
FROM `river-octagon-379701.portfolio_thelook_ecommerce.basic_view_sales`
WHERE FORMAT_DATE("%Y",date) = "2022"
GROUP BY fiscal_year

--2021年度のユーザー数を取得し、結合--
UNION ALL
SELECT "FY2021" AS fiscal_year
      ,COUNT(DISTINCT user_id) AS users
FROM `river-octagon-379701.portfolio_thelook_ecommerce.basic_view_sales`
WHERE FORMAT_DATE("%Y",date) = "2021"
GROUP BY fiscal_year

--2020年度のユーザー数を取得し、結合--
UNION ALL
SELECT "FY2020" AS fiscal_year
      ,COUNT(DISTINCT user_id) AS users
FROM `river-octagon-379701.portfolio_thelook_ecommerce.basic_view_sales`
WHERE FORMAT_DATE("%Y",date) = "2020"
GROUP BY fiscal_year

--2019年度のユーザー数を取得し、結合--
UNION ALL
SELECT "FY2019" AS fiscal_year
      ,COUNT(DISTINCT user_id) AS users
FROM `river-octagon-379701.portfolio_thelook_ecommerce.basic_view_sales`
WHERE FORMAT_DATE("%Y",date) = "2019"
GROUP BY fiscal_year

ORDER BY fiscal_year)

--前年度からの成長率を計算するフィールドを追加--
SELECT *
      ,ROUND(users / LAG(users) OVER(ORDER BY fiscal_year),3) AS growth_rate
FROM master
ORDER BY fiscal_year