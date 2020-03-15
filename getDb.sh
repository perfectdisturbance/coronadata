git clone https://github.com/CSSEGISandData/COVID-19.git data
sqlite3 coronadata.db < CoronaSchema.sql
./coronadataparser.py