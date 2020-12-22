BEGIN {
	RS = "\n\n"
	FPAT = "([0-9]+|[#.]+)"
}

{
	tiles++
	top = $2
	bottom = $11
	left = ""
	right = ""
	for (i = 2; i <= 11; i++) {
		left = left substr($i, 0, 1)
		right = right substr($i, 10, 1)
	}
	for (id in borders) {
		for (direction in borders[id]) {
			if (borders[id][direction] == top) {
				matches[$1,id][1] = "top"
				matches[$1,id][2] = direction
				matches[$1,id]["flipped"] = 0
			}
			if (borders[id][direction] == bottom) {
				matches[$1,id][1] = "bottom"
				matches[$1,id][2] = direction
				matches[$1,id]["flipped"] = 0
			}
			if (borders[id][direction] == left) {
				matches[$1,id][1] = "left"
				matches[$1,id][2] = direction
				matches[$1,id]["flipped"] = 0
			}
			if (borders[id][direction] == right) {
				matches[$1,id][1] = "right"
				matches[$1,id][2] = direction
				matches[$1,id]["flipped"] = 0
			}
			if (borders[id][direction] == reverse(top)) {
				matches[$1,id][1] = "top"
				matches[$1,id][2] = direction
				matches[$1,id]["flipped"] = 1
			}
			if (borders[id][direction] == reverse(bottom)) {
				matches[$1,id][1] = "bottom"
				matches[$1,id][2] = direction
				matches[$1,id]["flipped"] = 1
			}
			if (borders[id][direction] == reverse(left)) {
				matches[$1,id][1] = "left"
				matches[$1,id][2] = direction
				matches[$1,id]["flipped"] = 1
			}
			if (borders[id][direction] == reverse(right)) {
				matches[$1,id][1] = "right"
				matches[$1,id][2] = direction
				matches[$1,id]["flipped"] = 1
			}
		}
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

END {
	for (m in matches) {
		# Find corners by number of shared borders
		split(m, arr, SUBSEP)
		for (i in arr) {
			n_borders[arr[i]]++
		}
	}
	p1 = 1
	for (id in n_borders) {
		if (n_borders[id] == 2) {
			p1 *= id
			corners[length(corners)] = id
		}
	}
	print p1

	# Build map
	connected_tiles[0] = corners[0]
	curr_tile = 0
	tile_map[connected_tiles[curr_tile]]["x"] = 0
	tile_map[connected_tiles[curr_tile]]["y"] = 0
	tile_map[connected_tiles[curr_tile]]["flipped"] = 0
	# counter clockwise
	tile_map[connected_tiles[curr_tile]]["rotate"] = 0
	for (m in matches) {
		split(m, arr, SUBSEP)
		if (arr[2] == connected_tiles[curr_tile]) {
			connected_tiles[length(connected_tiles)] = arr[1]
			if (matches[m][2] == "top" || matches[m][2] == "left") {
				tile_map[connected_tiles[curr_tile]]["rotate"]++
			}
		}
	}

	while (length(connected_tiles) != tiles) {
		for (m in matches) {
			split(m, arr, SUBSEP)
			if (arr[2] == connected_tiles[curr_tile]) {
				connected_tiles[length(connected_tiles)] = arr[1]
				switch (tile_map[connected_tiles[curr_tile]]["rotate"] {
				case 0:
					if (matches[m][2] == "right" && matches[m][1] == "left") {
						tile_map[arr[1]]["x"] = tile_map[arr[2]]["x"] + 1
						tile_map[arr[1]]["y"] = tile_map[arr[2]]["y"]
						tile_map[arr[1]]["rotate"] = 0
						tile_map[arr[1]]["flipped"] = matches[m]["flipped"]
					} else if (matches[m][2] == "right" && matches[m][1] == "top") {
						tile_map[arr[1]]["x"] = tile_map[arr[2]]["x"] + 1
						tile_map[arr[1]]["y"] = tile_map[arr[2]]["y"]
						tile_map[arr[1]]["rotate"] = 1
						tile_map[arr[1]]["flipped"] = matches[m]["flipped"]
					} else if (matches[m][2] == "right" && matches[m][1] == "right") {
						tile_map[arr[1]]["x"] = tile_map[arr[2]]["x"] + 1
						tile_map[arr[1]]["y"] = tile_map[arr[2]]["y"]
						tile_map[arr[1]]["rotate"] = 2
						tile_map[arr[1]]["flipped"] = matches[m]["flipped"]
					} else if (matches[m][2] == "right" && matches[m][1] == "bottom") {
						tile_map[arr[1]]["x"] = tile_map[arr[2]]["x"] + 1
						tile_map[arr[1]]["y"] = tile_map[arr[2]]["y"]
						tile_map[arr[1]]["rotate"] = 3
						tile_map[arr[1]]["flipped"] = matches[m]["flipped"]
					} else if (matches[m][2] == "bottom" && matches[m][1] == "left") {
						tile_map[arr[1]]["x"] = tile_map[arr[2]]["x"] + 1
						tile_map[arr[1]]["y"] = tile_map[arr[2]]["y"]
						tile_map[arr[1]]["rotate"] = 0
						tile_map[arr[1]]["flipped"] = matches[m]["flipped"]
					} else if (matches[m][2] == "bottom" && matches[m][1] == "top") {
						tile_map[arr[1]]["x"] = tile_map[arr[2]]["x"] + 1
						tile_map[arr[1]]["y"] = tile_map[arr[2]]["y"]
						tile_map[arr[1]]["rotate"] = 1
						tile_map[arr[1]]["flipped"] = matches[m]["flipped"]
					} else if (matches[m][2] == "bottom" && matches[m][1] == "right") {
						tile_map[arr[1]]["x"] = tile_map[arr[2]]["x"] + 1
						tile_map[arr[1]]["y"] = tile_map[arr[2]]["y"]
						tile_map[arr[1]]["rotate"] = 2
						tile_map[arr[1]]["flipped"] = matches[m]["flipped"]
					} else if (matches[m][2] == "bottom" && matches[m][1] == "bottom") {
						tile_map[arr[1]]["x"] = tile_map[arr[2]]["x"] + 1
						tile_map[arr[1]]["y"] = tile_map[arr[2]]["y"]
						tile_map[arr[1]]["rotate"] = 3
						tile_map[arr[1]]["flipped"] = matches[m]["flipped"]

					break
				case 1:
					break
				csee 2:
					break
				case 3:
					break
				}
			}
		}

	}
}

function reverse(str, _s, _i) {
	for (_i = length(str); _i > 0; _i--) {
		_s = _s substr(str, _i, 1)
	}
	return _s
}
