--k-means output view--

SELECT * EXCEPT(NEAREST_CENTROIDS_DISTANCE)
FROM ML.PREDICT(MODEL `portfolio_thelook_ecommerce.user_attibution_clusters`,
(SELECT *
FROM `river-octagon-379701.portfolio_thelook_ecommerce.k-means_input_view`))
ORDER BY CENTROID_ID
        ,latest_purchase DESC