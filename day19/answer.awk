BEGIN {
	FS = ": "
	parsing_rules = 1
}

parsing_rules {
	if (match($2, /"([a-z])"/, tmp)) {
		rules[$1] = tmp[1]
		p2rules[$1] = tmp[1]
	} else {
		split($2, tmp, "|")
		for (t in tmp) {
			split(tmp[t], rdata, " ")
			for (r in rdata) {
				rules[$1][t][r] = rdata[r]
				p2rules[$1][t][r] = rdata[r]
			}
		}
	}
}

$0 == "" {
	parsing_rules = 0
	for (rule in rules) {
		if (!isarray(rules[rule])) {
			terminals[rule] = rules[rule]
			delete rules[rule]
			p2terminals[rule] = p2rules[rule]
			delete p2rules[rule]
		}
	}
	while (!(0 in terminals)) {
		for (rule in rules) {
			if (is_all_terminal(rules[rule], terminals)) {
				terminals[rule] = create_regexp(rules[rule], terminals)
				delete rules[rule]
			}
		}
	}
	while (!(0 in p2terminals)) {
		for (rule in p2rules) {
			if (is_all_terminal(p2rules[rule], p2terminals)) {
				p2terminals[rule] = create_regexp(p2rules[rule], p2terminals)
				if (rule == 8) p2terminals[rule] = p2terminals[rule] "+"
				if (rule == 11) {
					p2terminals[rule] = "(" p2terminals[rule]
					for (i = 1; i < 10; i++) {
						p2terminals[rule] = p2terminals[rule] "|" p2terminals[42] "{" i "}" p2terminals[31] "{" i "}"
					}
					p2terminals[rule] = p2terminals[rule] ")"
				}
				delete p2rules[rule]
			}
		}
	}
	print p2terminals[0]
}

!parsing_rules && $0 ~ "^" terminals[0] "$" {
	p1++
}

!parsing_rules && $0 ~ "^" p2terminals[0] "$" {
	p2++
}

END {
	print p1
	print p2
}

function is_all_terminal(rule, terminals, _b, _part, _p) {
	_b = 1
	for (_part in rule) {
		for (_p in rule[_part]) {
			if (!(rule[_part][_p] in terminals)) {
				_b = 0
				break
			}
		}
	}
	return _b
}

function create_regexp(rule, terminals, _s, _p, _i) {
	_s = length(rule) > 1 ? "(" : ""
	for (_p in rule[1]) {
		_s = _s terminals[rule[1][_p]]
	}
	for (_i = 2; _i <= length(rule); _i++) { 
		_s = _s "|"
		for (_p in rule[_i]) {
			_s = _s terminals[rule[_i][_p]]
		}
	}
	if (length(rule) == 2) _s = _s ")"
	return _s
}
