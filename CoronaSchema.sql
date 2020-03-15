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

