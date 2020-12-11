BEGIN {
	FS = ""
}

NR == 1 {
	cols = NF
}

{
	for (i = 1; i <= NF; i++) {
		grid[NR,i] = $i
		p2_grid[NR,i] = $i
	}
}

END {
	delete new_grid
	delete p2_new_grid
	build_p2_neighbor_map()
	changes = 1
	while (changes) {
		changes = 0
		for (row = 1; row <= NR; row++) {
			for (col = 1; col <= NF; col++) {
				switch (grid[row,col]) {
				case "L":
					if (n_occupied_seats(row, col) == 0) {
						changes++
						new_grid[row,col] = "#"
					} else {
						new_grid[row,col] = "L"
					}
					break
				case "#":
					if (n_occupied_seats(row, col) >= 4) {
						changes++
						new_grid[row,col] = "L"
					} else {
						new_grid[row,col] = "#"
					}
					break
				case ".":
					new_grid[row,col] = "."
					p2_new_grid[row,col] = "."
					break
				}
			}
		}
		
		# Replace grid womp womp
		for (row = 1; row <= NR; row++) {
			for (col = 1; col <= NF; col++) {
				grid[row,col] = new_grid[row,col]
			}
		}
	}
	for (row = 1; row <= NR; row++) {
		for (col = 1; col <= NF; col++) {
			if (grid[row,col] == "#") {
				occupied_seats++
			}
		}
	}
	print occupied_seats

	occupied_seats = 0
	changes = 1
	while (changes) {
		changes = 0
		for (row = 1; row <= NR; row++) {
			for (col = 1; col <= NF; col++) {
				switch (p2_grid[row,col]) {
				case "L":
					if (p2_n_occupied_seats(row, col) == 0) {
						changes++
						p2_new_grid[row,col] = "#"
					} else {
						p2_new_grid[row,col] = "L"
					}
					break
				case "#":
					if (p2_n_occupied_seats(row, col) >= 5) {
						changes++
						p2_new_grid[row,col] = "L"
					} else {
						p2_new_grid[row,col] = "#"
					}
					break
				case ".":
					p2_new_grid[row,col] = "."
					break
				}
			}
		}
		
		# Replace grid womp womp
		for (row = 1; row <= NR; row++) {
			for (col = 1; col <= NF; col++) {
				p2_grid[row,col] = p2_new_grid[row,col]
			}
		}
	}
	for (row = 1; row <= NR; row++) {
		for (col = 1; col <= NF; col++) {
			if (p2_grid[row,col] == "#") {
				occupied_seats++
			}
		}
	}
	print occupied_seats
}

function n_occupied_seats(r, c, _n) {
	_n = 0
	if ((r-1, c-1) in grid) _n += (grid[r-1,c-1] == "#")
	if ((r-1, c)   in grid) _n += (grid[r-1,c]   == "#")
	if ((r-1, c+1) in grid) _n += (grid[r-1,c+1] == "#")
	if ((r  , c-1) in grid) _n += (grid[r  ,c-1] == "#")
	if ((r  , c+1) in grid) _n += (grid[r  ,c+1] == "#")
	if ((r+1, c-1) in grid) _n += (grid[r+1,c-1] == "#")
	if ((r+1, c)   in grid) _n += (grid[r+1,c]   == "#")
	if ((r+1, c+1) in grid) _n += (grid[r+1,c+1] == "#")
	return _n
}

function p2_n_occupied_seats(r, c, _n) {
	_n = 0
	for (d in p2_neighbor_map[r,c]) {
		_n += (p2_grid[p2_neighbor_map[r,c][d]["r"],p2_neighbor_map[r,c][d]["c"]] == "#")
	}
	return _n
}

function build_p2_neighbor_map() {
	for (r = 1; r <= NR; r++) {
		for (c = 1; c <= NF; c++) {
			# NW direction
			dr = r - 1
			dc = c - 1
			while ((dr,dc) in p2_grid) {
				if (p2_grid[dr,dc] == "L") {
					p2_neighbor_map[r,c]["NW"]["r"] = dr
					p2_neighbor_map[r,c]["NW"]["c"] = dc
					break
				} else {
					dr -= 1
					dc -= 1
				}
			}
			# N direction
			dr = r - 1
			dc = c
			while ((dr,dc) in p2_grid) {
				if (p2_grid[dr,dc] == "L") {
					p2_neighbor_map[r,c]["N"]["r"] = dr
					p2_neighbor_map[r,c]["N"]["c"] = dc
					break
				} else {
					dr -= 1
				}
			}
			# NE direction
			dr = r - 1
			dc = c + 1
			while ((dr,dc) in p2_grid) {
				if (p2_grid[dr,dc] == "L") {
					p2_neighbor_map[r,c]["NE"]["r"] = dr
					p2_neighbor_map[r,c]["NE"]["c"] = dc
					break
				} else {
					dr -= 1
					dc += 1
				}
			}
			# E direction
			dr = r
			dc = c + 1
			while ((dr,dc) in p2_grid) {
				if (p2_grid[dr,dc] == "L") {
					p2_neighbor_map[r,c]["E"]["r"] = dr
					p2_neighbor_map[r,c]["E"]["c"] = dc
					break
				} else {
					dc += 1
				}
			}
			# SE direction
			dr = r + 1
			dc = c + 1
			while ((dr,dc) in p2_grid) {
				if (p2_grid[dr,dc] == "L") {
					p2_neighbor_map[r,c]["SE"]["r"] = dr
					p2_neighbor_map[r,c]["SE"]["c"] = dc
					break
				} else {
					dr += 1
					dc += 1
				}
			}
			# S direction
			dr = r + 1
			dc = c
			while ((dr,dc) in p2_grid) {
				if (p2_grid[dr,dc] == "L") {
					p2_neighbor_map[r,c]["S"]["r"] = dr
					p2_neighbor_map[r,c]["S"]["c"] = dc
					break
				} else {
					dr += 1
				}
			}
			# SW direction
			dr = r + 1
			dc = c - 1
			while ((dr,dc) in p2_grid) {
				if (p2_grid[dr,dc] == "L") {
					p2_neighbor_map[r,c]["SW"]["r"] = dr
					p2_neighbor_map[r,c]["SW"]["c"] = dc
					break
				} else {
					dr += 1
					dc -= 1
				}
			}
			# W direction
			dr = r
			dc = c - 1
			while ((dr,dc) in p2_grid) {
				if (p2_grid[dr,dc] == "L") {
					p2_neighbor_map[r,c]["W"]["r"] = dr
					p2_neighbor_map[r,c]["W"]["c"] = dc
					break
				} else {
					dc -= 1
				}
			}
		}
	}
}
