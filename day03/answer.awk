BEGIN {
	row = 0
}

NR == 1 {
	cols = length($0)
}

{
	for (c = 0; c < cols; c++) {
		if (substr($0, c + 1, 1) == "#") {
			trees[row,c] = 1
		}
	}
	row++
}

END {
	printf "Part 1: %d\n", trees_on_slope(3, 1)	
	printf "Part 2: %d\n", trees_on_slope(1, 1) * trees_on_slope(3, 1) * trees_on_slope(5, 1) * trees_on_slope(7, 1) * trees_on_slope(1, 2)
}

function trees_on_slope(dx, dy) {
	x = 0
	y = 0
	n = 0
	while (y < row) {
		x = (x + dx) % cols
		y += dy
		if ((y,x) in trees) {
			n++
		}
	}
	return n
}
