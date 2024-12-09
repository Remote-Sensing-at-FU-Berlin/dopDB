-- ingress metadata from CSV
COPY metadata
    FROM '<base-path>/sensing-dates.csv'
    DELIMITERS ','
    CSV
    HEADER
;

COPY pringles
    FROM '<base-path>/raster-paths.csv'
    DELIMITERS ','
    CSV
;