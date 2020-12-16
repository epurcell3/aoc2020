BEGIN {
	FPAT = "([a-z ]+|[[:digit:]]+)"
	rules = 1
	p1_range_min = 999999
}

$0 == "your ticket:" {
	FS = ","
	rules = 0
}

!!rules && $1 {
	rule[$1]["min1"] = $3
	rule[$1]["max1"] = $4
	rule[$1]["min2"] = $6
	rule[$1]["max2"] = $7

	if ($3 < p1_range_min) {
		p1_range_min = $3
	}
	if ($7 > p1_range_max) p1_range_max = $7
}

!!your_ticket && $1 && $1 != "nearby tickets:" {
	my_ticket = NR
	for (i = 1; i <= NF; i++) {
		valid_tickets[i][NR] = $i
	}
}

!!other_tickets {
	invalid = 0
	for (i = 1; i <= NF; i++) {
		if ($i < p1_range_min || $i > p1_range_max) {
			sum += $i
			invalid = 1
		}
	}
	if (!invalid) {
		for (i = 1; i <= NF; i++) {
			valid_tickets[i][NR] = $i
		}
	}
}

$0 == "your ticket:" {
	your_ticket = 1
}

$0 == "nearby tickets:" {
	other_tickets = 1
	your_ticket = 0
}

END {
	print sum
	for (i = 1; i <= NF; i++) {
		for (field in rule) {
			possible_field[i][field] = 1
		}
	}
	i = 1
	while (1) {
		#print "Start of loop", i
		delete bad_fields
		for (field in possible_field[i]) {
			for (ticket in valid_tickets[i]) {
				if (!is_valid(valid_tickets[i][ticket], rule[field]["min1"], rule[field]["max1"], rule[field]["min2"], rule[field]["max2"])) {
					#print "Invalid field", field, valid_tickets[i][ticket], rule[field]["min1"], rule[field]["max1"], rule[field]["min2"], rule[field]["max2"]
					bad_fields[field] = 1
					break
				}
			}
		}
		for (field in bad_fields) {
			#print "Deleting possible field", field
			delete possible_field[i][field]
		}
		if (length(possible_field[i]) == 1) {
			# Shitty way to do this, not sure how to make it better...
			for (field in possible_field[i]) {
				known_field[i] = field
			}
			#print "Known field", known_field[i]
			for (j in possible_field) {
				if (j != i) {
					delete possible_field[j][known_field[i]]
				}
			}
		}
		if (length(known_field) == NF) break
		i++
		if (i > NF) i -= NF
	}

	part2 = 1
	for (f in known_field) {
		if (match(known_field[f], /^departure/)) {
			part2 *= valid_tickets[f][my_ticket]
		}
	}
	print part2
}

function is_valid(n, min1, max1, min2, max2) {
	return (n >= min1 && n <= max1) || (n >= min2 && n <= max2)
}
