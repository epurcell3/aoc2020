BEGIN {
	FPAT = "[NSEWLRF]|[0-9]+"
	d = 0
	wx = 10
	wy = 1
}

{
	switch ($1) {
	case "N":
		y += $2
		break
	case "S":
		y -= $2
		break
	case "E":
		x += $2
		break
	case "W":
		x -= $2
		break
	case "L":
		d = (d + $2) % 360
		break
	case "R":
		d = (d - $2 + 360) % 360
		break
	case "F":
		switch (d) {
		case 0:
			x += $2
			break
		case 90:
			y += $2
			break
		case 180:
			x -= $2
			break
		case 270:
			y -= $2
			break
		}
		break
	}
}

{
	switch ($1) {
	case "N":
		wy += $2
		break
	case "S":
		wy -= $2
		break
	case "E":
		wx += $2
		break
	case "W":
		wx -= $2
		break
	case "L":
		for (i = 0; i < $2; i += 90) {
			tmp = -1 * wy
			wy = wx
			wx = tmp
		}
		break
	case "R":
		for (i = 0; i < $2; i += 90) {
			tmp = -1 * wx
			wx = wy
			wy = tmp
		}
		break
	case "F":
		x2 += wx * $2
		y2 += wy * $2
		break
	}
}

END {
	print abs(x) + abs(y)
	print abs(x2) + abs(y2)
}

function abs(n) {
	return n < 0 ? n * -1 : n
}
