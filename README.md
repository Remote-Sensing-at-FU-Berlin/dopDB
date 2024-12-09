# dopDB

> [!WARNING]
> The entire ingest process can take a considerable amount of time. Plan accordingly!

## Create database

Assuming that there is already a Postgres-server running on your machine, executing the following command will create a new database.

```bash
psql -d digital_ortho_images -U postgres -h localhost -p 5432 -f sql/create_database.sql
```

## Create tables

To create the main table containing that will hold all raster data in the end as well as a metadata table (currently) containing both the tile ID as well as the sampling datatables, execute the command below.

> [!CAUTION]
> Not all sensing could be extracted from the original ortho images. Thus, roughly 3000 tiles are missing.

```bash
psql -d digital_ortho_images -U postgres -h localhost -p 5432 -f sql/create_tables.sql
```

## Ingest data

After successful creation of the tables, ingest both the metadata and filenpaths. Please note that in its current configuration, the csv file containing the tile metadata is expected to have a header while the csv file containing filenames (one per row) is not.

> [!INFO]
> Note however, that the table is not distributed with this repository and the path argument in the respective SQL file needs adjustment!

```bash
psql -d digital_ortho_images -U postgres -h localhost -p 5432 -f sql/ingest.sql
```

> [!NOTE]
> An earlier version used the script `raster2pgqsl` ([here](https://postgis.net/docs/using_raster_dataman.html) or [here](https://postgis.net/workshops/de/postgis-intro/rasters.html) for installation and usage information) to ingest data. However, using this approach under Windows resulted in huge SQL files with the raster data stored as base64-encoded strings or the constraint that data is stored outside of the database itself. At the time of writing, the script is only used to generate the SQL statements requried to setup the tables correctly.

> [!TIP]
> Depending on how GDAL and its bindings are installed on your machine, you may need to set the environment variable "PROJ_LIB". Under Windows, the respective path may be found under `C:\Program Files\QGIS <version>\share\proj`.

```bash
raster2pgsql -c -C -x -P -F -n "filepath" -I -e E:\pringles\AS\*.tif public.pringles
```

The options and flags used above (most of them usunsed or not applicable anymore):

| **flag/option** | **action**                                                                                       |
|:---------------:|--------------------------------------------------------------------------------------------------|
|       `-p`      | Append raster(s) to an existing table.                                                           |
|       `-C`      | Apply raster constraints                                                                         |
|       `-x`      | Disable setting the max extent constraint.                                                       |
|       `-P`      | Pad right-most and bottom-most tiles to guarantee that all tiles have the same width and height. |
|       `-F`      | Add a column with the name of the file                                                           |
|       `-n`      | Specify the name of the filename column.                                                         |
|       `-I`      | Create a GiST index on the raster column.                                                        |
|       `-e`      | Execute each statement individually, do not use a transaction.                                   |

## Update data

As some information is encoded directly into the filename and thus not queriable, we need to update some further values. Currently, these are only the tile id and class label. This step includes the actual data ingest from disk and will take considerable time. Parallel Queries do not apply here unfortunately as the queries writes data into the database.

Depending on your file system structure, the location of the tree class will be at a different index and the `split_part` function call needs to be updated accordingly.

```bash
psql -d digital_ortho_images -U postgres -h localhost -p 5432 -f sql/update_columns.sql
```

Finally, apply raster constraints by executing the following command

```SQL
SELECT AddRasterConstraints('pringles'::name, 'rast'::name);
```

## Notes and Ideas

- using parallel under linux to speed up processing?
- environment variable PGPASSWORD when using the pipe
- thoughts about optimizations
  - Using [GNU parallel and others](https://gis.stackexchange.com/questions/187796/how-to-speed-up-raster2pgsql)
  - [Speed up by disabling nodata check (unsued)](https://github.com/janne-alatalo/slow-raster2pgsql-workaround)
