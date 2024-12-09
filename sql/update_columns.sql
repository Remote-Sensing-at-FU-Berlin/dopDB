UPDATE metadata
SET
	tile = substring(tile from '%#"[0-9]{5}-[0-9]{4}#"%' FOR '#')  -- dop_01234-5678 => 01234-5678
;

UPDATE pringles
SET
	rast = ST_FromGDALRaster(pg_read_binary_file(filepath)),
	tile = substring(filepath from '%#"[0-9]{5}-[0-9]{4}#"%' FOR '#'),
	tree_class = split_part(filepath, '\', 3) -- substring(filepath from '%#"[A-Z]+?#"%' for '#')
;