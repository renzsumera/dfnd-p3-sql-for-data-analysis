### (EASY) Question 1
/*
Which genres have the most number of tracks?
*/
SELECT g.Name, COUNT(t.TrackId)
FROM Genre g
JOIN Track t
ON g.GenreId = t.GenreId
GROUP BY 1
ORDER BY 2 DESC;

### (MEDIUM) Question 2
/*
Which rock albums have earned the most?
*/
SELECT al.Title Album, ar.Name Artist, SUM(il.UnitPrice*il.Quantity) AmountSpent
FROM Artist ar
JOIN Album al
ON ar.ArtistId = al.ArtistId
JOIN Track t
ON al.AlbumId = t.AlbumId
JOIN InvoiceLine il
ON t.TrackID = il.TrackId
JOIN Genre g
ON t.GenreID = g.GenreId
WHERE g.Name = 'Rock'
GROUP BY 1, 2
ORDER BY 3 DESC
LIMIT 10;

### (DIFFICULT) Question 3
/*
What is the distribution of track lengths for rock albums?
*/
SELECT al.Title Album, ar.Name Artist, SUM(t.milliseconds/1000/60) Minutes,
	CASE WHEN SUM(t.milliseconds/1000/60) > 60 THEN 'Long'
	WHEN SUM(t.milliseconds/1000/60) > 30 THEN 'Normal'
	ELSE 'Short' END AS Length
FROM Album al
JOIN Track t
ON al.AlbumId = t.AlbumId
JOIN Genre g
ON t.GenreId = g.GenreId
JOIN Artist ar
ON al.ArtistId = ar.ArtistId
WHERE g.Name = 'Rock'
GROUP BY 1
ORDER BY 3 DESC

### (INSANE) Question 4
/*
How did the popularity of rock songs and the next four genres change from 2009-2013?
*/
SELECT sub1.Year, Rock, Latin, Metal, AlternativePunk, Jazz
FROM(SELECT STRFTIME('%Y', i.InvoiceDate) Year, COUNT(il.InvoiceLineId) Rock, NULL, NULL, NULL, NULL
	FROM Invoice i
	JOIN InvoiceLine il
	ON i.InvoiceId = il.InvoiceId
	JOIN Track t
	ON il.TrackId = t.TrackId
	JOIN Genre g
	ON g.GenreId = t.GenreId
	WHERE g.Name = 'Rock'
	GROUP BY 1) as sub1
JOIN(SELECT STRFTIME('%Y', i.InvoiceDate) Year, NULL, COUNT(il.InvoiceLineId) Latin, NULL, NULL, NULL
	FROM Invoice i
	JOIN InvoiceLine il
	ON i.InvoiceId = il.InvoiceId
	JOIN Track t
	ON il.TrackId = t.TrackId
	JOIN Genre g
	ON g.GenreId = t.GenreId
	WHERE g.Name = 'Latin'
	GROUP BY 1) as sub2
ON sub1.Year = sub2.Year
JOIN(SELECT STRFTIME('%Y', i.InvoiceDate) Year, NULL, NULL, COUNT(il.InvoiceLineId) Metal, NULL, NULL
	FROM Invoice i
	JOIN InvoiceLine il
	ON i.InvoiceId = il.InvoiceId
	JOIN Track t
	ON il.TrackId = t.TrackId
	JOIN Genre g
	ON g.GenreId = t.GenreId
	WHERE g.Name = 'Metal'
	GROUP BY 1) as sub3
ON sub2.Year = sub3.Year
JOIN(SELECT STRFTIME('%Y', i.InvoiceDate) Year, NULL, NULL, NULL, COUNT(il.InvoiceLineId) AlternativePunk, NULL
	FROM Invoice i
	JOIN InvoiceLine il
	ON i.InvoiceId = il.InvoiceId
	JOIN Track t
	ON il.TrackId = t.TrackId
	JOIN Genre g
	ON g.GenreId = t.GenreId
	WHERE g.Name = 'Alternative & Punk'
	GROUP BY 1) as sub4
ON sub3.Year = sub4.Year
JOIN(SELECT STRFTIME('%Y', i.InvoiceDate) Year, NULL, NULL, NULL, NULL, COUNT(il.InvoiceLineId) Jazz
	FROM Invoice i
	JOIN InvoiceLine il
	ON i.InvoiceId = il.InvoiceId
	JOIN Track t
	ON il.TrackId = t.TrackId
	JOIN Genre g
	ON g.GenreId = t.GenreId
	WHERE g.Name = 'Jazz'
	GROUP BY 1) as sub5
ON sub4.Year = sub5.Year
