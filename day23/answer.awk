BEGIN {
	FS = ""
}

{
	curr_cup = $1
	p2curr_cup = $1
	for (i = 1; i < NF; i++) {
		cups[$i] = $(i + 1)
		p2cups[$i] = $(i + 1)
	}
	cups[$NF] = $1
	p2cups[$NF] = NF + 1
	for (i = NF + 1; i < 1000000; i++) p2cups[i] = i + 1
	p2cups[1000000] = $1
}

END {
	do {
		curr_cup = exec_round(curr_cup, cups)
	} while (++turns < 100)
	print_from_1()

	do {
		p2curr_cup = exec_round(p2curr_cup, p2cups)
	} while (++p2turns < 10000000)
	print p2cups[1] * p2cups[p2cups[1]]
}

function pick_up(curr_cup, cups, picked_up,		c) {
	delete picked_up
	c = curr_cup
	for (i = 1; i <=3; i++) {
		c = cups[c]
		picked_up[i] = c
	}
}

function exec_round(curr_cup, cups,		picked_up, dest) {
	#print_from_1()

	pick_up(curr_cup, cups, picked_up)

	#printf "Picked up: "
	#for (i in picked_up) printf "%d, ", picked_up[i]
	#print ""

	cups[curr_cup] = cups[picked_up[3]]
	dest = curr_cup
	do {
		if (--dest == 0) dest = length(cups)
	} while (picked_up[1] == dest || picked_up[2] == dest || picked_up[3] == dest)
	#print "Dest: " dest
	#print ""
	cups[picked_up[3]] = cups[dest]
	cups[picked_up[2]] = picked_up[3]
	cups[picked_up[1]] = picked_up[2]
	cups[dest] = picked_up[1]

	return cups[curr_cup]
}

function print_from_1() {
	c = cups[1]
	while (c != 1) {
		printf "%d", c
		c = cups[c]
	}
	print ""
}
