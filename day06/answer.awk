BEGIN {
	RS = "\n\n"
}

{
	delete questions
	for (i = 1; i <= NF; i++) {
		for (j = 1; j <= length($i); j++) {
			q = substr($i, j, 1)
			if (match(q, /[a-z]/) != 0) questions[q] += 1
		}
	}
	for (i in questions) {
		groups[NR] += 1
	}
	for (i in questions) {
		if (questions[i] == NF) all_in_group[NR] += 1
	}
}

END {
	sum = 0
	for (i in groups) sum += groups[i]
	print sum
	for (i in all_in_group) sum2 += all_in_group[i]
	print sum2
}

