BEGIN {
	FPAT = "(nw|ne|sw|se|w|e)"
}

{
	x = 0
	y = 0
	for (i = 1; i <= NF; i++) {
		switch ($i) {
		case "e":
			x++
			break
		case "w":
			x--
			break
		case "se":
			x += abs(y) % 2
			y++
			break
		case "sw":
			x -= abs(y + 1) % 2
			y++
			break
		case "ne":
			x += abs(y) % 2
			y--
			break
		case "nw":
			x -= abs(y + 1) % 2
			y--
			break
		}
		#printf "%s: (%d, %d)\n", $i, x, y
	}
	tiles[x,y] = 1
	if ((x,y) in black_tiles) {
		#print x, y, "flip white"
		delete black_tiles[x,y]
	} else {
		#print x, y, "flip black"
		black_tiles[x,y] = 1
	}
}

END {
	print length(black_tiles)

	# init tiles array
	for (tile in tiles) tiles[tile] = tile in black_tiles
	#for (tile in tiles) print tile, tiles[tile]

	#neighbors(1 SUBSEP 2, searching)
	#print "Neighbors of 1,2"
	#for (tile in searching) print tile
	#print ""

	while (days++ < 100) {
		# Add neighbors for consideration
		delete new_tiles
		for (tile in tiles) {
			neighbors(tile, searching)
			for (n in searching) {
				if (!(n in tiles)) new_tiles[n] = 0
			}
		}
		#print "Tile count pre:", length(tiles), length(new_tiles)
		for (tile in new_tiles) tiles[tile] = new_tiles[tile]
		#print "Tile count post:", length(tiles)

		# Run the rules
		delete new_tiles
		for (tile in tiles) {
			if (tiles[tile] == 1) {
				neighbors(tile, searching)
				b = 0
				for (t in searching) {
					if (t in tiles && tiles[t] == 1) b++
				}
				new_tiles[tile] = !(b == 0 || b > 2)
				#print tile, tiles[tile], new_tiles[tile]
			} else if (tiles[tile] == 0) {
				neighbors(tile, searching)
				b = 0
				for (t in searching) {
					if (t in tiles && tiles[t] == 1) b++
				}
				new_tiles[tile] = b == 2
				#print tile, tiles[tile], new_tiles[tile]
			}
			
		}
		delete tiles
		for (tile in new_tiles) {
			tiles[tile] = new_tiles[tile]
		}
		#print "Tile count later:", length(tiles)
	}
	p2 = 0
	for (tile in tiles) {
		if (tiles[tile] == 1) p2++
	}
	print p2
} 

function abs(n) {
	return n >= 0 ? n : -1 * n
}

function neighbors(xy, searching,		arr) {
	delete searching
	split(xy, arr, SUBSEP)
	if (abs(arr[2]) % 2 == 1) {
		searching[arr[1]    , arr[2] - 1] = 1
		searching[arr[1] + 1, arr[2] - 1] = 1
		searching[arr[1] + 1, arr[2]    ] = 1
		searching[arr[1] + 1, arr[2] + 1] = 1
		searching[arr[1]    , arr[2] + 1] = 1
		searching[arr[1] - 1, arr[2]    ] = 1
	} else {
		searching[arr[1]    , arr[2] - 1] = 1
		searching[arr[1] - 1, arr[2] - 1] = 1
		searching[arr[1] + 1, arr[2]    ] = 1
		searching[arr[1] - 1, arr[2] + 1] = 1
		searching[arr[1]    , arr[2] + 1] = 1
		searching[arr[1] - 1, arr[2]    ] = 1
	}
}

