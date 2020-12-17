BEGIN { 
	FS = ""
	SUBSEP = ","

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
			n = n_active_neighbors(cube, 3, neighbor_d, actives)
			if (n == 2 || n == 3) {
				new_actives[cube] = 1
			}
			find_relevant_inactives(cube, 3, neighbor_d, actives, inactives)
		}
		for (cube in inactives) {
			n = n_active_neighbors(cube, 3, neighbor_d, actives)
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
			n = n_active_neighbors(cube, 4, p2_neighbor_d, p2_actives)
			if (n == 2 || n == 3) {
				p2_new_actives[cube] = 1
			}
			find_relevant_inactives(cube, 4, p2_neighbor_d, p2_actives, p2_inactives)
		}
		for (cube in p2_inactives) {
			n = n_active_neighbors(cube, 4, p2_neighbor_d, p2_actives)
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

function n_active_neighbors(cube, cardinality, neighbors, active, _n, _key, _i) {
	_n = 0;
	split(cube, coords, SUBSEP)
	for (neighbor in neighbors) {
		split(neighbor, deltas, SUBSEP)
		_key = (coords[1] + deltas[1])
		for (_i = 2; _i <= cardinality; _i++) _key = _key SUBSEP (coords[_i] + deltas[_i])
		if (_key in active) {
			_n++
		}
	}
	return _n
}

function find_relevant_inactives(cube, cardinality, neighbors, actives, inactives, _key, _i) {
	split(cube, coords, SUBSEP)
	for (neighbor in neighbors) {
		split(neighbor, deltas, SUBSEP)
		_key = (coords[1] + deltas[1])
		for (_i = 2; _i <= cardinality; _i++) _key = _key SUBSEP (coords[_i] + deltas[_i])
		if (!(_key in actives)) {
			inactives[_key] = 1
		}
	}
}
