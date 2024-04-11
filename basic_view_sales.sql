--basic_view_sales--

SELECT PARSE_DATE("%Y-%m-%d",FORMAT_TIMESTAMP("%Y-%m-%d",order_items.created_at)) AS date
      ,order_items.id AS order_items_id
      ,order_items.order_id
      ,order_items.user_id
      ,users.age
      ,users.gender
      ,users.state
      ,users.country
      ,users.city
      ,users.traffic_source
      ,order_items.product_id
      ,products.category
      ,products.name
      ,products.brand
      ,products.distribution_center_id
      ,ROUND(products.cost,3) AS unit_cost
      ,ROUND(products.retail_price,3) AS retail_price
      ,orders.num_of_item
      ,ROUND(products.cost * orders.num_of_item,3) AS cost_of_sales
      ,ROUND(order_items.sale_price * orders.num_of_item,3) AS revenue
      ,ROUND((order_items.sale_price * orders.num_of_item) - (products.cost * orders.num_of_item),3) AS profit

FROM `bigquery-public-data.thelook_ecommerce.order_items` AS order_items
LEFT OUTER JOIN `bigquery-public-data.thelook_ecommerce.users` AS users
ON order_items.user_id = users.id
LEFT OUTER JOIN `bigquery-public-data.thelook_ecommerce.products` AS products
ON order_items.product_id = products.id
LEFT OUTER JOIN `bigquery-public-data.thelook_ecommerce.orders` AS orders
ON order_items.order_id = orders.order_id