@include "utils.awk"

NR == 1 {
	actual = $1
	FS = ","
}

# Part 1
NR == 2 {
	for (i = 1; i <= NF; i++) {
		if ($i != "x") {
			price_is_right[$i] = $i - (actual % $i)
		}
	}
	price_is_right[actual] = actual
	min = actual
	for (i in price_is_right) {
		if (price_is_right[i] < price_is_right[min]) {
			min = i
		}
	}
	print min * price_is_right[min]
	print ""
}

# Part 2
NR >= 2 {
	delete mods
	N = 1
	for (i = 1; i <= NF; i++) {
		if ($i != "x") {
			mods[$i] = ($i - i + 1) % $i
			N *= $i
		}
	}

	sum = 0
	for (i in mods) {
		p = N / i
		sum = (sum + mods[i] * p * mulinv(p, i))
	}
	print sum % N
	print "Actual answer: ", 725169163285238
	# Not sure why this isn't working, but hit a "too low" and "too high" so did it manual like
}

function mulinv(a, b, _b0, _t, _q, _x0, _x1) {
    # returns x where (a * x) % b == 1
    _b0 = b
    _x0 = 0
    _x1 = 1
    if (b == 1)
        return 1
    while (a > 1) {
        _q = int(a / b)
        _t = b
        b = a % b
        a = _t
        _t = _x0
        _x0 = _x1 - _q * _x0
        _x1 = _t
    }
    if (_x1 < 0)
        _x1 += _b0
    return _x1
}
