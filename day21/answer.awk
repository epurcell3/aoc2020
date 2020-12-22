BEGIN {
	FS = "( \\\(contains |\\\))"
	PROCINFO["sorted_in"] = "@ind_str_asc"
}

{
	split($1, ingredients, " ")
	split($2, allergens, ", ")
	for (i in ingredients) known_ingredients[ingredients[i]]++
	for (a in allergens) {
		for (i in ingredients) {
			possible_allergen[allergens[a]][NR][ingredients[i]]++
		}
	}
}

END {
	for (allergen in possible_allergen) {
		for (i in possible_allergen[allergen]) {
			set_init(possible_allergen[allergen][i], ingredient_set)
			break
		}
		for (i in possible_allergen[allergen]) {
			set_and(ingredient_set, possible_allergen[allergen][i], tmp_set)
			set_init(tmp_set, ingredient_set)
		}
		for (i in ingredient_set) {
			allergen_warning[allergen][i] = 1
		}
	}
	done = 0
	do {
		done = 1
		for (allergen in allergen_warning) {
			if (length(allergen_warning[allergen]) == 1) {
				for (single_ingredient in allergen_warning[allergen]) {
					for (allergen2 in allergen_warning) {
						if (allergen != allergen2) {
							delete allergen_warning[allergen2][single_ingredient]
						}
					}
				}
			} else {
				done = 0
			}
		}
	} while (!done)
	for (allergen in allergen_warning) {
		for (single_ingredient in allergen_warning[allergen]) {
			bad_ingredients[single_ingredient] = 1
		}
	}
	set_without(known_ingredients, bad_ingredients, good_ingredients)
	for (ing in good_ingredients) {
		p1 += good_ingredients[ing]
	}
	print p1
	for (allergen in allergen_warning) {
		for (single_ing in allergen_warning[allergen]) {
			p2 = p2 "," single_ing
		}
	}
	p2 = substr(p2, 2)
	print p2
}

function set_init(source, dist,		i) {
	delete dist
	for (i in source) dist[i] = source[i]
}


function set_and(first, second, result,      i) {
	delete result
	for (i in first) {
		if (i in second) result[i] = first[i]
	}
}

function set_without(first, second, result,		i) {
	delete result
	for (i in first) {
		if (!(i in second)) {
			result[i] = first[i]
		}
	}
}

function print_set(set,		i) {
	for (i in set) {
		print i
	}
}
