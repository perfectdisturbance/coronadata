library(RSQLite)

conn <- dbConnect(RSQLite::SQLite(), "./coronadata.db")

countrydata <- dbGetQuery(conn, "SELECT JULIANDAY(a.day) - 2458870.5 AS nday, a.dcount FROM alldata a WHERE a.country LIKE 'China' AND a.name LIKE 'Confirmed' GROUP BY a.country, a.day")

print(countrydata)
countrymodel <- nls(dcount ~ SSlogis(nday, Asym, xmid, scal), countrydata)
plot(countrydata)
lines(countrydata$nday, predict(countrymodel))
