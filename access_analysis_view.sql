--Access Analysis view--

SELECT traffic_source
      ,state
      ,COUNT(DISTINCT ip_address) AS UU
      ,COUNT(DISTINCT CONCAT(session_id,sequence_number)) AS session
      ,SUM(IF(event_type = "purchase",1,0)) AS CV
      ,ROUND(SUM(IF(event_type = "purchase",1,0)) / COUNT(DISTINCT CONCAT(session_id,sequence_number)),3) AS CVR
FROM `bigquery-public-data.thelook_ecommerce.events`
WHERE FORMAT_TIMESTAMP("%Y-%m-%d",created_at) BETWEEN "2024-03-01" AND "2024-03-31"
GROUP BY traffic_source
        ,state