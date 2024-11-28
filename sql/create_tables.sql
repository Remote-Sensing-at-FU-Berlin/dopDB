-- table campaigns holds information about flight campaigns
--  data was extracted from ...
-- CREATE TABLE "public"."campaigns" IF NOT EXISTS ("id" serial PRIMARY KEY,"year" integer,)

-- table pringles holds actual raster data
CREATE TABLE IF NOT EXISTS "public"."pringles" ("rid" serial PRIMARY KEY,"rast" raster,"filepath" text,"tile" text default NULL,"tree_class" text default NULL);