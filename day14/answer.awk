BEGIN {
	# mask = 100X100X101011111X100000100X11010011
	# mem[33323] = 349380
	FPAT = "(mask|[10X]+|mem|[0-9]+)"
}

# Part 1
$1 == "mask" {
	#_mask = $2
	split($2, mask, "")
	val = 2^35
	or_mask = 0
	and_mask = 0
	for (i in mask) {
		switch (mask[i]) {
		case "1":
			or_mask += val
		case "X":
			and_mask += val
			break
		}
		val /= 2
	}
}

# Part 2
$1 == "mask" {
	val = 2^35
	xi = 1
	delete xs
	delete mem_mods
	p2_and_mask = 0
	mem_mods[0] = 1
	nx = 0
	for (i in mask) {
		#printf "%s", mask[i]
		switch (mask[i]) {
		case "0":
			p2_and_mask += val
			break
		case "X":
			delete new_mem_mods
			for (i in mem_mods) {
				new_mem_mods[i + val] = 1
			}
			for (i in new_mem_mods) {
				mem_mods[i] = 1
			}
			break
		}
		val /= 2
	}
	#print ""
	#print ""
}

# Part 1
$1 == "mem" {
	#printf "%s\n%s\n%s\n\n", n_to_bstring($3), _mask, n_to_bstring(and(or($3, or_mask), and_mask))
	mem[$2] = and(or($3, or_mask), and_mask)
}

# Part 2
$1 == "mem" {
	partial_mem = or(and($2, p2_and_mask), or_mask)
	for (i in mem_mods) {
		#printf "%d + %d = %d\n", partial_mem, i, partial_mem + i
		p2_mem[partial_mem + i] = $3
	}
}


END {
	for (i in mem) {
		sum += mem[i]
	}
	print sum
	sum = 0
	for (i in p2_mem) {
		#printf "%s: %s (%d)\n", i, n_to_bstring(p2_mem[i]), p2_mem[i]
		sum += p2_mem[i]
	}
	print sum
}

function n_to_bstring(n, _str, _n) {
	_n = 2^35
	while (_n >= 1) {
		if (n >= _n) {
			_str = _str"1"
			n -= _n
		} else {
			_str = _str"0"
		}
		_n /= 2
	}
	return _str
}
