select * from music_store_data.album2;
select count(*), artist_id from music_store_data.album2 group by artist_id;

# Q1: Who is the senior most employee based on job title?
select * from music_store_data.employee
order by levels desc
limit 1;

# Andrew Adams General Managerger Level = L6 age = 61 of Canada city Edmonton hired on 14/08/2016 is the senior most employee.

# Q2: Which countries have the most invoices?

select billing_country, count(*) from music_store_data.invoice
group by billing_country
order by count(*) desc
limit 1 ;

# USA isthe country with most invoices 131.

#  Q3: What are the top 3 values of total invoices?

select total from music_store_data.invoice
order by total desc
limit 3;

# Ans :-- 1. 23.759999999998     2. 19.8             3. 19.8 

### Q4: Which city has the best customer? we would like to throw a promotiona Music festival in the city we made the most money . Write a code query that 
#       returns one city that has the highest sum of invoices totals. Return bot city names and sum of all invoices totals.alter

select billing_city , sum(total) from music_store_data.invoice
group by 1
order by sum(total) desc
limit 1;

# ans:-- City = Prague and Total_Sales = 273.2400000000007.

# Q5: Who is the best customer? The customer who has spent the most money will be declared as the best customer. Write a query that retruns the person who has spent the most money.

select c.customer_id, c.first_name, c.last_name, sum(i.total) as total_spent from customer as c
join invoice as i
on 
c.customer_id = i.customer_id
group by c.customer_id , c.first_name, c.last_name
order by total_spent desc
limit 5 ;

# Ans cust_id = 5 name = Frantiaiek Wichterlovai is the best customer with total spent of 144.54

# Q6 : write a query to return email , first_name ,last_name and genre of all Rock Music lsteners.Return your list ordered alphabetically by email starting with A 

select distinct c.email , c.first_name , c.last_name, g.name 
from customer c
join invoice i 
on i.customer_id = c.customer_id
join invoice_line il
on  il.invoice_id = i.invoice_id 
join track t 
on t.track_id = il.track_id
join genre g 
on g.genre_id = t.genre_id
where g.name like 'Rock'
order by c.email asc;

# Q7. Let's invite the artists who have written the mock rock music in our dataSet. Write a query that returns the Artist Name And total Track Count of the top 10 rock bands ? 

select a.artist_id, a.name,count(a.artist_id) as total from track t
join album2 ab  
on ab.album_id = t.track_id
join artist a 
on a.artist_id = ab.artist_id
join genre g
on t.genre_id = g.genre_id
where g.name like 'Rock'
group by a.artist_id, a.name
order by total desc 
limit 10;

# Q8. Return all the track name that have song length longer than the avg song length return the names and miliseconds for each track ordered by the song length with the longest songs listened first
select t.track_id, t.name , t.milliseconds from track t 
where t.milliseconds > (select avg(milliseconds) as avg_time from track) 
order by t.milliseconds desc;

# Q9. Find How much amount spent by each customer on artist? Write a query to return customer name, artist name, total spent
select c.customer_id, c.first_name,c.last_name , a.name , sum(il.quantity * il.unit_price) as total_spent from customer c
join invoice i 
on c.customer_id = i.customer_id
join invoice_line il
on i.invoice_id = il.invoice_id
join track t 
on il.track_id = t.track_id
join album2 ab
on t.album_id = ab.album_id
join artist a 
on ab.artist_id = a.artist_id
group by c.customer_id, c.first_name, c.last_name , a.name 
order by total_spent desc;

/* Q10: We want to find out the most popular music Genre for each country. We determine the most popular genre as the genre 
with the highest amount of purchases. Write a query that returns each country along with the top Genre. For countries where 
the maximum number of purchases is shared return all Genres. */
with new as(
select i.billing_country, g.name , count(il.quantity) as total,
row_number() over (partition by i.billing_country order by count(il.quantity) desc ) as row_num from genre g 
join track t 
on t.genre_id = g.genre_id
join invoice_line il 
on il.track_id = t.track_id 
join invoice i 
on i.invoice_id = il.invoice_id
group by 1,2
order by 1 asc, 3 desc 
)
select * from new where row_num <= 1;

/* Q11: Write a query that determines the customer that has spent the most on music for each country. 
Write a query that returns the country along with the top customer and how much they spent. 
For countries where the top amount spent is shared, provide all customers who spent this amount. */

WITH Customter_with_country AS (
		SELECT customer.customer_id,first_name,last_name,billing_country,SUM(total) AS total_spending,
	    ROW_NUMBER() OVER(PARTITION BY billing_country ORDER BY SUM(total) DESC) AS RowNo 
		FROM invoice
		JOIN customer ON customer.customer_id = invoice.customer_id
		GROUP BY 1,2,3,4
		ORDER BY 4 ASC,5 DESC)
SELECT * FROM Customter_with_country WHERE RowNo <= 1

