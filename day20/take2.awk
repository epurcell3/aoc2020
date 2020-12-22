BEGIN {
	RS = "\n\n"
	FPAT = "([0-9]+|[#.]+)"
}

{
	ntiles++
	top = $2
	bottom = $11
	left = ""
	right = ""
	for (i = 2; i <= 11; i++) {
		left = left substr($i, 0, 1)
		right = right substr($i, 10, 1)
	}
	borders[$1]["top"] = top
	borders[$1]["bottom"] = bottom
	borders[$1]["left"] = left
	borders[$1]["right"] = right
	tiles[$1][1] = substr($3, 2, 8)
	tiles[$1][2] = substr($4, 2, 8)
	tiles[$1][3] = substr($5, 2, 8)
	tiles[$1][4] = substr($6, 2, 8)
	tiles[$1][5] = substr($7, 2, 8)
	tiles[$1][6] = substr($8, 2, 8)
	tiles[$1][7] = substr($9, 2, 8)
	tiles[$1][8] = substr($10, 2, 8)
}

NR == 1 {
	map[0,0] = $1
	placed_tiles[$1]["x"] = 0
	placed_tiles[$1]["y"] = 0
}

END {
	do {
		for (id in borders) {
			if (id in placed_tiles) continue
			for (id2 in placed_tiles) {
				place_tile_if_matched(id2, id)
			}
		}
	} while (length(placed_tiles) != ntiles)
	x_min = 0
	x_max = 0
	y_min = 0
	y_max = 0
	for (tile in placed_tiles) {
		if (placed_tiles[tile]["x"] < x_min) x_min = placed_tiles[tile]["x"]
		if (placed_tiles[tile]["x"] > x_max) x_max = placed_tiles[tile]["x"]
		if (placed_tiles[tile]["y"] < y_min) y_min = placed_tiles[tile]["y"]
		if (placed_tiles[tile]["y"] > y_max) y_max = placed_tiles[tile]["y"]
	}
	print map[x_min, y_min] * map[x_min, y_max] * map[x_max, y_min] * map[x_max, y_max]


	row = 0
	for (r = y_max; r >= y_min; r--) {
		for (c = x_min; c <= x_max; c++) {
			image[1 + row * 8] = image[1 + row * 8] tiles[map[c, r]][1]
			image[2 + row * 8] = image[2 + row * 8] tiles[map[c, r]][2]
			image[3 + row * 8] = image[3 + row * 8] tiles[map[c, r]][3]
			image[4 + row * 8] = image[4 + row * 8] tiles[map[c, r]][4]
			image[5 + row * 8] = image[5 + row * 8] tiles[map[c, r]][5]
			image[6 + row * 8] = image[6 + row * 8] tiles[map[c, r]][6]
			image[7 + row * 8] = image[7 + row * 8] tiles[map[c, r]][7]
			image[8 + row * 8] = image[8 + row * 8] tiles[map[c, r]][8]
		}
		row++
	}
	#for (i = 1; i <= row * 8; i++) print image[i]
	#|                   # 
	#| #    ##    ##    ###
	#|  #  #  #  #  #  #   
	monster_filter[1] = "..................#."
	monster_filter[2] = "#....##....##....###"
	monster_filter[3] = ".#..#..#..#..#..#..."
	scan_width = length(image[1]) - length(monster_filter[1])
	for (rotation = 0; rotation <= 3; rotation++) {
		n_monsters = n_monsters_scanned()
		if (n_monsters) break

		flip_image("v")
		n_monsters = n_monsters_scanned()
		if (n_monsters) break
		flip_image("v")
		flip_image("h")
		n_monsters = n_monsters_scanned()
		if (n_monsters) break
		flip_image("h")

		rotate_image()
	}
	#print n_monsters

	for (i = 0; i <= row * 8; i++) {
		gsub(/[^#]/, "", image[i])
		high_spots += length(image[i])
	}
	print high_spots - 15 * n_monsters
}

function reverse(str, _s, _i) {
	for (_i = length(str); _i > 0; _i--) {
		_s = _s substr(str, _i, 1)
	}
	return _s
}

function rotate_image(    i, j, tmp_image) {
	delete tmp_image
	for (i = 1; i <= length(image[1]); i++) {
		tmp_image[i] = ""
		for (j = 1; j <= length(image); j++) {
			tmp_image[i] = tmp_image[i] substr(image[j], length(image[j]) - i + 1, 1)
		}
	}
	for (i = 1; i <= length(tmp_image); i++) image[i] = tmp_image[i]
}

function flip_image(f,      i, tmp_image) {
	delete tmp_image
	if (f == "h") {
		for (i = 1; i <= length(image); i++) {
			tmp_image[length(image) - i + 1] = image[i]
		}
		for (i = 1; i <= length(tmp_image); i++) image[i] = tmp_image[i]
	} else if (f == "v") {
		for (i = 1; i < length(image); i++) image[i] = reverse(image[i])
	}
}

function n_monsters_scanned(   n) {
	n = 0
	for (i = 2; i < row * 8; i++) {
		for (j = 1; j <= scan_width; j++) {
			if (match(substr(image[i - 1], j, length(monster_filter[1])), monster_filter[1]) && 
			    match(substr(image[i], j, length(monster_filter[1])), monster_filter[2]) &&
			    match(substr(image[i + 1], j, length(monster_filter[1])), monster_filter[3])) {
				n++
			}
		}
	}
	return n
}

function rotate_borders(tile, n,         tmp, i, j, k, tmp_tile) {
	delete tmp_tile
	for (i = 0; i < n; i++) {
		tmp = borders[tile]["top"]
		borders[tile]["top"] = borders[tile]["right"]
		borders[tile]["right"] = reverse(borders[tile]["bottom"])
		borders[tile]["bottom"] = borders[tile]["left"]
		borders[tile]["left"] = reverse(tmp)

		for (j = 1; j <= length(tiles[tile][1]); j++) {
			tmp_tile[j] = ""
			for (k = 1; k <= length(tiles[tile]); k++) {
				tmp_tile[j] = tmp_tile[j] substr(tiles[tile][k], length(tiles[tile][k]) - j + 1, 1)
			}
		}
		for (j = 1; j <= length(tmp_tile); j++) {
			tiles[tile][j] = tmp_tile[j]
		}
	}
}

function flip_borders(tile, n,        tmp, i, tmp_tile) {
	delete tmp_tile
	if (n == "h") {
		borders[tile]["left"] = reverse(borders[tile]["left"])
		borders[tile]["right"] = reverse(borders[tile]["right"])
		tmp = borders[tile]["top"]
		borders[tile]["top"] = borders[tile]["bottom"]
		borders[tile]["bottom"] = tmp

		for (i = 1; i <= length(tiles[tile]); i++) {
			tmp_tile[length(tiles[tile]) - i + 1] = tiles[tile][i]
		}
		for (i = 1; i <= length(tmp_tile); i++) {
			tiles[tile][i] = tmp_tile[i]
		}
	} else if (n == "v") {
		borders[tile]["top"] = reverse(borders[tile]["top"])
		borders[tile]["bottom"] = reverse(borders[tile]["bottom"])
		tmp = borders[tile]["left"]
		borders[tile]["left"] = borders[tile]["right"]
		borders[tile]["right"] = tmp

		for (i = 1; i <= length(tiles[tile]); i++) {
			tiles[tile][i] = reverse(tiles[tile][i])
		}
	}
}

function place_tile_if_matched(placed_tile, tile,                      key) {
	if (borders[tile]["top"] == borders[placed_tile]["top"]) {
		placed_tiles[tile]["x"] = placed_tiles[placed_tile]["x"]
		placed_tiles[tile]["y"] = placed_tiles[placed_tile]["y"] + 1
		key = placed_tiles[tile]["x"] SUBSEP placed_tiles[tile]["y"]
		map[key] = tile
		# Update tiles
		rotate_borders(tile, 0)
		flip_borders(tile, "h")
	}
	if (reverse(borders[tile]["top"]) == borders[placed_tile]["top"]) {
		placed_tiles[tile]["x"] = placed_tiles[placed_tile]["x"]
		placed_tiles[tile]["y"] = placed_tiles[placed_tile]["y"] + 1
		key = placed_tiles[tile]["x"] SUBSEP placed_tiles[tile]["y"]
		map[key] = tile
		# Update tiles
		rotate_borders(tile, 2)
		flip_borders(tile, 0)
	}
	if (borders[tile]["right"] == borders[placed_tile]["top"]) {
		placed_tiles[tile]["x"] = placed_tiles[placed_tile]["x"]
		placed_tiles[tile]["y"] = placed_tiles[placed_tile]["y"] + 1
		key = placed_tiles[tile]["x"] SUBSEP placed_tiles[tile]["y"]
		map[key] = tile
		# Update tiles
		rotate_borders(tile, 1)
		flip_borders(tile, "h")
	}
	if (reverse(borders[tile]["right"]) == borders[placed_tile]["top"]) {
		placed_tiles[tile]["x"] = placed_tiles[placed_tile]["x"]
		placed_tiles[tile]["y"] = placed_tiles[placed_tile]["y"] + 1
		key = placed_tiles[tile]["x"] SUBSEP placed_tiles[tile]["y"]
		map[key] = tile
		# Update tiles
		rotate_borders(tile, 3)
		flip_borders(tile, 0)
	}
	if (borders[tile]["bottom"] == borders[placed_tile]["top"]) {
		placed_tiles[tile]["x"] = placed_tiles[placed_tile]["x"]
		placed_tiles[tile]["y"] = placed_tiles[placed_tile]["y"] + 1
		key = placed_tiles[tile]["x"] SUBSEP placed_tiles[tile]["y"]
		map[key] = tile
		# Update tiles
		rotate_borders(tile, 0)
		flip_borders(tile, 0)
	}
	if (reverse(borders[tile]["bottom"]) == borders[placed_tile]["top"]) {
		placed_tiles[tile]["x"] = placed_tiles[placed_tile]["x"]
		placed_tiles[tile]["y"] = placed_tiles[placed_tile]["y"] + 1
		key = placed_tiles[tile]["x"] SUBSEP placed_tiles[tile]["y"]
		map[key] = tile
		# Update tiles
		rotate_borders(tile, 0)
		flip_borders(tile, "v")
	}
	if (borders[tile]["left"] == borders[placed_tile]["top"]) {
		placed_tiles[tile]["x"] = placed_tiles[placed_tile]["x"]
		placed_tiles[tile]["y"] = placed_tiles[placed_tile]["y"] + 1
		key = placed_tiles[tile]["x"] SUBSEP placed_tiles[tile]["y"]
		map[key] = tile
		# Update tiles
		rotate_borders(tile, 1)
		flip_borders(tile, 0)
	}
	if (reverse(borders[tile]["left"]) == borders[placed_tile]["top"]) {
		placed_tiles[tile]["x"] = placed_tiles[placed_tile]["x"]
		placed_tiles[tile]["y"] = placed_tiles[placed_tile]["y"] + 1
		key = placed_tiles[tile]["x"] SUBSEP placed_tiles[tile]["y"]
		map[key] = tile
		# Update tiles
		rotate_borders(tile, 1)
		flip_borders(tile, "v")
	}

	if (borders[tile]["top"] == borders[placed_tile]["right"]) {
		placed_tiles[tile]["x"] = placed_tiles[placed_tile]["x"] + 1
		placed_tiles[tile]["y"] = placed_tiles[placed_tile]["y"]
		key = placed_tiles[tile]["x"] SUBSEP placed_tiles[tile]["y"]
		map[key] = tile
		# Update tiles
		rotate_borders(tile, 1)
		flip_borders(tile, "h")
	}
	if (reverse(borders[tile]["top"]) == borders[placed_tile]["right"]) {
		placed_tiles[tile]["x"] = placed_tiles[placed_tile]["x"] + 1
		placed_tiles[tile]["y"] = placed_tiles[placed_tile]["y"]
		key = placed_tiles[tile]["x"] SUBSEP placed_tiles[tile]["y"]
		map[key] = tile
		# Update tiles
		rotate_borders(tile, 1)
		flip_borders(tile, 0)
	}
	if (borders[tile]["right"] == borders[placed_tile]["right"]) {
		placed_tiles[tile]["x"] = placed_tiles[placed_tile]["x"] + 1
		placed_tiles[tile]["y"] = placed_tiles[placed_tile]["y"]
		key = placed_tiles[tile]["x"] SUBSEP placed_tiles[tile]["y"]
		map[key] = tile
		# Update tiles
		rotate_borders(tile, 0)
		flip_borders(tile, "v")
	}
	if (reverse(borders[tile]["right"]) == borders[placed_tile]["right"]) {
		placed_tiles[tile]["x"] = placed_tiles[placed_tile]["x"] + 1
		placed_tiles[tile]["y"] = placed_tiles[placed_tile]["y"]
		key = placed_tiles[tile]["x"] SUBSEP placed_tiles[tile]["y"]
		map[key] = tile
		# Update tiles
		rotate_borders(tile, 2)
		flip_borders(tile, 0)
	}
	if (borders[tile]["bottom"] == borders[placed_tile]["right"]) {
		placed_tiles[tile]["x"] = placed_tiles[placed_tile]["x"] + 1
		placed_tiles[tile]["y"] = placed_tiles[placed_tile]["y"]
		key = placed_tiles[tile]["x"] SUBSEP placed_tiles[tile]["y"]
		map[key] = tile
		# Update tiles
		rotate_borders(tile, 3)
		flip_borders(tile, 0)
	}
	if (reverse(borders[tile]["bottom"]) == borders[placed_tile]["right"]) {
		placed_tiles[tile]["x"] = placed_tiles[placed_tile]["x"] + 1
		placed_tiles[tile]["y"] = placed_tiles[placed_tile]["y"]
		key = placed_tiles[tile]["x"] SUBSEP placed_tiles[tile]["y"]
		map[key] = tile
		# Update tiles
		rotate_borders(tile, 1)
		flip_borders(tile, "v")
	}
	if (borders[tile]["left"] == borders[placed_tile]["right"]) {
		placed_tiles[tile]["x"] = placed_tiles[placed_tile]["x"] + 1
		placed_tiles[tile]["y"] = placed_tiles[placed_tile]["y"]
		key = placed_tiles[tile]["x"] SUBSEP placed_tiles[tile]["y"]
		map[key] = tile
		# Update tiles
		rotate_borders(tile, 0)
		flip_borders(tile, 0)
	}
	if (reverse(borders[tile]["left"]) == borders[placed_tile]["right"]) {
		placed_tiles[tile]["x"] = placed_tiles[placed_tile]["x"] + 1
		placed_tiles[tile]["y"] = placed_tiles[placed_tile]["y"]
		key = placed_tiles[tile]["x"] SUBSEP placed_tiles[tile]["y"]
		map[key] = tile
		# Update tiles
		rotate_borders(tile, 0)
		flip_borders(tile, "h")
	}

	if (borders[tile]["top"] == borders[placed_tile]["bottom"]) {
		placed_tiles[tile]["x"] = placed_tiles[placed_tile]["x"]
		placed_tiles[tile]["y"] = placed_tiles[placed_tile]["y"] - 1
		key = placed_tiles[tile]["x"] SUBSEP placed_tiles[tile]["y"]
		map[key] = tile
		# Update tiles
		rotate_borders(tile, 0)
		flip_borders(tile, 0)
	}
	if (reverse(borders[tile]["top"]) == borders[placed_tile]["bottom"]) {
		placed_tiles[tile]["x"] = placed_tiles[placed_tile]["x"]
		placed_tiles[tile]["y"] = placed_tiles[placed_tile]["y"] - 1
		key = placed_tiles[tile]["x"] SUBSEP placed_tiles[tile]["y"]
		map[key] = tile
		# Update tiles
		rotate_borders(tile, 0)
		flip_borders(tile, "v")
	}
	if (borders[tile]["right"] == borders[placed_tile]["bottom"]) {
		placed_tiles[tile]["x"] = placed_tiles[placed_tile]["x"]
		placed_tiles[tile]["y"] = placed_tiles[placed_tile]["y"] - 1
		key = placed_tiles[tile]["x"] SUBSEP placed_tiles[tile]["y"]
		map[key] = tile
		# Update tiles
		rotate_borders(tile, 1)
		flip_borders(tile, 0)
	}
	if (reverse(borders[tile]["right"]) == borders[placed_tile]["bottom"]) {
		placed_tiles[tile]["x"] = placed_tiles[placed_tile]["x"]
		placed_tiles[tile]["y"] = placed_tiles[placed_tile]["y"] - 1
		key = placed_tiles[tile]["x"] SUBSEP placed_tiles[tile]["y"]
		map[key] = tile
		# Update tiles
		rotate_borders(tile, 1)
		flip_borders(tile, "v")
	}
	if (borders[tile]["bottom"] == borders[placed_tile]["bottom"]) {
		placed_tiles[tile]["x"] = placed_tiles[placed_tile]["x"]
		placed_tiles[tile]["y"] = placed_tiles[placed_tile]["y"] - 1
		key = placed_tiles[tile]["x"] SUBSEP placed_tiles[tile]["y"]
		map[key] = tile
		# Update tiles
		rotate_borders(tile, 0)
		flip_borders(tile, "h")
	}
	if (reverse(borders[tile]["bottom"]) == borders[placed_tile]["bottom"]) {
		placed_tiles[tile]["x"] = placed_tiles[placed_tile]["x"]
		placed_tiles[tile]["y"] = placed_tiles[placed_tile]["y"] - 1
		key = placed_tiles[tile]["x"] SUBSEP placed_tiles[tile]["y"]
		map[key] = tile
		# Update tiles
		rotate_borders(tile, 2)
		flip_borders(tile, 0)
	}
	if (borders[tile]["left"] == borders[placed_tile]["bottom"]) {
		placed_tiles[tile]["x"] = placed_tiles[placed_tile]["x"]
		placed_tiles[tile]["y"] = placed_tiles[placed_tile]["y"] - 1
		key = placed_tiles[tile]["x"] SUBSEP placed_tiles[tile]["y"]
		map[key] = tile
		# Update tiles
		rotate_borders(tile, 1)
		flip_borders(tile, "h")
	}
	if (reverse(borders[tile]["left"]) == borders[placed_tile]["bottom"]) {
		placed_tiles[tile]["x"] = placed_tiles[placed_tile]["x"]
		placed_tiles[tile]["y"] = placed_tiles[placed_tile]["y"] - 1
		key = placed_tiles[tile]["x"] SUBSEP placed_tiles[tile]["y"]
		map[key] = tile
		# Update tiles
		rotate_borders(tile, 3)
		flip_borders(tile, 0)
	}

	if (borders[tile]["top"] == borders[placed_tile]["left"]) {
		placed_tiles[tile]["x"] = placed_tiles[placed_tile]["x"] - 1
		placed_tiles[tile]["y"] = placed_tiles[placed_tile]["y"]
		key = placed_tiles[tile]["x"] SUBSEP placed_tiles[tile]["y"]
		map[key] = tile
		# Update tiles
		rotate_borders(tile, 3)
		flip_borders(tile, 0)
	}
	if (reverse(borders[tile]["top"]) == borders[placed_tile]["left"]) {
		placed_tiles[tile]["x"] = placed_tiles[placed_tile]["x"] - 1
		placed_tiles[tile]["y"] = placed_tiles[placed_tile]["y"]
		key = placed_tiles[tile]["x"] SUBSEP placed_tiles[tile]["y"]
		map[key] = tile
		# Update tiles
		rotate_borders(tile, 1)
		flip_borders(tile, "v")
	}
	if (borders[tile]["right"] == borders[placed_tile]["left"]) {
		placed_tiles[tile]["x"] = placed_tiles[placed_tile]["x"] - 1
		placed_tiles[tile]["y"] = placed_tiles[placed_tile]["y"]
		key = placed_tiles[tile]["x"] SUBSEP placed_tiles[tile]["y"]
		map[key] = tile
		# Update tiles
		rotate_borders(tile, 0)
		flip_borders(tile, 0)
	}
	if (reverse(borders[tile]["right"]) == borders[placed_tile]["left"]) {
		placed_tiles[tile]["x"] = placed_tiles[placed_tile]["x"] - 1
		placed_tiles[tile]["y"] = placed_tiles[placed_tile]["y"]
		key = placed_tiles[tile]["x"] SUBSEP placed_tiles[tile]["y"]
		map[key] = tile
		# Update tiles
		rotate_borders(tile, 0)
		flip_borders(tile, "h")
	}
	if (borders[tile]["bottom"] == borders[placed_tile]["left"]) {
		placed_tiles[tile]["x"] = placed_tiles[placed_tile]["x"] - 1
		placed_tiles[tile]["y"] = placed_tiles[placed_tile]["y"]
		key = placed_tiles[tile]["x"] SUBSEP placed_tiles[tile]["y"]
		map[key] = tile
		# Update tiles
		rotate_borders(tile, 1)
		flip_borders(tile, "h")
	}
	if (reverse(borders[tile]["bottom"]) == borders[placed_tile]["left"]) {
		placed_tiles[tile]["x"] = placed_tiles[placed_tile]["x"] - 1
		placed_tiles[tile]["y"] = placed_tiles[placed_tile]["y"]
		key = placed_tiles[tile]["x"] SUBSEP placed_tiles[tile]["y"]
		map[key] = tile
		# Update tiles
		rotate_borders(tile, 1)
		flip_borders(tile, 0)
	}
	if (borders[tile]["left"] == borders[placed_tile]["left"]) {
		placed_tiles[tile]["x"] = placed_tiles[placed_tile]["x"] - 1
		placed_tiles[tile]["y"] = placed_tiles[placed_tile]["y"]
		key = placed_tiles[tile]["x"] SUBSEP placed_tiles[tile]["y"]
		map[key] = tile
		# Update tiles
		rotate_borders(tile, 0)
		flip_borders(tile, "v")
	}
	if (reverse(borders[tile]["left"]) == borders[placed_tile]["left"]) {
		placed_tiles[tile]["x"] = placed_tiles[placed_tile]["x"] - 1
		placed_tiles[tile]["y"] = placed_tiles[placed_tile]["y"]
		key = placed_tiles[tile]["x"] SUBSEP placed_tiles[tile]["y"]
		map[key] = tile
		# Update tiles
		rotate_borders(tile, 2)
		flip_borders(tile, 0)
	}

}
