USE sakila;
-- Step 1: Create a View
-- First, create a view that summarizes rental information for each customer. 
-- The view should include the customer's ID, name, email address, and total number of rentals (rental_count).

CREATE VIEW rental_info AS
SELECT c.customer_id, c.first_name, c.last_name, c.email, COUNT(rental_id) AS 'rental_count'
FROM customer As c
JOIN rental AS r
ON c.customer_id = r.customer_id
GROUP BY c.customer_id;


-- Step 2: Create a Temporary Table
-- Next, create a Temporary Table that calculates the total amount paid by each customer (total_paid). 
-- The Temporary Table should use the rental summary view created in Step 1 to join with the payment table
--  and calculate the total amount paid by each customer.

CREATE TEMPORARY TABLE temp_rental_info AS
SELECT r_info.customer_id, r_info.first_name, r_info.last_name, r_info.email, r_info.rental_count, sum(p.amount) AS 'total_paid' 
FROM rental_info As r_info
JOIN payment As p
ON r_info.customer_id = p.customer_id
GROUP BY r_info.customer_id;


-- Step 3: Create a CTE and the Customer Summary Report
-- Create a CTE that joins the rental summary View with the customer payment summary Temporary Table created in Step 2. 
-- The CTE should include the customer's name, email address, rental count, and total amount paid.
-- Next, using the CTE, create the query to generate the final customer summary report, 
-- which should include: customer name, email, rental_count, total_paid and average_payment_per_rental, 
-- this last column is a derived column from total_paid and rental_count.


WITH customer_summary_report AS 
(SELECT r_info.customer_id, r_info.first_name, r_info.last_name, r_info.email, r_info.rental_count, sum(p.amount) AS 'total_paid' 
FROM rental_info As r_info
JOIN payment As p
ON r_info.customer_id = p.customer_id
GROUP BY r_info.customer_id
)
SELECT *, ROUND(total_paid/rental_count, 2) AS 'average_payment_per_rental' FROM  customer_summary_report; 






