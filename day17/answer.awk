BEGIN { 
	FS = ""

	for (x = -1; x <= 1; x++) {
		for (y = -1; y <= 1; y++) {
			for (z = -1; z <= 1; z++) {
				if (x != 0 || y != 0 || z != 0) {
					neighbor_d[x,y,z] = 1
				}
				for (w = -1; w <= 1; w++) {
					if (x != 0 || y != 0 || z != 0 || w != 0) {
						p2_neighbor_d[x,y,z,w] = 1
					}
				}
			}
		}
	}
}

{
	for (x = 1; x <= NF; x++) {
		if ($x == "#") {
			actives[x,NR,0] = 1
			p2_actives[x,NR,0,0] = 1
		}
	}
}

END {
	for (i = 6; i > 0; i--) {
		delete inactives
		delete new_actives
		for (cube in actives) {
			n = n_active_neighbors(cube)
			if (n == 2 || n == 3) {
				new_actives[cube] = 1
			}
			find_relevant_inactives(cube)
		}
		for (cube in inactives) {
			n = n_active_neighbors(cube)
			if (n == 3) {
				new_actives[cube] = 1
			}
		}
		delete actives
		for (cube in new_actives) {
			actives[cube] = new_actives[cube]
		}
	}
	print length(actives)
}

END {
	for (i = 6; i > 0; i--) {
		delete p2_inactives
		delete p2_new_actives
		for (cube in p2_actives) {
			n = p2_n_active_neighbors(cube)
			if (n == 2 || n == 3) {
				p2_new_actives[cube] = 1
			}
			p2_find_relevant_inactives(cube)
		}
		for (cube in p2_inactives) {
			n = p2_n_active_neighbors(cube)
			if (n == 3) {
				p2_new_actives[cube] = 1
			}
		}
		delete p2_actives
		for (cube in p2_new_actives) {
			p2_actives[cube] = p2_new_actives[cube]
		}
	}
	print length(p2_actives)
}

function n_active_neighbors(cube, dimensionlity, _n) {
	_n = 0;
	split(cube, coords, SUBSEP)
	for (neighbor in neighbor_d) {
		split(neighbor, deltas, SUBSEP)
		if ((coords[1] + deltas[1], coords[2] + deltas[2], coords[3] + deltas[3]) in actives) {
			_n++
		}
	}
	return _n
}

function find_relevant_inactives(cube, dimensionlity) {
	split(cube, coords, SUBSEP)
	for (neighbor in neighbor_d) {
		split(neighbor, deltas, SUBSEP)
		if (!((coords[1] + deltas[1], coords[2] + deltas[2], coords[3] + deltas[3]) in actives)) {
			inactives[coords[1] + deltas[1], coords[2] + deltas[2], coords[3] + deltas[3]] = 1
		}
	}
}

function p2_n_active_neighbors(cube, _n) {
	_n = 0;
	split(cube, coords, SUBSEP)
	for (neighbor in p2_neighbor_d) {
		split(neighbor, deltas, SUBSEP)
		if ((coords[1] + deltas[1], coords[2] + deltas[2], coords[3] + deltas[3], coords[4] + deltas[4]) in p2_actives) {
			_n++
		}
	}
	return _n
}

function p2_find_relevant_inactives(cube) {
	split(cube, coords, SUBSEP)
	for (neighbor in p2_neighbor_d) {
		split(neighbor, deltas, SUBSEP)
		if (!((coords[1] + deltas[1], coords[2] + deltas[2], coords[3] + deltas[3], coords[4] + deltas[4]) in p2_actives)) {
			p2_inactives[coords[1] + deltas[1], coords[2] + deltas[2], coords[3] + deltas[3], coords[4] + deltas[4]] = 1
		}
	}
}
