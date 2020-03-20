It's a pillow, it's a pet...

These are some tools for proccessing covid-19 data.  The getDb.sh script clones the latest covid-19 data from the John Hopkins git repository creates an empty SQLite database then executes the coronadataparser.py script which parses the data and populates the database.

You can then use any relational database tools you prefer to query the data.  I have also provided some helpful views in the database that make writing queries easier.  Below I have included some queries I found interesting.

The analysis.r file is an R script that uses the data in the database to create a model which fits the data for a given country to a logistic function and then graphs the data and model. The ChinaCovidCurve.pdf is an example output of the R script

I don't know R and have very little experience with predictive models so if someone else wanted to take this further or figure out help it so it will converge for all data inputs feel free.


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
