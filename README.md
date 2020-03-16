It's a pillow, it's a pet...

Some interesting queries:

SELECT 
	ad.name,
	ad.country,
	ad.day,
	SUM(ad.dcount) AS dcount,
	SUM(nc.newcount) AS newcount 
FROM 
	alldata ad JOIN 
	newcounts nc ON ad.dcid = nc.dcid WHERE ad.country LIKE 'italy' 
GROUP BY 
	ad.name,
	ad.country,
	ad.day
ORDER BY
	ad.name,
	ad.day
