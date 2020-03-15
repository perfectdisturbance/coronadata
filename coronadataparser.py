#!/usr/bin/python
import csv
import sqlite3
import datetime

#constants
datadirectory = "data/csse_covid_19_data/csse_covid_19_time_series/"
databasefile = "coronadata.db"
datatypes = ['Confirmed', 'Deaths', 'Recovered']
nondatecolumns = ['Province/State', 'Country/Region', 'Lat', 'Long']


conn = sqlite3.connect(databasefile)
curs = conn.cursor()

print (sqlite3.sqlite_version)
print (databasefile)

for mytype in datatypes:

    #Add count type to database
    curs.execute("INSERT INTO count_types (name) VALUES (?)", (mytype,))
    counttypeid = curs.lastrowid
    
    datafile = datadirectory+"time_series_19-covid-"+mytype+".csv"
    
    print("Opening:")
    print(datafile)
    
    with open(datafile) as csvfile:
        coronareader = csv.DictReader(csvfile)
        for row in coronareader:
            #Initialize location id
            locationid = 0
            
            #check if location exists.
            curs.execute("SELECT lid FROM locations WHERE sublocation=? AND country=?", (row[nondatecolumns[0]], row[nondatecolumns[1]]))
            matchinglocations = curs.fetchall()
            
            #determine location id
            if len(matchinglocations) == 0:
                #Add Location Entry
                curs.execute("INSERT INTO locations ('sublocation', 'country', 'lat', 'long') VALUES (?, ?, ?, ?)", 
                (row[nondatecolumns[0]], row[nondatecolumns[1]], row[nondatecolumns[2]], row[nondatecolumns[3]]))
                locationid = curs.lastrowid
            elif len(matchinglocations) == 1:
                locationid = matchinglocations[0][0];
            else:
                print ("ERROR: Duplicate Location Found!")
                exit()
            
            #Loop over counts columns
            for column in row.keys():
                try:
                    nondatecolumns.index(column)
                except ValueError as err:
                    datadate = datetime.datetime.strptime(column,'%m/%d/%y')
                    curs.execute("INSERT INTO daily_counts (lid, ctid, day, dcount) VALUES (?, ?, ?, ?)",
                    (locationid, counttypeid, datadate.strftime('%Y-%m-%d'), row[column]))
                except Exception as err:
                    print(err)
                    exit()


# Save and Close
conn.commit()
conn.close()
            