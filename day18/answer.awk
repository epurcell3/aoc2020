BEGIN {
	FPAT = "(\\\(|\\\)|[0-9]+|*|+)"
}

{
	delete partials
	delete next_op
	level = 0
	next_op[level] = "+"
	for (i = 1; i <= NF; i++) {
		#print level, partials[level], next_op[level], $i
		if ($i == "+" || $i == "*") next_op[level] = $i
		if (match($i, /[0-9]+/)) {
			switch (next_op[level]) {
			case "+":
				partials[level] += $i
				break
			case "*":
				partials[level] *= $i
				break
			}
		}
		if ($i == "(") next_op[++level] = "+"
		if ($i == ")") {
			switch (next_op[--level]) {
			case "+":
				partials[level] += partials[level + 1]
				break
			case "*":
				partials[level] *= partials[level + 1]
				break
			}
			delete partials[level + 1]
			delete next_op[level + 1]
		}
	}
	#print partials[0]
	sum += partials[0]
}

/^\(/ {
	$0 = "0 + " $0
}

/\(\(/ {
	gsub(/\(\(/, "(0 + (")
}

{
	delete last_root
	delete dangled
	delete tree
	level = 0
	key = 0
	i = 1
	left_child = 0
	op = "+"
	for (i = 1; i <= NF; i++) {
		if(match($i, /[0-9]+/)) {
			tree["op" key][1] = left_child
			tree["op" key][2] = $i
			tree["op" key]["op"] = op
			if(!(level in last_root) || op != "+") {
				last_root[level] = key
			}
			key++
		} else if ($i == "+") {
			#break the right child to force the +
			left_child = tree["op" last_root[level]][2]
			op = $i
			tree["op" last_root[level]][2] = "op" key
		} else if ($i == "*") {
			left_child = "op" last_root[level]
			op = $i
		} else if ($i == "(") {
			tree["op" key][1] = left_child
			tree["op" key]["op"] = op
			if (op == "*") last_root[level] = key
			dangled[level] = key++
			level++
			left_child = 0
			op = "+"
		} else if ($i == ")") {
			tree["op" dangled[level - 1]][2] = "op" last_root[level]
			delete last_root[level--]
			delete dangled[level]
		}
	}
	#print $0
	tmp = eval(tree, "op" last_root[0])
	p2_sum += tmp
	#print tmp
	#print ""
}

END {
	print sum
	print p2_sum
}

function eval(tree, root, _l, _r) {
	if (tree[root][1] in tree) {
		_l = eval(tree, tree[root][1])
	} else {
		_l = tree[root][1]
	}
	if (tree[root][2] in tree) {
		_r = eval(tree, tree[root][2])
	} else {
		_r = tree[root][2]
	}
	switch (tree[root]["op"]) {
	case "+":
		#print root, ": ("tree[root][1]")", _l, "+", "("tree[root][2]")", _r, "=", _l + _r
		return _l + _r
		break
	case "*":
		#print root, ": ("tree[root][1]")", _l, "*", "("tree[root][2]")", _r, "=", _l * _r
		return _l * _r
		break
	}
}
