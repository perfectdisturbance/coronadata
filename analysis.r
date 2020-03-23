library(RSQLite)

#Connect to SQLite Db
conn <- dbConnect(RSQLite::SQLite(), "./coronadata.db")

#Parameters
country <- "US"

lastzerodata <- dbGetQuery(conn, "
SELECT
    a.day,
    SUM(a.dcount) AS dcount 
FROM 
    alldata a
WHERE
    a.country LIKE ? AND 
    a.name LIKE 'Confirmed' AND
    dcount = 0
GROUP BY 
    a.country, a.day
ORDER BY a.day DESC
LIMIT 1 ", params = c(country))
print(lastzerodata)
lastzerocasedate <- lastzerodata[1,1]
print(lastzerocasedate)

countrydata <- dbGetQuery(conn, "
SELECT
    JULIANDAY(a.day) - 2458870.5 AS days_since_outbreak,
    SUM(a.dcount) AS confirmed_cases 
FROM 
    alldata a
WHERE
    a.name LIKE 'Confirmed' AND
    a.country LIKE ? AND 
    a.day >= date(?)
GROUP BY 
    a.country, a.day", params = c(country, lastzerocasedate))

print(countrydata)
countrymodel <- nls(confirmed_cases ~ SSlogis(days_since_outbreak, Asym, xmid, scal), countrydata)
print(countrymodel)
plot(countrydata)
lines(countrydata$days_since_outbreak, predict(countrymodel))
