UPDATE pringles
SET
	tile = substring(filepath from '%#"[0-9]{5}-[0-9]{4}#"%' FOR '#'),
	tree_class = substring(filepath from '%#"[A-Z]+?#"%' for '#')
;