BEGIN {
	FPAT = "([FB]{7}|[LR]{3})"
	min = 99999999999999
}

{
	seat_id = 8 * compute_row($1) + compute_column($2)
	seats[seat_id] = 1
	if (seat_id > max) {
		max = seat_id
	}
	if (seat_id < min) {
		min = seat_id
	}
}

END {
	print max
	for (i = min; i < max; i++) {
		if (!(i in seats)) print i
	}
}

function compute_row(_space, _row) {
	_space = 128
	_row = 0
	for (i = 1; i <= length($1); i++) {
		_space /= 2
		if (substr($1, i, 1) == "B") {
			_row += _space
		}
	}
	return _row
}

function compute_column(_space, _column) {
	_space = 8
	_column = 0
	for (i = 1; i <= length($2); i++) {
		_space /= 2
		if (substr($2, i, 1) == "R") {
			_column += _space
		}
	}
	return _column
}
