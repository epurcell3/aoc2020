BEGIN {
	FS = " bags contain "
}

$2 == "no other bags." {
	#printf "Nothing in %s bags\n", $1
	rules[$1] = "empty"
}

$2 != "no other bags." {
	split($2, inner_bags, ", ")
	for (i in inner_bags) {
		match(inner_bags[i], /([0-9]+) ([a-z]+ [a-z]+) bags?/, parts)
		#printf "%s in %s bags\n", parts[2], $1
		rules[$1][parts[2]] = parts[1]
	}
}

END {
	for (rule in rules) {
		if (rule_has_shiny_gold(rule)) {
			count++
		}
	}
	print count
	print nbags("shiny gold", 0)
}

function rule_has_shiny_gold(rule) {
	if (!isarray(rules[rule])) return 0
	if ("shiny gold" in rules[rule]) return 1
	for (subrule in rules[rule]) {
		if (rule_has_shiny_gold(subrule)) return 1
	}
	return 0
}

function nbags(rule, sum) {
	if (!isarray(rules[rule])) return 0
	for (subrule in rules[rule]) {
		sum += rules[rule][subrule] + rules[rule][subrule] * nbags(subrule, 0)
	}
	return sum
}
