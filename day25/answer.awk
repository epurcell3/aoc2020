NR == 1 {
	v = 1
	ns = 7
	do {
		c_loop++
		v *= ns
		v %= 20201227
	} while (v != $1)
	card_pub = v
}

NR == 2 {
	v = 1
	ns = 7
	do {
		d_loop++
		v *= ns
		v %= 20201227
	} while (v != $1)
	door_pub = v
}

END {
	vd = 1
	for (n = 0; n < c_loop; n++) {
		vd *= door_pub
		vd %= 20201227
	}
	print vd
	vc = 1
	for (n = 0; n < d_loop; n++) {
		vc *= card_pub
		vc %= 20201227
	}
	print vc
}
