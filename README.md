# dopDB

> [!WARNING]
> The entire ingest process can take a considerable amount of time. Plan accordingly!

## Create database

Assuming that there is already a Postgres-server running on your machine, executing the following command will create a new database.

```bash
psql -d digital_ortho_images -U postgres -h localhost -p 5432 -f sql/create_database.sql
```

## Create tables

Currently, only one table called "pringles" is used. To create this and potentially other tables, execute the command below.
If the table already exists, it will be skipped and remain unchanged.

```bash
psql -d digital_ortho_images -U postgres -h localhost -p 5432 -f sql/create_database.sql
```

## Ingest data

To ingest data, use the script `raster2pgqsl`. See [here](https://postgis.net/docs/using_raster_dataman.html) or [here](https://postgis.net/workshops/de/postgis-intro/rasters.html) for installation and usage information. On Windows machines, the complete file path must be given where to find the raster files. This is likely why recursive globbing, e.g. i.e. `C:\path\to\data\**\*.tif`, **does not work**. The snipped below pipes the resulting SQL statements directly into `psql`. Alternatively, the output can be redirected to a file and loaded later on. Note however, that the raster data is serialized as base-64 string in the output file which may drastically increase the file size.

> [!NOTE]
> Depending on how GDAL and its bindings are installed on your machine, you may need to set the environment variable "PROJ_LIB". Under Windows, the respective path may be found under `C:\Program Files\QGIS <version>\share\proj`.

```bash
raster2pgsql -a -C -x -P -F -n "filepath" -I -e <path>\*.tif public.pringles | psql psql -d digital_ortho_images -U postgres -h localhost -p 5432
```

The options and flags used above:

| **flag/option** | **action**                                                                                       |
|:---------------:|--------------------------------------------------------------------------------------------------|
|       `-a`      | Append raster(s) to an existing table.                                                           |
|       `-C`      | Apply raster constraints                                                                         |
|       `-x`      | Disable setting the max extent constraint.                                                       |
|       `-P`      | Pad right-most and bottom-most tiles to guarantee that all tiles have the same width and height. |
|       `-F`      | Add a column with the name of the file                                                           |
|       `-n`      | Specify the name of the filename column.                                                         |
|       `-I`      | Create a GiST index on the raster column.                                                        |
|       `-e`      | Execute each statement individually, do not use a transaction.                                   |

## Update data

As some information is encoded directly into the filename and thus not queriable, we need to update some further values. Currently, these are only the tile id and class label.

```bash
psql -d digital_ortho_images -U postgres -h localhost -p 5432 -f sql/update_columns.sql
```
