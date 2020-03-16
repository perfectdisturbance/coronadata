CREATE TABLE locations (
    lid INTEGER PRIMARY KEY,
    sublocation TEXT,
    country TEXT,
    lat REAL,
    long REAL
);

CREATE TABLE count_types (
    ctid INTEGER PRIMARY KEY,
    name TEXT
);

CREATE TABLE daily_counts (
    dcid INTEGER PRIMARY KEY,
    lid INTEGER,
    ctid INTEGER,
    day DATE,
    dcount INTEGER,
    FOREIGN KEY(lid) REFERENCES locations(lid),
    FOREIGN KEY(ctid) REFERENCES count_types(ctid)
);

CREATE VIEW alldata AS
	SELECT
		dc.dcid,
		ct.name,
		l.sublocation,
		l.country,
		l.lat,
		l.long,
		dc.day,
		dc.dcount
	FROM
		daily_counts dc JOIN
		locations l ON dc.lid = l.lid JOIN
		count_types ct ON dc.ctid = ct.ctid;

CREATE VIEW newcounts AS
	SELECT
		dc.dcid,
		dc.dcount - pdc.dcount AS newcount
	FROM
		daily_counts dc JOIN
		daily_counts pdc ON dc.lid = pdc.lid AND dc.ctid =pdc.ctid AND dc.day =  date(pdc.day, "1 days")