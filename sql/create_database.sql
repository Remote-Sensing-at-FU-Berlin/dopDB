-- Database: digital_ortho_images

-- DROP DATABASE IF EXISTS digital_ortho_images;

CREATE DATABASE digital_ortho_images
    WITH
    OWNER = postgres
    ENCODING = 'UTF8'
    LC_COLLATE = 'German_Germany.1252'
    LC_CTYPE = 'German_Germany.1252'
    LOCALE_PROVIDER = 'libc'
    TABLESPACE = pg_default
    CONNECTION LIMIT = -1
    IS_TEMPLATE = False;

ALTER DATABASE digital_ortho_images
    SET search_path TO "$user", public, topology, tiger;
ALTER DATABASE digital_ortho_images
    SET "postgis.gdal_enabled_drivers" TO 'ENABLE_ALL';