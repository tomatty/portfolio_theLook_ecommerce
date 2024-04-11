--product category and orders view--

--2023年度のカテゴリー別注文数を取得--
SELECT category
      ,"FY2023" AS fiscal_year
      ,COUNT(order_id) AS orders
FROM `river-octagon-379701.portfolio_thelook_ecommerce.basic_view_sales`
WHERE FORMAT_DATE("%Y",date) = "2023"
GROUP BY category

--2022年度のカテゴリー別注文数を取得し、結合--
UNION ALL
SELECT category
      ,"FY2022" AS fiscal_year
      ,COUNT(order_id) AS orders
FROM `river-octagon-379701.portfolio_thelook_ecommerce.basic_view_sales`
WHERE FORMAT_DATE("%Y",date) = "2022"
GROUP BY category

--2021年度のカテゴリー別注文数を取得し、結合--
UNION ALL
SELECT category
      ,"FY2021" AS fiscal_year
      ,COUNT(order_id) AS orders
FROM `river-octagon-379701.portfolio_thelook_ecommerce.basic_view_sales`
WHERE FORMAT_DATE("%Y",date) = "2021"
GROUP BY category

--2020年度のカテゴリー別注文数を取得し、結合--
UNION ALL
SELECT category
      ,"FY2020" AS fiscal_year
      ,COUNT(order_id) AS orders
FROM `river-octagon-379701.portfolio_thelook_ecommerce.basic_view_sales`
WHERE FORMAT_DATE("%Y",date) = "2020"
GROUP BY category

--2019年度のカテゴリー別注文数を取得し、結合--
UNION ALL
SELECT category
      ,"FY2019" AS fiscal_year
      ,COUNT(order_id) AS orders
FROM `river-octagon-379701.portfolio_thelook_ecommerce.basic_view_sales`
WHERE FORMAT_DATE("%Y",date) = "2019"
GROUP BY category

ORDER BY orders DESC