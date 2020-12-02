BEGIN {
	FS = ": "
	total = 0
}

{
	total = total + 1
	match($1, /([0-9]+)-([0-9]+) ([a-z])/, rule)
	min = rule[1]
	max = rule[2]
	char = rule[3]

	count = split($2, bits, char) - 1
	#printf "%s %s %s %s %d %d\n", min, max, char, $2, count, total

	if (count >= min && count <= max) {
		valid_passes[$2] = valid_passes[$2] + 1
	} else {
		invalid_passes[$2] = invalid_passes[$2] + 1
	}

	if ((substr($2, min, 1) == char && substr($2, max, 1) != char) ||
	     (substr($2, min, 1) != char && substr($2, max, 1) == char)) {
		part2_valid[$2] = part2_valid[$2] + 1
	} else {
		part2_invalid[$2] = part2_invalid[$2] + 1
	}
}

END {
	printf "Duplicate row 3-4 b: bbbb, whyyyy?\n"
	printf "Valid: %d, Invalid: %d, Total: %d/%d\n", alen(valid_passes), alen(invalid_passes), alen(valid_passes) + alen(invalid_passes), total
	printf "Valid: %d, Invalid: %d, Total: %d/%d\n", alen(part2_valid), alen(part2_invalid), alen(part2_valid) + alen(part2_invalid), total
}

function alen(a, i, k) {
	k = 0
	for (i in a) k = k + a[i]
	return k
}
