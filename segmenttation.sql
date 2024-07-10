/*Bước 1: Tính giá trị R-F-M*/
SELECT *from customer;
SELECT *from sales;
SELECT *from segment_score;

WITH customer_rfm as 
(SELECT 
a.customer_id,
current_date-MAX(order_date) as R,
COUNT(order_id) as F,
sum(sales) as M
FROM customer a 
JOIN sales b 
on a.customer_id=b.customer_id
GROUP BY a.customer_id)

/*Bước 2: Chia theo thang điểm từ 1 - 5*/
,rfm_score as (SELECT 
customer_id,
Ntile(5) OVER(ORDER BY R DESC) AS R_score,
Ntile(5) OVER(ORDER BY F) AS F_score,
Ntile(5) OVER(ORDER BY M) AS M_score
FROM customer_rfm)

/*Buoc 3: Phân nhóm khách hàng bằng RFM*/
, rfm_final as(
SELECT customer_id, 
cast(R_score as varchar)|| cast(F_score as varchar)|| cast(M_Score as varchar) AS rfm_score
FROM rfm_score)

SELECT segment, COUNT(*) FROM (
SELECT 
a.customer_id, b.segment FROM rfm_final a
JOIN segment_score b ON a.rfm_score=b.scores) a
GROUP BY segment
ORDER BY COUNT(*)

/*Buoc 4*: Trực quan phân tích RFM*/
--vẽ bằng excel
