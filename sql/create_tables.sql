-- table campaigns holds information about flight campaigns
--  data was extracted from ...
-- CREATE TABLE "public"."campaigns" IF NOT EXISTS ("id" serial PRIMARY KEY,"year" integer,)

-- table metadata holds sensing metadata
CREATE TABLE public.metadata
(
    tile character varying,
    year integer default NULL,
    month integer default NULL,
    day integer default NULL,
    PRIMARY KEY (tile)
);

-- ALTER TABLE IF EXISTS public.metadata
    -- OWNER to postgres;

-- table pringles holds actual raster data
CREATE TABLE public.pringles (
    rid serial PRIMARY KEY,
    rast raster,
    filepath text,
    tile text default NULL,
    tree_class text default NULL,
    FOREIGN KEY (tile) REFERENCES public.metadata (tile)

);

CREATE INDEX ON public.pringles
    USING gist (st_convexhull("rast"));

-- SELECT AddRasterConstraints(
--     'public',   -- rastschema
--     'pringles', -- rasttable
--     'rast',     -- rastcolumn
--     TRUE,       -- all rasters have the same SRID
--     TRUE,       -- enforce that all rasters have same x scaling from coordinates to pixels (i.e. pixel size)
--     TRUE,       -- enforce that all rasters have same y scaling from coordinates to pixels (i.e. pixel size)
--     TRUE,       -- enforce that all tiles have the same width in pixels
--     TRUE,       -- enforce that all tiles have the same height in pixels
--     TRUE,       -- enforce ensures they all have same alignment
--     FALSE,      -- enforce spatially unique (no two rasters can be spatially the same) and coverage tile (raster is aligned to a coverage) constraints
--     TRUE,       -- 
--     TRUE,
--     TRUE,
--     FALSE,
--     FALSE
-- );^
